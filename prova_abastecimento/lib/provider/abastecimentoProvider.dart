import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/abastecimento.dart';
import '../services/abastecimentoService.dart';

class AbastecimentoProvider extends ChangeNotifier {
  final AbastecimentoService _service = AbastecimentoService();

  List<Abastecimento> lista = [];
  bool carregando = false;
  String? erro;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  void carregar(String veiculoId) {
    final uid = _uid;
    if (uid == null) {
      erro = "Usuário não autenticado";
      notifyListeners();
      return;
    }

    carregando = true;
    notifyListeners();

    _service.getAbastecimentos(uid, veiculoId).listen(
      (dados) {
        lista = dados;
        carregando = false;
        notifyListeners();
      },
      onError: (e) {
        erro = e.toString();
        carregando = false;
        notifyListeners();
      },
    );
  }

  Future<bool> adicionar(String veiculoId, Abastecimento a) async {
    final uid = _uid;
    if (uid == null) return false;

    try {
      carregando = true;
      notifyListeners();
      await _service.adicionar(uid, veiculoId, a);
      carregando = false;
      notifyListeners();
      return true;
    } catch (e) {
      erro = e.toString();
      carregando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizar(String veiculoId, Abastecimento a) async {
    final uid = _uid;
    if (uid == null) return false;

    try {
      carregando = true;
      notifyListeners();
      await _service.atualizar(uid, veiculoId, a);
      carregando = false;
      notifyListeners();
      return true;
    } catch (e) {
      erro = e.toString();
      carregando = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> deletar(String veiculoId, String id) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      await _service.deletar(uid, veiculoId, id);
      lista.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }
}