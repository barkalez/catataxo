import 'package:flutter/material.dart';
import 'home_screen.dart'; // Importa el archivo que contiene HomeScreen
import 'view_tax_screen.dart'; // Importa el archivo que contiene ViewTaxScreen
import 'new_tax_screen.dart'; // Importa el archivo que contiene NewTaxScreen
import 'tree_screen.dart'; // Importa el archivo que contiene TreeScreen

class LogedScreen extends StatelessWidget {
  const LogedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loged Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaxonForm()),
                );
              },
              child: Text('Crear taxon'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para editar taxon
              },
              child: Text('Editar taxon'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewTaxScreen()),
                );
              },
              child: Text('Ver taxones'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para borrar taxon
              },
              child: Text('Borrar taxon'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreeScreen()),
                );
              },
              child: Text('Árbol taxonómico'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}