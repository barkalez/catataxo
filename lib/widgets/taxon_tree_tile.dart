import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import '../utils/logger.dart';
import '../screens/view_tax_screen.dart';
import 'taxon_icon.dart';

class TaxonTreeTile extends StatelessWidget {
  final TreeNode<Map<String, dynamic>> node;

  const TaxonTreeTile({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger.instance;
    logger.d('Renderizando nodo: ${node.data!['nombre_cientifico']}, hijos: ${node.children.length}');
    return ListTile(
      leading: TaxonIcon(tipoNodo: node.data!['tipo_nodo'] as String),
      title: Row(
        children: [
          Text(
            node.data!['nombre_cientifico'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.visibility,
              size: 20,
              color: Colors.teal,
            ),
            onPressed: () {
              logger.i('Nodo seleccionado: ${node.data!['nombre_cientifico']}');
              final taxonData = node.data ?? {};
              logger.d('Datos del taxón seleccionado antes de navegar: $taxonData');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTaxScreen(taxonData: taxonData),
                ),
              );
            },
          ),
        ],
      ),
      subtitle: Text(
        'Nivel: ${node.data!['nivel_taxonomico']}',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: node.children.isNotEmpty
          ? const Icon(
              Icons.arrow_forward_ios,
              size: 28,
              color: Colors.teal,
            )
          : null,
    );
  }
}