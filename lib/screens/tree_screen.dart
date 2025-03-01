import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  TreeScreenState createState() => TreeScreenState();
}

class TreeScreenState extends State<TreeScreen> {
  final Map<String, TreeNode<Map<String, dynamic>>> _nodeMap = {};
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logger.i('Iniciando carga de datos en TreeScreen');
    _loadTreeData();
  }

  Future<void> _loadTreeData() async {
    try {
      _logger.i('Consultando la colección "taxones" en Firestore');
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('taxones').get();

      _logger.i('Número de documentos obtenidos: ${snapshot.docs.length}');
      if (snapshot.docs.isEmpty) {
        _logger.w('No se encontraron documentos en la colección "taxones"');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id;
        _logger.d('Procesando documento con ID: $id, datos: $data');
        if (data.isNotEmpty && data.containsKey('nombre_cientifico')) {
          final tipo = data['tipo'] ?? 'folder'; // Simula tipo si no existe, o usa 'nivel_taxonomico'
          final node = TreeNode<Map<String, dynamic>>(data: {
            'id': id,
            'nombre_cientifico': data['nombre_cientifico'] ?? 'Sin nombre',
            'nivel_taxonomico': data['nivel_taxonomico'] ?? 'folder',
            'padre_id': data['padre_id'],
            'tipo': tipo, // 'folder' o 'file'
            'createdAt': data['createdAt'] != null
                ? (data['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
          });
          _nodeMap[id] = node;
        } else {
          _logger.w('Documento con ID $id está vacío o no tiene nombre_cientifico, omitido');
        }
      }

      _logger.i('Anidando nodos...');
      _nodeMap.forEach((id, node) {
        final parentId = node.data!['padre_id'] as String?;
        if (parentId != null && _nodeMap.containsKey(parentId)) {
          _nodeMap[parentId]!.add(node);
          _logger.d('Anidando ${node.data!['nombre_cientifico']} bajo $parentId');
        } else if (parentId != null) {
          _logger.w('Padre con ID $parentId no encontrado para ${node.data!['nombre_cientifico']}');
        }
      });

      _logger.i('Árbol cargado con ${_nodeMap.length} nodos válidos');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _logger.e('Error al cargar datos de Firestore: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Construyendo UI, nodos en _nodeMap: ${_nodeMap.length}, isLoading: $_isLoading');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorador de Archivos'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _nodeMap.isEmpty
              ? const Center(
                  child: Text(
                    'No hay elementos disponibles',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : TreeView.simple(
                  tree: _findRootNode(),
                  padding: const EdgeInsets.all(16.0),
                  expansionBehavior: ExpansionBehavior.snapToTop,
                  indentation: const Indentation(
                    style: IndentStyle.squareJoint, // Líneas cuadradas
                    width: 20.0, // Ancho de indentación
                    color: Colors.grey, // Color de las líneas
                  ),
                  builder: (context, node) => ListTile(
                    leading: _getIcon(node),
                    title: Text(
                      node.data!['nombre_cientifico'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Nivel: ${node.data!['nivel_taxonomico']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      _logger.i('Nodo seleccionado: ${node.data!['nombre_cientifico']}');
                    },
                  ),
                ),
    );
  }

  Widget _getIcon(TreeNode<Map<String, dynamic>> node) {
    final tipo = node.data!['tipo'] as String;
    if (tipo == 'folder') {
      return const Icon(Icons.folder, color: Colors.blueGrey);
    } else if (tipo == 'file' && (node.data!['nombre_cientifico'] as String).endsWith('.mp4')) {
      return const Icon(Icons.videocam, color: Colors.blueGrey);
    }
    return const Icon(Icons.insert_drive_file, color: Colors.blueGrey);
  }

  TreeNode<Map<String, dynamic>> _findRootNode() {
    try {
      return _nodeMap.values.firstWhere(
        (node) => node.data!['padre_id'] == null,
        orElse: () {
          _logger.w('No se encontró un nodo raíz explícito, usando el primero disponible');
          return _nodeMap.values.first;
        },
      );
    } catch (e) {
      _logger.e('Error al encontrar nodo raíz: $e');
      return _nodeMap.values.first;
    }
  }
}