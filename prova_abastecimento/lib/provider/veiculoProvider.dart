import 'package:flutter/material.dart';
import '../models/veiculo.dart';
import '../services/veiculoService.dart';

class VeiculoProvider extends ChangeNotifier {
  final VeiculoService _service = VeiculoService();

  List<Veiculo> lista = [];
  bool carregando = false;
  String? erro;

  void carregar() {
    _service.getVeiculos().listen((dados) {
      lista = dados;
      notifyListeners();
    });
  }

  Future<bool> adicionar(Veiculo v) async {
    try {
      carregando = true;
      notifyListeners();

      await _service.adicionarVeiculo(v);

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
    try {
      carregando = true;
      notifyListeners();

      await _service.atualizarVeiculo(v);

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
    try {
      await _service.deletarVeiculo(id);
      notifyListeners();
    } catch (e) {
      erro = e.toString();
    }
  }
}