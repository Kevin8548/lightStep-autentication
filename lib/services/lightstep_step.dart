import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:light_step_app/services/lightstep_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:light_step_app/widgets/scaffold_con_degradado.dart';
import 'package:light_step_app/widgets/tabbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para iniciar sesión con Google
  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error al iniciar sesión con Google: $e");
      return null;
    }
  }

  // Método para la validación tradicional del login
  void _validarYContinuar() {
    String usuario = _usuarioController.text.trim();
    String password = _passwordController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      _mostrarMensaje("Por favor, ingresa usuario y contraseña.");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabBarScreen()),
      );
    }
  }

  // Función para mostrar un mensaje
  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldConDegradado(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Aquí van tus widgets anteriores (Avatar, AnimatedTitle, etc.)
              _animatedTitle(),
              const SizedBox(height: 40),
              _buildTextField(
                  Icons.person, "Usuario", false, _usuarioController),
              const SizedBox(height: 20),
              _buildTextField(
                  Icons.lock, "Contraseña", true, _passwordController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFFF0080), Color(0xFF8000FF)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _validarYContinuar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Iniciar Sesión",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              // Botón de Google Sign-In
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFFF0080), Color(0xFF8000FF)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      User? user = await _signInWithGoogle();
                      if (user != null) {
                        print('Usuario logueado: ${user.displayName}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TabBarScreen()),
                        );
                      } else {
                        _mostrarMensaje("Error al iniciar sesión con Google.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Iniciar sesión con Google",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.purple,
        child: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Inicio"),
            Tab(icon: Icon(Icons.settings), text: "Personalización"),
            Tab(icon: Icon(Icons.battery_charging_full), text: "Consumo"),
            Tab(icon: Icon(Icons.person), text: "Perfil"),
          ],
        ),
      ),
    );
  }

  // Método para la animación del título
  Widget _animatedTitle() {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            "Iniciar Sesión",
            speed: const Duration(milliseconds: 100),
          ),
        ],
        isRepeatingAnimation: true,
        repeatForever: true,
        pause: const Duration(seconds: 1),
      ),
    );
  }

  // Método para los campos de texto
  Widget _buildTextField(IconData icon, String hintText, bool obscureText,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFF0080), Color(0xFF8000FF)],
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.purple.shade900,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.purple.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}
