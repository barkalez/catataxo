import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewTaxScreen extends StatelessWidget {
  const ViewTaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Taxones'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('taxones').get(), // Consulta a la colección 'taxones'
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Muestra un cargando mientras se obtienen los datos
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay taxones disponibles')); // Mensaje si no hay datos
          }

          // Si hay datos, mostramos una lista de taxones
          final taxones = snapshot.data!.docs;
          return ListView.builder(
            itemCount: taxones.length,
            itemBuilder: (context, index) {
              var taxon = taxones[index];
              return ListTile(
                title: Text(taxon['nombre_cientifico'] ?? 'Sin nombre científico'), // Muestra el nombre científico del taxon
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(taxon['descripcion'] ?? 'Sin descripción'), // Muestra la descripción (si existe)
                    Text(taxon['nivel_taxonomico'] ?? 'Sin nivel taxonómico'), // Muestra el nivel taxonómico (si existe)
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
