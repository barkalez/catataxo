import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'firebase_config.dart';
import '../utils/logger.dart';
import '../constants/firestore_constants.dart';

class AuthService {
  final Logger _logger = AppLogger.instance;

  Future<User?> signInWithGoogle() async {
    try {
      _logger.i('Iniciando flujo de Google Sign-In');
      final GoogleSignInAccount? googleUser = await FirebaseConfig.googleSignIn.signIn();
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
      UserCredential userCredential = await FirebaseConfig.auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseConfig.firestore.collection(FirestoreConstants.usersCollection).doc(user.uid).get();
        if (!userDoc.exists) {
          await FirebaseConfig.firestore.collection(FirestoreConstants.usersCollection).doc(user.uid).set({
            FirestoreConstants.emailField: user.email,
            FirestoreConstants.aliasField: user.displayName ?? user.email!.split('@')[0],
            FirestoreConstants.createdAtField: FieldValue.serverTimestamp(),
            FirestoreConstants.roleField: FirestoreConstants.defaultRole,
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

  Future<void> signOut() async {
    await FirebaseConfig.googleSignIn.signOut();
    await FirebaseConfig.auth.signOut();
    _logger.i('Sesión cerrada');
  }

  User? getCurrentUser() {
    return FirebaseConfig.auth.currentUser;
  }

  Future<String?> getUserRole() async {
    final user = FirebaseConfig.auth.currentUser;
    if (user == null) {
      _logger.w('No hay usuario autenticado');
      return null;
    }

    try {
      final userDoc = await FirebaseConfig.firestore.collection(FirestoreConstants.usersCollection).doc(user.uid).get();
      if (userDoc.exists) {
        final role = userDoc.data()?[FirestoreConstants.roleField] as String?;
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