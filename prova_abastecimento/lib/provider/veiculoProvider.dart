import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/veiculo.dart';
import '../services/veiculoService.dart';

class VeiculoProvider extends ChangeNotifier {
  final VeiculoService _service = VeiculoService();

  List<Veiculo> lista = [];
  bool carregando = false;
  String? erro;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  void carregar() {
    final uid = _uid;
    if (uid == null) {
      erro = "Usuário não autenticado";
      notifyListeners();
      return;
    }

    carregando = true;
    notifyListeners();

    _service.getVeiculos(uid).listen(
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

  Future<bool> adicionar(Veiculo v) async {
    final uid = _uid;
    if (uid == null) {
      erro = "Usuário não autenticado";
      notifyListeners();
      return false;
    }

    try {
      carregando = true;
      notifyListeners();

      await _service.adicionarVeiculo(uid, v);

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

  Future<bool> atualizar(Veiculo v) async {
    final uid = _uid;
    if (uid == null) {
      erro = "Usuário não autenticado";
      notifyListeners();
      return false;
    }

    try {
      carregando = true;
      notifyListeners();

      await _service.atualizarVeiculo(uid, v);

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

  Future<void> deletar(String id) async {
    final uid = _uid;
    if (uid == null) {
      erro = "Usuário não autenticado";
      notifyListeners();
      return;
    }

    try {
      await _service.deletarVeiculo(uid, id);
      lista.removeWhere((v) => v.id == id);
      notifyListeners();
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }
}