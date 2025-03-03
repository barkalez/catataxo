import 'package:flutter/material.dart';

class TaxonIcon extends StatelessWidget {
  final String tipoNodo;

  const TaxonIcon({super.key, required this.tipoNodo});

  @override
  Widget build(BuildContext context) {
    if (tipoNodo == 'taxon') {
      return const Icon(Icons.folder, color: Colors.teal);
    } else if (tipoNodo == 'species') {
      return const Icon(Icons.local_florist, color: Colors.teal);
    }
    return const Icon(Icons.help_outline, color: Colors.grey);
  }
}