import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ViewTaxScreen extends StatefulWidget {
  final Map<String, dynamic> taxonData;

  const ViewTaxScreen({super.key, required this.taxonData});

  @override
  State<ViewTaxScreen> createState() => _ViewTaxScreenState();
}

class _ViewTaxScreenState extends State<ViewTaxScreen> {
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

  @override
  void initState() {
    super.initState();
    _logger.d('Datos del taxón en ViewTaxScreen: ${widget.taxonData}');
    // Log adicional para verificar específicamente el campo 'creado_por'
    _logger.i('Valor de creado_por: ${widget.taxonData['creado_por']}');
  }

  @override
  Widget build(BuildContext context) {
    // Formatear createdAt si existe y es un DateTime
    String formattedCreatedAt = 'No disponible';
    if (widget.taxonData['createdAt'] != null && widget.taxonData['createdAt'] is DateTime) {
      formattedCreatedAt = widget.taxonData['createdAt'].toString();
    }

    // Traducir 'tipo_nodo' a español
    String tipoNodoDisplay = 'No disponible';
    if (widget.taxonData['tipo_nodo'] != null) {
      tipoNodoDisplay = widget.taxonData['tipo_nodo'] == 'taxon' ? 'Taxón' : 'Especie';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taxonData['nombre_cientifico'] ?? 'Taxón'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.taxonData['nombre_cientifico'] != null)
                _buildField('Nombre Científico', widget.taxonData['nombre_cientifico'].toString()),
              _buildField('Nivel Taxonómico', widget.taxonData['nivel_taxonomico']),
              _buildField('Tipo nodo', tipoNodoDisplay),
              _buildField('ID Padre', widget.taxonData['padre_id']),
              _buildField('Fecha de Creación', formattedCreatedAt),
              if (widget.taxonData['descripcion'] != null)
                _buildField('Descripción', widget.taxonData['descripcion'].toString()),
              if (widget.taxonData['localizacion_gps'] != null)
                _buildField('Ubicación GPS', widget.taxonData['localizacion_gps'].toString()),
              if (widget.taxonData['descrito_por'] != null)
                _buildField('Descrito Por', widget.taxonData['descrito_por']),
              if (widget.taxonData['creado_por'] != null)
                _buildField('Creado Por', widget.taxonData['creado_por']), // Mostrar el alias del creador
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value?.toString() ?? 'No disponible',
            ),
          ],
        ),
      ),
    );
  }
}