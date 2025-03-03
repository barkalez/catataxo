import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/taxon_form_content.dart';
import '../constants/app_styles.dart';

class TaxonForm extends StatefulWidget {
  const TaxonForm({super.key});

  @override
  TaxonFormState createState() => TaxonFormState();
}

class TaxonFormState extends State<TaxonForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  String? _userRole;
  String? _userAlias;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final role = await _authService.getUserRole();
    final user = _authService.getCurrentUser();
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _userRole = role;
        _userAlias = userDoc.data()?['alias'] as String?;
        _isLoading = false;
      });
    }
    if (role != 'admin' && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo los administradores pueden crear taxones'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _saveTaxon(Map<String, dynamic> formData) async {
    try {
      await _firestore.collection('taxones').add({
        'descrito_por': formData['descrito_por'],
        'descripcion': formData['descripcion'],
        'localizacion_gps': GeoPoint(0, 0),
        'nivel_taxonomico': formData['nivel_taxonomico'],
        'nombre_cientifico': formData['nombre_cientifico'],
        'padre_id': formData['parentId'],
        'tipo': formData['tipo'],
        'createdAt': FieldValue.serverTimestamp(),
        'creado_por': _userAlias ?? 'Desconocido',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Taxón guardado exitosamente'),
            backgroundColor: Colors.teal,
          ),
        );
        _formKey.currentState!.fields.forEach((key, field) {
          field.didChange('');
        });
        debugPrint('Intentando navegar a LogedScreen');
        Navigator.pushReplacementNamed(context, '/loged');
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Error al guardar: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userRole != 'admin') {
      return const Scaffold(
        body: Center(
          child: Text(
            'Acceso denegado: Solo administradores pueden crear taxones',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Crear Nuevo Taxón'),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.bodyGradient),
        child: TaxonFormContent(
          formKey: _formKey,
          firestore: _firestore,
          onSave: _saveTaxon,
        ),
      ),
    );
  }
}