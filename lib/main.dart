import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'app.dart'; // Importa el nuevo archivo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con la configuración generada
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}