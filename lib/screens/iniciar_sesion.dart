import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:light_step_app/screens/encendido.dart';
import 'package:light_step_app/widgets/scaffold_con_degradado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldConDegradado(
      bottomNavigationBar: Material(
        child: Container(), // Add a placeholder or your desired widget
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFF0080), Color(0xFF8000FF)],
                  ),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              _animatedTitle(),
              const SizedBox(height: 40),
              _buildTextField(
                Icons.person,
                "Usuario",
                false,
                _usuarioController,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                Icons.lock,
                "Contraseña",
                true,
                _passwordController,
              ),
              const SizedBox(height: 20),
              _buildGradientButton("Iniciar Sesión", _validarYContinuar),
              const SizedBox(height: 20),
              _buildGoogleButton(), // <-- Botón de Google agregado aquí
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedTitle() {
    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: 'PoetsenOne',
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

  Widget _buildTextField(
    IconData icon,
    String hintText,
    bool obscureText,
    TextEditingController controller,
  ) {
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

  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return SizedBox(
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
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _iniciarSesionConGoogle,
        icon: Image.asset('assets/google_logo.png', height: 24),
        label: const Text("Iniciar sesión con Google"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _validarYContinuar() {
    String usuario = _usuarioController.text.trim();
    String password = _passwordController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      _mostrarMensaje("Por favor, ingresa usuario y contraseña.");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Encendido()),
      );
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _iniciarSesionConGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Encendido()),
      );
    } catch (e) {
      _mostrarMensaje("Error al iniciar sesión con Google: $e");
    }
  }
}
