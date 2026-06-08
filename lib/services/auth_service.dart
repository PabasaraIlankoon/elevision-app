import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  bool get isLoggedIn => _user != null;
  User? get user => _user;

  AuthService() {
    // Listen to authentication changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Login with email and password
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null; // Success - no error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Email not found. Please check and try again.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password. Please try again.';
      } else {
        return 'Login failed: ${e.message}';
      }
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
