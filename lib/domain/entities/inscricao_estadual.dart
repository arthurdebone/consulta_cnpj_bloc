class InscricaoEstadual {
  final String inscricaoEstadual;
  final String situacao;
  final DateTime? dtAtualizacao;
  final String estado;

  const InscricaoEstadual({
    required this.inscricaoEstadual,
    required this.situacao,
    this.dtAtualizacao,
    required this.estado,
  });

  factory InscricaoEstadual.fromJson(Map<String, dynamic> json) {
    final estado = json['estado'] as Map<String, dynamic>? ?? {};

    //Tratamento se IE está Ativa
    final estaAtivo = json['ativo'] as bool;
    final situacao = estaAtivo ? 'Ativo' : 'Inativo';

    //Tratamento Data
    final dtConvertida = json['atualizado_em'] != null ? DateTime.parse(json['atualizado_em'] as String) : null;

    return InscricaoEstadual(
      inscricaoEstadual: json['inscricao_estadual'] as String,
      situacao: situacao,
      dtAtualizacao: dtConvertida,
      estado: estado['nome'] as String,
    );
  }
}
