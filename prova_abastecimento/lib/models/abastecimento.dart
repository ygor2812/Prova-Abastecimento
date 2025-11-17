class Abastecimento {
  final String id;
  final double litros;
  final double valorLitro;
  final double valorTotal;
  final DateTime data;
  final double quilometragem;
  final double consumo;
  final String observacao;

  Abastecimento({
    required this.id,
    required this.litros,
    required this.valorLitro,
    required this.valorTotal,
    required this.data,
    required this.quilometragem,
    this.consumo = 0.0,
    this.observacao = '',
  });

  Abastecimento copyWith({
    String? id,
    double? litros,
    double? valorLitro,
    double? valorTotal,
    DateTime? data,
    double? quilometragem,
    double? consumo,
    String? observacao,
  }) {
    return Abastecimento(
      id: id ?? this.id,
      litros: litros ?? this.litros,
      valorLitro: valorLitro ?? this.valorLitro,
      valorTotal: valorTotal ?? this.valorTotal,
      data: data ?? this.data,
      quilometragem: quilometragem ?? this.quilometragem,
      consumo: consumo ?? this.consumo,
      observacao: observacao ?? this.observacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'litros': litros,
      'valorLitro': valorLitro,
      'valorTotal': valorTotal,
      'data': data.toIso8601String(),
      'quilometragem': quilometragem,
      'consumo': consumo,
      'observacao': observacao,
    };
  }

  factory Abastecimento.fromMap(String id, Map<String, dynamic> map) {
    return Abastecimento(
      id: id,
      litros: map['litros']?.toDouble() ?? 0.0,
      valorLitro: map['valorLitro']?.toDouble() ?? 0.0,
      valorTotal: map['valorTotal']?.toDouble() ?? 0.0,
      data: DateTime.parse(map['data'] ?? DateTime.now().toIso8601String()),
      quilometragem: map['quilometragem']?.toDouble() ?? 0.0,
      consumo: map['consumo']?.toDouble() ?? 0.0,
      observacao: map['observacao'] ?? '',
    );
  }
}