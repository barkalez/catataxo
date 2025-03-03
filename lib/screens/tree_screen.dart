import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart'; // Aseguramos el import
import 'package:logger/logger.dart';
import '../utils/logger.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/tree_view_content.dart';
import '../services/firestore_service.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  TreeScreenState createState() => TreeScreenState();
}

class TreeScreenState extends State<TreeScreen> {
  final Map<String, TreeNode<Map<String, dynamic>>> _nodeMap = {};
  final Logger _logger = AppLogger.instance;
  final FirestoreService _firestoreService = FirestoreService();
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
      _nodeMap.clear();
      await _firestoreService.loadTaxonTree(_nodeMap);
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
      appBar: const CustomAppBar(title: 'Árbol taxonómico'),
      body: TreeViewContent(
        isLoading: _isLoading,
        nodeMap: _nodeMap,
        scrollController: _scrollController,
      ),
    );
  }
}