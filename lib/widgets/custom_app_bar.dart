import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading; // Hacer leading opcional

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppStyles.appBarGradient),
      ),
      elevation: 4,
      leading: leading, // Usar el leading si se proporciona
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}