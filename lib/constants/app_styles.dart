import 'package:flutter/material.dart';

class AppStyles {
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Colors.teal, Colors.blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient bodyGradient = LinearGradient(
    colors: [Colors.teal.shade50, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 5,
    shadowColor: Colors.teal.withAlpha(128),
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}