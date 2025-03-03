import 'package:flutter/material.dart';
import 'taxon_field.dart';

class TaxonViewContent extends StatelessWidget {
  final Map<String, dynamic> taxonData;

  const TaxonViewContent({super.key, required this.taxonData});

  String _formatCreatedAt() {
    if (taxonData['createdAt'] != null && taxonData['createdAt'] is DateTime) {
      return taxonData['createdAt'].toString();
    }
    return 'No disponible';
  }

  String _translateTipoNodo() {
    if (taxonData['tipo_nodo'] != null) {
      return taxonData['tipo_nodo'] == 'taxon' ? 'Taxón' : 'Especie';
    }
    return 'No disponible';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (taxonData['nombre_cientifico'] != null)
              TaxonField(label: 'Nombre Científico', value: taxonData['nombre_cientifico'].toString()),
            TaxonField(label: 'Nivel Taxonómico', value: taxonData['nivel_taxonomico']),
            TaxonField(label: 'Tipo nodo', value: _translateTipoNodo()),
            TaxonField(label: 'ID Padre', value: taxonData['padre_id']),
            TaxonField(label: 'Fecha de Creación', value: _formatCreatedAt()),
            if (taxonData['descripcion'] != null)
              TaxonField(label: 'Descripción', value: taxonData['descripcion'].toString()),
            if (taxonData['localizacion_gps'] != null)
              TaxonField(label: 'Ubicación GPS', value: taxonData['localizacion_gps'].toString()),
            if (taxonData['descrito_por'] != null)
              TaxonField(label: 'Descrito Por', value: taxonData['descrito_por']),
            if (taxonData['creado_por'] != null)
              TaxonField(label: 'Creado Por', value: taxonData['creado_por']),
          ],
        ),
      ),
    );
  }
}