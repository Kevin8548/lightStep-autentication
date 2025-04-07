import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Usa íconos modernos
import 'package:firebase_database/firebase_database.dart'; // Firebase Database

class AppbarStyle extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;

  const AppbarStyle({
    super.key,
    required this.title,
    this.bottom, // Agregar parámetro para la barra de pestañas
  });

  @override
  _AppbarStyleState createState() => _AppbarStyleState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _AppbarStyleState extends State<AppbarStyle> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(
        "ledEstado",
      );
  bool ledState = false; // Estado de las luces, por defecto apagadas

  void toggleLed() async {
    try {
      // Si las luces están apagadas, encenderlas; si están encendidas, apagarlas.
      String newState = ledState ? "off" : "on"; // Alternar estado
      await dbRef.set({
        "estado": newState,
        "fecha": DateTime.now().toIso8601String(),
      });

      setState(() {
        ledState = !ledState; // Cambiar el estado de la luz
      });

      String message = ledState
          ? "✅ Luces encendidas correctamente"
          : "✅ Luces apagadas correctamente";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: 1)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error al cambiar el estado de las luces: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'LightStep',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'PoetsenOne',
          fontWeight: FontWeight.w400,
          fontSize: 26,
        ),
      ),
      toolbarHeight: 80, // Ajusta la altura del AppBar
      leading: Padding(
        padding: const EdgeInsets.all(1),
        child: SvgPicture.asset(
          'assets/img/logo.svg',
          width: 150, // Tamaño deseado
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Borde externo circular
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(0, 255, 153, 0),
                  Color.fromARGB(0, 255, 153, 0),
                  Color.fromARGB(255, 246, 88, 211),
                  Color.fromARGB(0, 255, 153, 0),
                  Color.fromARGB(0, 255, 153, 0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(4), // Espacio para el borde externo
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Borde interno circular
                color: const Color.fromARGB(
                  255,
                  44,
                  1,
                  51,
                ), // Color de fondo interno
              ),
              padding: const EdgeInsets.all(5), // Espacio para el borde externo
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Borde interno circular
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 246, 88, 211),
                      Color.fromARGB(251, 142, 86, 240),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(
                  3,
                ), // Espacio para el borde interno
                child: Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 246, 88, 211),
                        Color.fromARGB(251, 142, 86, 240),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(
                    0,
                  ), // Espacio para el borde interno
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ledState
                          ? const Color.fromARGB(
                              255,
                              1,
                              55,
                              63,
                            ) // Color fijo (encendido)
                          : const Color.fromARGB(
                              255,
                              44,
                              1,
                              51,
                            ), // Color apagado
                    ),
                    child: IconButton(
                      icon: Icon(
                        ledState
                            ? LucideIcons.power // Ícono para encendido
                            : LucideIcons.powerOff, // Ícono para apagado
                        color: Colors.white,
                      ),
                      onPressed: toggleLed, // Llamar al método para alternar
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      bottom: widget.bottom, // Se asigna el TabBar aquí
    );
  }
}


// class TabBarStyle extends StatelessWidget implements PreferredSizeWidget {
//   final List<Tab> tabs;
//   final TabController? controller;

//   const TabBarStyle({super.key, required this.tabs, this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return TabBar(
//       tabs: tabs,
//       controller: controller ?? DefaultTabController.of(context),
//       labelColor: Colors.white,
//       unselectedLabelColor: Colors.white70,
//       indicatorSize: TabBarIndicatorSize.label,
//       indicatorColor: Colors.white,
//       indicatorWeight: 3,
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(50);
// }