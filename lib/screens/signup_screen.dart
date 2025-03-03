import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/signup_content.dart';
import '../constants/app_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();

  Future<void> _handleGoogleSignIn() async {
    final user = await _authService.signInWithGoogle();

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Registro'),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.bodyGradient),
        child: SignUpContent(
          onGoogleSignIn: _handleGoogleSignIn,
        ),
      ),
    );
  }
}