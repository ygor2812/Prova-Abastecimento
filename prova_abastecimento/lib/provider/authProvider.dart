import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;
  String? error;
  Future<bool> login(String email, String senha) async {
    if (!_validarEmail(email)) {
      error = "E-mail inválido";
      notifyListeners();
      return false;
    }
    if (senha.isEmpty) {
      error = "Digite a senha";
      notifyListeners();
      return false;
    }

    try {
      loading = true;
      error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email.trim(), password: senha);

      loading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      loading = false;
      error = _tratarErroFirebase(e);
      notifyListeners();
      return false;
    } catch (e) {
      loading = false;
      error = "Erro inesperado";
      notifyListeners();
      return false;
    }
  }
  Future<bool> registrar(String email, String senha) async {
    if (!_validarEmail(email)) {
      error = "E-mail inválido";
      notifyListeners();
      return false;
    }
    if (senha.length < 6) {
      error = "Senha deve ter 6+ caracteres";
      notifyListeners();
      return false;
    }

    try {
      loading = true;
      error = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(email: email.trim(), password: senha);

      loading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      loading = false;
      error = _tratarErroFirebase(e);
      notifyListeners();
      return false;
    } catch (e) {
      loading = false;
      error = "Erro inesperado";
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
  bool _validarEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
  String _tratarErroFirebase(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Senha muito fraca';
      case 'email-already-in-use':
        return 'E-mail já cadastrado';
      case 'invalid-email':
        return 'E-mail inválido';
      case 'user-not-found':
      case 'wrong-password':
        return 'E-mail ou senha incorretos';
      default:
        return e.message ?? 'Erro ao autenticar';
    }
  }

  void limparErro() {
    error = null;
    notifyListeners();
  }
}