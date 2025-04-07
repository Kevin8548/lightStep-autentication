import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:light_step_app/widgets/appbar.dart';
import 'package:light_step_app/widgets/scaffold_con_degradado.dart';

class Personalizacion extends StatefulWidget {
  const Personalizacion({super.key});

  @override
  State<Personalizacion> createState() => _PersonalizacionState();
}

class _PersonalizacionState extends State<Personalizacion> {
  Color selectedColor = Colors.red;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  double opacity = 1.0;
  int selectedEffect = 0;

  String colorToHex(Color color) {
    return "#${color.red.toRadixString(16).padLeft(2, '0')}"
            "${color.green.toRadixString(16).padLeft(2, '0')}"
            "${color.blue.toRadixString(16).padLeft(2, '0')}"
        .toUpperCase();
  }

  void guardarConfiguracion() {
    Map<String, dynamic> data = {
      'color': colorToHex(selectedColor),
      'efecto': selectedEffect,
      'efecto_nombre': _getEffectName(selectedEffect),
      'estado': 'activo',
      'fecha': DateTime.now().toIso8601String(),
      'opacidad': (opacity * 100).toInt(),
    };

    print("Enviando a Firebase: $data");

    dbRef.update(data).then((_) {
      print('✅ Configuración guardada en Firebase');
    }).catchError((error) {
      print('❌ Error al guardar en Firebase: $error');
    });
  }

  String _getEffectName(int effect) {
    switch (effect) {
      case 1:
        return "Ciclo";
      case 2:
        return "Arcoiris";
      default:
        return "Estático";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: ScaffoldConDegradado(
        appBar: AppbarStyle(title: 'Personalización'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSectionTitle('Selecciona un color'),
              const SizedBox(height: 20),

              // Contenedor para Color
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Haz clic para cambiar el color de la luz',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Selecciona un color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: selectedColor,
                                  onColorChanged: (color) {
                                    setState(() => selectedColor = color);
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    guardarConfiguracion();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Guardar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: selectedColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: selectedColor, width: 5),
                        ),
                        child: Center(
                          child: Text(
                            'HEX\n${colorToHex(selectedColor)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selectedColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _buildSectionTitle('Opacidad'),
              const SizedBox(height: 20),

              // Contenedor para Opacidad
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajusta el brillo a tu preferencia',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: opacity,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      label: '${(opacity * 100).toInt()}%',
                      onChanged: (val) => setState(() => opacity = val),
                      onChangeEnd: (val) => guardarConfiguracion(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _buildSectionTitle('Efectos'),
              const SizedBox(height: 20),

              // Contenedor para Efectos
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecciona un efecto para las luces',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _efectoBoton(0, 'Estático', Colors.purple, Colors.pink),
                        _efectoBoton(1, 'Ciclo', Colors.purple, Colors.blue),
                        _efectoBoton(
                          2,
                          'Arcoíris',
                          Colors.purple,
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Material(
          color: Colors.purple,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Inicio"),
              Tab(icon: Icon(Icons.settings), text: "Personalización"),
              Tab(icon: Icon(Icons.battery_charging_full), text: "Consumo"),
              Tab(icon: Icon(Icons.person), text: "Perfil"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _efectoBoton(
    int index,
    String label,
    Color startColor,
    Color endColor,
  ) {
    bool isSelected = selectedEffect == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEffect = index;
        });
        guardarConfiguracion();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [startColor, endColor])
              : null,
          color: isSelected ? null : Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.pinkAccent, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 8, 88),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
