import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:logger/logger.dart';
import '../utils/logger.dart';
import 'taxon_tree_tile.dart';

class TreeViewContent extends StatelessWidget {
  final bool isLoading;
  final Map<String, TreeNode<Map<String, dynamic>>> nodeMap;
  final ScrollController scrollController;

  const TreeViewContent({
    super.key,
    required this.isLoading,
    required this.nodeMap,
    required this.scrollController,
  });

  TreeNode<Map<String, dynamic>> _findRootNode(Logger logger) {
    try {
      logger.d('Buscando nodo raíz en _nodeMap con ${nodeMap.length} nodos');
      final root = nodeMap.values.firstWhere(
        (node) => node.data!['padre_id'] == null,
        orElse: () {
          logger.w('No se encontró un nodo raíz explícito, usando el primero disponible');
          return nodeMap.values.first;
        },
      );
      logger.d('Nodo raíz encontrado: ${root.data!['nombre_cientifico']}, datos: ${root.data}');
      return root;
    } catch (e) {
      logger.e('Error al encontrar nodo raíz: $e');
      return nodeMap.values.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger.instance;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (nodeMap.isEmpty) {
      return const Center(
        child: Text(
          'No hay elementos disponibles',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1.5,
        child: TreeView.simple(
          tree: _findRootNode(logger),
          padding: const EdgeInsets.all(16.0),
          expansionBehavior: ExpansionBehavior.snapToTop,
          indentation: const Indentation(
            style: IndentStyle.squareJoint,
            width: 16.0,
            color: Colors.grey,
          ),
          builder: (context, node) => TaxonTreeTile(node: node),
        ),
      ),
    );
  }
}