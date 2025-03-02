import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/loged_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _authService.signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogedScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to sign in with Google';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar sesión',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal, // Color teal como en TaxonForm
        elevation: 4, // Sombra como en TaxonForm
        centerTitle: true, // Centrado como en tu versión anterior
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white], // Gradiente igual a TaxonForm
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding igual a TaxonForm
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal, // Color teal para coherencia
                  ),
                ),
                const SizedBox(height: 40), // Espacio similar a TaxonForm
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal), // Color teal
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Image.asset(
                      'assets/google_logo.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      'Acceder con Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Texto blanco como en TaxonForm
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Fondo teal como en TaxonForm
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ), // Padding similar
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bordes redondeados como en TaxonForm
                      ),
                      elevation: 5, // Elevación igual a TaxonForm
                      shadowColor: Colors.teal.withAlpha(128), // Sombra teal como en TaxonForm
                    ),
                  ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}