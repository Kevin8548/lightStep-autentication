import 'package:flutter/material.dart';
import 'package:light_step_app/widgets/appbar.dart';
import 'package:light_step_app/widgets/scaffold_con_degradado.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/inicio');
        break;
      case 1:
        Navigator.pushNamed(context, '/personalizacion');
        break;
      case 2:
        Navigator.pushNamed(context, '/consumo');
        break;
      case 3:
        Navigator.pushNamed(context, '/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldConDegradado(
      appBar: AppbarStyle(title: 'Inicio'),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Empieza a interactuar!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Con LightStep puedes:',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Image.asset(
                  'assets/img/desc.gif',
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(height: 50),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildCard(
                      'Ahorrar',
                      'Reducir el consumo de energía',
                      [
                        Colors.red,
                        Colors.orange,
                      ],
                      Icons.bolt),
                  _buildCard(
                      'Personalizar',
                      'Elegir el color que quieras',
                      [
                        Colors.green,
                        Colors.teal,
                      ],
                      Icons.color_lens),
                  _buildCard(
                    'Elegir efectos',
                    'Cambiar efecto ciclo arcoíris o estático.',
                    [Colors.blue, Colors.purple],
                    Icons.auto_awesome,
                  ),
                  _buildCard(
                    'Reducir riesgos',
                    'Evitar accidentes en escaleras y pasillos.',
                    [Colors.yellow, Colors.deepOrange],
                    Icons.warning,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.black,
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
              icon: Icon(Icons.palette),
              label: 'Personalización',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Consumo',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    String subtitle,
    List<Color> colors,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(2, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
