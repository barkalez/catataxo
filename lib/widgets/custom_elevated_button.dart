import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppStyles.elevatedButtonStyle,
      child: Text(
        text,
        style: AppStyles.buttonTextStyle,
      ),
    );
  }
}