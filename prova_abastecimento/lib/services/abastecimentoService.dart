import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/abastecimento.dart';

class AbastecimentoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Abastecimento>> getAbastecimentos(String uid, String veiculoId) {
    return _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(veiculoId)
        .collection('abastecimentos')
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Abastecimento.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> adicionar(String uid, String veiculoId, Abastecimento a) async {
    final ref = _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(veiculoId)
        .collection('abastecimentos')
        .doc();

    final novo = a.copyWith(id: ref.id);
    await ref.set(novo.toMap());
  }

  Future<void> atualizar(String uid, String veiculoId, Abastecimento a) async {
    await _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(veiculoId)
        .collection('abastecimentos')
        .doc(a.id)
        .update(a.toMap());
  }

  Future<void> deletar(String uid, String veiculoId, String id) async {
    await _db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(veiculoId)
        .collection('abastecimentos')
        .doc(id)
        .delete();
  }
}