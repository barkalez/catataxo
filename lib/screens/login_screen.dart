import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/login_content.dart';
import '../constants/app_styles.dart';

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
        Navigator.pushReplacementNamed(context, '/loged');
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
      appBar: const CustomAppBar(title: 'Iniciar sesión'),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.bodyGradient),
        child: LoginContent(
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          onSignInWithGoogle: _signInWithGoogle,
        ),
      ),
    );
  }
}