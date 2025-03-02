import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loged_screen.dart';
import '../services/auth_service.dart';

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
  String? _userAlias; // Para almacenar el alias del usuario
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
      Navigator.pop(context); // Redirige fuera de TaxonForm
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
      appBar: AppBar(
        title: const Text(
          'Crear Nuevo Taxón',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  name: 'nombre_cientifico',
                  label: 'Nombre Científico',
                  icon: Icons.science,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  name: 'descrito_por',
                  label: 'Descrito por',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  name: 'descripcion',
                  label: 'Descripción',
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  name: 'nivel_taxonomico',
                  label: 'Nivel Taxonómico',
                  icon: Icons.category,
                ),
                const SizedBox(height: 16),
                FormBuilderDropdown<String>(
                  name: 'tipo',
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    prefixIcon: const Icon(Icons.type_specimen, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  initialValue: 'taxon',
                  items: [
                    DropdownMenuItem(value: 'taxon', child: Text('Taxón')),
                    DropdownMenuItem(value: 'especie', child: Text('Especie')),
                  ],
                ),
                const SizedBox(height: 16),
                FormBuilderTypeAhead<String>(
                  name: 'parentId',
                  decoration: InputDecoration(
                    labelText: 'Taxón Padre (opcional)',
                    prefixIcon: const Icon(Icons.account_tree, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  suggestionsCallback: (query) async {
                    if (query.isEmpty) {
                      return [];
                    }
                    final snapshot = await _firestore
                        .collection('taxones')
                        .where('nombre_cientifico', isGreaterThanOrEqualTo: query)
                        .where('nombre_cientifico', isLessThanOrEqualTo: '$query\uf8ff')
                        .get();
                    return snapshot.docs.map((doc) => '${doc['nombre_cientifico']} (${doc['nivel_taxonomico']}) - ${doc.id}').toList();
                  },
                  itemBuilder: (context, suggestion) {
                    final parts = suggestion.split(' - ');
                    return ListTile(
                      title: Text(parts[0], style: const TextStyle(color: Colors.teal)),
                      subtitle: Text('ID: ${parts[1]}', style: const TextStyle(color: Colors.grey)),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    );
                  },
                  onSelected: (suggestion) {
                    final id = suggestion.split(' - ')[1];
                    _formKey.currentState!.fields['parentId']!.didChange(id);
                  },
                  selectionToTextTransformer: (suggestion) => suggestion.split(' - ')[0],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  name: 'localizacion_gps',
                  label: 'Localización GPS',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      _saveTaxon(formData);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    shadowColor: Colors.teal.withAlpha(128),
                  ),
                  child: const Text(
                    'Registrar Taxón',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String name,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FormBuilderTextField(
        name: name,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.teal),
          prefixIcon: Icon(icon, color: Colors.teal),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }

  void _saveTaxon(Map<String, dynamic> formData) async {
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
        'creado_por': _userAlias ?? 'Desconocido', // Guardar el alias del creador
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogedScreen()),
        );
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
}