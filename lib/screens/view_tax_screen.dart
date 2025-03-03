import 'package:flutter/material.dart';
import '../utils/logger.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/taxon_view_content.dart';
import '../constants/app_styles.dart';

class ViewTaxScreen extends StatelessWidget {
  final Map<String, dynamic> taxonData;

  const ViewTaxScreen({super.key, required this.taxonData});

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger.instance;
    logger.d('Datos del taxón en ViewTaxScreen: $taxonData');
    logger.i('Valor de creado_por: ${taxonData['creado_por']}');

    return Scaffold(
      appBar: CustomAppBar(
        title: taxonData['nombre_cientifico'] ?? 'Taxón',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.bodyGradient),
        child: TaxonViewContent(taxonData: taxonData),
      ),
    );
  }
}