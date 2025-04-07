import 'package:flutter/material.dart';
import 'package:light_step_app/widgets/appbar.dart';
import 'package:light_step_app/widgets/scaffold_con_degradado.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class ConsumoScreen extends StatefulWidget {
  const ConsumoScreen({super.key});

  @override
  _ConsumoScreenState createState() => _ConsumoScreenState();
}

class _ConsumoScreenState extends State<ConsumoScreen> {
  final List<Color> colorList = const [
    Color.fromARGB(255, 244, 6, 165),
    Color.fromARGB(255, 193, 206, 8),
    Color.fromARGB(255, 90, 120, 228),
    Color.fromARGB(255, 240, 123, 80),
  ];

  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    _obtenerDatosDesdeFirebase();
  }

  void _obtenerDatosDesdeFirebase() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('/consumo');
    ref.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        Map<String, double> nuevoDataMap = {};

        data.forEach((key, value) {
          if (value is num) {
            nuevoDataMap[key] = value.toDouble();
          }
        });

        print('Datos recibidos desde Firebase: $nuevoDataMap');

        setState(() {
          dataMap = nuevoDataMap;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldConDegradado(
      appBar: AppbarStyle(title: 'Consumo por Día'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildSectionTitle("Consumo por Día"),
              const SizedBox(height: 30),
              _buildContainerWithTransparentBackground(
                child: Column(
                  children: [
                    if (dataMap.isEmpty)
                      const Center(
                        child: Text(
                          "Cargando datos...",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    else
                      PieChart(
                        dataMap: dataMap,
                        colorList: colorList,
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: false,
                          decimalPlaces: 0,
                          chartValueStyle: TextStyle(
                            color: Color.fromARGB(255, 13, 13, 13),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        legendOptions: const LegendOptions(
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32,
                        chartRadius: MediaQuery.of(context).size.width / 2,
                      ),
                    const SizedBox(height: 30),
                    _buildLegend(dataMap),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(3),
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
    );
  }

  Widget _buildContainerWithTransparentBackground({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _buildLegend(Map<String, double> dataMap) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(57, 0, 0, 0).withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dataMap.entries.map((entry) {
          final colorIndex =
              dataMap.keys.toList().indexOf(entry.key) % colorList.length;
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorList[colorIndex],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Fecha: ${entry.key}, Segundos: ${entry.value.toInt()}",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
