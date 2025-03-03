import 'package:flutter/material.dart';
import 'custom_elevated_button.dart';

class SignUpContent extends StatelessWidget {
  final VoidCallback onGoogleSignIn;

  const SignUpContent({super.key, required this.onGoogleSignIn});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
              text: 'Registrar con Google',
              onPressed: onGoogleSignIn,
              icon: Image.asset(
                'assets/google_logo.png',
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}