import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'new_tax_screen.dart'; // Asegúrate de que este sea el archivo correcto para TaxonForm
import 'tree_screen.dart';
import '../services/auth_service.dart';

class LogedScreen extends StatelessWidget {
  const LogedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService(); // Instancia para manejar el logout

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catataxo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal, // Fondo teal como en TaxonForm
        elevation: 4, // Sombra como en TaxonForm
        centerTitle: true, // Centrado para consistencia
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white], // Gradiente igual a TaxonForm
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding igual a TaxonForm
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TaxonForm()), // Asegúrate de que TaxonForm esté importado como new_tax_screen.dart
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Fondo teal como en TaxonForm
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ), // Padding consistente
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    ),
                    elevation: 5, // Elevación como en TaxonForm
                    shadowColor: Colors.teal.withAlpha(128), // Sombra teal
                  ),
                  child: const Text(
                    'Crear taxón',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco como en TaxonForm
                    ),
                  ),
                ),
                const SizedBox(height: 24), // Espaciado similar a TaxonForm
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TreeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.teal.withAlpha(128),
                  ),
                  child: const Text(
                    'Árbol taxonómico',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await authService.signOut(); // Llama al método signOut
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.teal.withAlpha(128),
                  ),
                  child: const Text(
                    'Cerrar sesión',
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
}