import 'package:flutter/material.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_app_bar.dart';
import '../constants/app_styles.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Catataxo'),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.bodyGradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  text: 'Registrarse',
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
                const SizedBox(height: 50),
                CustomElevatedButton(
                  text: 'Iniciar sesión',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}