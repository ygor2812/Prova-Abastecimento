import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/veiculo.dart';

class VeiculoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Veiculo>> getVeiculos(String uid) {
    return _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .orderBy('modelo')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Veiculo.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> adicionarVeiculo(String uid, Veiculo v) async {
    await _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .add(v.toMap());
  }

  Future<void> atualizarVeiculo(String uid, Veiculo v) async {
    await _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(v.id)
        .update(v.toMap());
  }

  Future<void> deletarVeiculo(String uid, String id) async {
    await _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(id)
        .delete();
  }
}