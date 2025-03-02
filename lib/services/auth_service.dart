import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'alias': user.displayName ?? user.email!.split('@')[0],
            'createdAt': FieldValue.serverTimestamp(),
          });
          _logger.i('Usuario registrado con Google: ${user.email}');
        } else {
          _logger.i('Usuario existente inició sesión: ${user.email}');
        }
      }

      return user;
    } catch (e) {
      _logger.e('Error detallado al iniciar sesión con Google: $e');
      rethrow; // Relanza la excepción para manejarla en la UI
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _logger.i('Sesión cerrada');
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}