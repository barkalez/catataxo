import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/loged_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/new_tax_screen.dart';
import 'screens/tree_screen.dart';
import 'constants/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase en Flutter',
      theme: getAppTheme(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/loged': (context) => const LogedScreen(),
        '/new-tax': (context) => const TaxonForm(),
        '/tree': (context) => const TreeScreen(),
        // ViewTaxScreen requiere taxonData, así que no se añade como ruta estática
      },
    );
  }
}