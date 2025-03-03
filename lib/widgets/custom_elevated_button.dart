import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon; // Nuevo parámetro opcional para icono

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        text,
        style: AppStyles.buttonTextStyle,
      ),
      style: AppStyles.elevatedButtonStyle,
    );
  }
}