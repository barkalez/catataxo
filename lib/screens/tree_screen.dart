import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'view_tax_screen.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _logger.i('Iniciando carga de datos en TreeScreen');
    _loadTreeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          });
          _nodeMap[id] = node;
          _logger.d('Nodo creado con datos: ${node.data}');
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
        title: const Text('Árbol taxonómico'),
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
                    style: IndentStyle.squareJoint,
                    width: 16.0,
                    color: Colors.grey,
                  ),
                  builder: (context, node) {
                    _logger.d('Renderizando nodo: ${node.data!['nombre_cientifico']}, hijos: ${node.children.length}');
                    return ListTile(
                      leading: _getIcon(node),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              node.data!['nombre_cientifico'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              size: 20,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              _logger.i('Nodo seleccionado: ${node.data!['nombre_cientifico']}');
                              final taxonData = node.data ?? {};
                              _logger.d('Datos del taxón seleccionado antes de navegar: $taxonData');
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
                              size: 28, // Flecha más grande
                              color: Colors.teal, // Color teal para consistencia
                            )
                          : null, // Sin flecha si no tiene hijos
                    );
                  },
                ),
    );
  }

  Widget _getIcon(TreeNode<Map<String, dynamic>> node) {
    final tipoNodo = node.data!['tipo_nodo'] as String;
    if (tipoNodo == 'taxon') {
      return const Icon(Icons.folder, color: Colors.teal);
    } else if (tipoNodo == 'species') {
      return const Icon(Icons.local_florist, color: Colors.teal);
    }
    return const Icon(Icons.help_outline, color: Colors.grey);
  }

  TreeNode<Map<String, dynamic>> _findRootNode() {
    try {
      _logger.d('Buscando nodo raíz en _nodeMap con ${_nodeMap.length} nodos');
      final root = _nodeMap.values.firstWhere(
        (node) => node.data!['padre_id'] == null,
        orElse: () {
          _logger.w('No se encontró un nodo raíz explícito, usando el primero disponible');
          return _nodeMap.values.first;
        },
      );
      _logger.d('Nodo raíz encontrado: ${root.data!['nombre_cientifico']}, datos: ${root.data}');
      return root;
    } catch (e) {
      _logger.e('Error al encontrar nodo raíz: $e');
      return _nodeMap.values.first;
    }
  }
}