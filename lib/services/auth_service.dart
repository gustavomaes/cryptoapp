import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() async {
    _auth.authStateChanges().listen((User? u) {
      user = (u == null) ? null : u;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      throw AuthException('Error on signup!');
      
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      throw AuthException('Error on login!');
      
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}