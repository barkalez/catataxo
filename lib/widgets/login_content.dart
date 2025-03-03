import 'package:flutter/material.dart';
import 'custom_elevated_button.dart';

class LoginContent extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;
  final VoidCallback onSignInWithGoogle;

  const LoginContent({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.onSignInWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 40),
            if (isLoading)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              )
            else
              CustomElevatedButton(
                text: 'Acceder con Google',
                onPressed: onSignInWithGoogle,
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                  width: 24,
                ),
              ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}