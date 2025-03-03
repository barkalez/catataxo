import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_elevated_button.dart';
import 'custom_text_field.dart';

class TaxonFormContent extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final FirebaseFirestore firestore;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const TaxonFormContent({
    super.key,
    required this.formKey,
    required this.firestore,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: formKey,
        child: ListView(
          children: [
            CustomTextField(
              name: 'nombre_cientifico',
              label: 'Nombre Científico',
              icon: Icons.science,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              name: 'descrito_por',
              label: 'Descrito por',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              name: 'descripcion',
              label: 'Descripción',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CustomTextField(
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
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              initialValue: 'taxon',
              items: const [
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
                  borderSide: const BorderSide(color: Colors.teal),
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
                final snapshot = await firestore
                    .collection('taxones')
                    .where('nombre_cientifico', isGreaterThanOrEqualTo: query)
                    .where('nombre_cientifico', isLessThanOrEqualTo: '$query\uf8ff')
                    .get();
                return snapshot.docs
                    .map((doc) => '${doc['nombre_cientifico']} (${doc['nivel_taxonomico']}) - ${doc.id}')
                    .toList();
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
                formKey.currentState!.fields['parentId']!.didChange(id);
              },
              selectionToTextTransformer: (suggestion) => suggestion.split(' - ')[0],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              name: 'localizacion_gps',
              label: 'Localización GPS',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              text: 'Registrar Taxón',
              onPressed: () {
                if (formKey.currentState!.saveAndValidate()) {
                  final formData = formKey.currentState!.value;
                  onSave(formData);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}