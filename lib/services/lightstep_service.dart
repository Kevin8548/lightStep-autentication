import 'package:firebase_database/firebase_database.dart';

class LightstepService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref(); // Corregido aquí.

  // Obtener la configuración en tiempo real desde Realtime Database
  Stream<DatabaseEvent> getConfiguracion() {
    return _database
        .child("config")
        .onValue; // Cambiado de once() a onValue para escuchar los cambios en tiempo real.
  }

  // Actualizar la configuración en Realtime Database
  Future<void> updateConfiguracion({
    required String efecto,
    required String estado,
    required String fecha,
    required int opacidad,
    required String color,
  }) async {
    try {
      await _database.child("config").set({
        "efecto": efecto,
        "estado": estado,
        "fecha": fecha,
        "opacidad": opacidad,
        "color": color,
      });
      print("Configuración actualizada en Realtime Database");
    } catch (e) {
      print("Error al actualizar configuración: $e");
    }
  }
}
