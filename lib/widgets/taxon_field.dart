import 'package:flutter/material.dart';

class TaxonField extends StatelessWidget {
  final String label;
  final dynamic value;

  const TaxonField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value?.toString() ?? 'No disponible',
            ),
          ],
        ),
      ),
    );
  }
}