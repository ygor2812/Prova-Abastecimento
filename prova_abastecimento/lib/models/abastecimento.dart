class Abastecimento {
  final String id;
  final double litros;
  final double valorLitro;
  final double valorTotal;
  final DateTime data;

  Abastecimento({
    required this.id,
    required this.litros,
    required this.valorLitro,
    required this.valorTotal,
    required this.data,
  });

  Abastecimento copyWith({
    String? id,
    double? litros,
    double? valorLitro,
    double? valorTotal,
    DateTime? data,
  }) {
    return Abastecimento(
      id: id ?? this.id,
      litros: litros ?? this.litros,
      valorLitro: valorLitro ?? this.valorLitro,
      valorTotal: valorTotal ?? this.valorTotal,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'litros': litros,
      'valorLitro': valorLitro,
      'valorTotal': valorTotal,
      'data': data.toIso8601String(),
    };
  }

  factory Abastecimento.fromMap(String id, Map<String, dynamic> map) {
    return Abastecimento(
      id: id,
      litros: map['litros']?.toDouble() ?? 0.0,
      valorLitro: map['valorLitro']?.toDouble() ?? 0.0,
      valorTotal: map['valorTotal']?.toDouble() ?? 0.0,
      data: DateTime.parse(map['data'] ?? DateTime.now().toIso8601String()),
    );
  }
}