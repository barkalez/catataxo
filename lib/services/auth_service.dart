import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Registrar/Iniciar sesión con Google
  Future<User?> signInWithGoogle() async {
    try {
      _logger.i('Iniciando flujo de Google Sign-In');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.w('Inicio de sesión con Google cancelado por el usuario');
        return null;
      }

      _logger.i('Obteniendo credenciales de Google: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _logger.i('Iniciando sesión en Firebase con credenciales de Google');
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // Crear documento en 'users' con el uid como ID si no existe
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'alias': user.displayName ?? user.email!.split('@')[0], // Usa displayName o deriva del email
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'reader', // Por defecto reader, cambia manualmente a admin en Firestore
          });
          _logger.i('Usuario registrado con Google: ${user.email}, alias: ${user.displayName ?? user.email!.split('@')[0]}');
        } else {
          _logger.i('Usuario existente inició sesión con Google: ${user.email}');
        }
      }

      return user;
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _logger.i('Sesión cerrada');
  }

  // Obtener usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Obtener el rol del usuario actual
  Future<String?> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) {
      _logger.w('No hay usuario autenticado');
      return null;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final role = userDoc.data()?['role'] as String?;
        _logger.i('Rol del usuario ${user.email}: $role');
        return role;
      } else {
        _logger.w('No se encontró documento de usuario para ${user.uid}');
        return null;
      }
    } catch (e) {
      _logger.e('Error al obtener el rol del usuario: $e');
      return null;
    }
  }
}