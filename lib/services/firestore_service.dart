import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:logger/logger.dart';
import '../utils/logger.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = AppLogger.instance;

  Future<void> loadTaxonTree(Map<String, TreeNode<Map<String, dynamic>>> nodeMap) async {
    _logger.i('Consultando la colección "taxones" en Firestore');
    QuerySnapshot snapshot = await _firestore.collection('taxones').get();

    _logger.i('Número de documentos obtenidos: ${snapshot.docs.length}');
    if (snapshot.docs.isEmpty) {
      _logger.w('No se encontraron documentos en la colección "taxones"');
      return;
    }

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      _logger.d('Procesando documento con ID: $id, datos: $data, descripción: ${data['descripcion']}');
      if (data.isNotEmpty && data.containsKey('nombre_cientifico')) {
        final tipoNodo = data['tipo_nodo'] ?? 'taxon';
        final node = TreeNode<Map<String, dynamic>>(data: {
          'id': id,
          'nombre_cientifico': data['nombre_cientifico'] ?? 'Sin nombre',
          'nivel_taxonomico': data['nivel_taxonomico'] ?? 'Sin nivel',
          'padre_id': data['padre_id'],
          'tipo_nodo': tipoNodo,
          'createdAt': data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
          'descripcion': data['descripcion'] ?? 'No disponible',
          'creado_por': data['creado_por'],
        });
        nodeMap[id] = node;
        _logger.d('Nodo creado con datos: ${node.data}');
      } else {
        _logger.w('Documento con ID $id está vacío o no tiene nombre_cientifico, omitido');
      }
    }

    _logger.i('Anidando nodos...');
    nodeMap.forEach((id, node) {
      final parentId = node.data!['padre_id'] as String?;
      if (parentId != null && nodeMap.containsKey(parentId)) {
        nodeMap[parentId]!.add(node);
        _logger.d('Anidando ${node.data!['nombre_cientifico']} bajo $parentId');
      } else if (parentId != null) {
        _logger.w('Padre con ID $parentId no encontrado para ${node.data!['nombre_cientifico']}');
      }
    });

    _logger.i('Árbol cargado con ${nodeMap.length} nodos válidos');
  }
}