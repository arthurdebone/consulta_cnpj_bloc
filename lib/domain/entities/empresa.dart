import 'package:consulta_cnpj_bloc/domain/entities/inscricao_estadual.dart';

class Empresa {
  final String razaoSocial;
  final String? capitalSocial;
  final DateTime? dataAtualzacao;
  final String porte;
  final String naturezaJuridica;
  final String cnpj;
  final String? nomeFantasia;
  final String situacao;
  final String? tipoLogradouro;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cep;
  final String atividadePrincipal;
  final String pais;
  final String estado;
  final String cidade;
  final List<InscricaoEstadual>? inscricaoEstaduais;

  const Empresa({
    required this.razaoSocial,
    this.capitalSocial,
    this.dataAtualzacao,
    required this.porte,
    required this.naturezaJuridica,
    required this.cnpj,
    this.nomeFantasia,
    required this.situacao,
    this.tipoLogradouro,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cep,
    required this.atividadePrincipal,
    required this.pais,
    required this.estado,
    required this.cidade,
    this.inscricaoEstaduais,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    final porte = json['porte'] as Map<String, dynamic>? ?? {};
    final naturezaJuridica = json['natureza_juridica'] as Map<String, dynamic>? ?? {};
    final estabelecimento = json['estabelecimento'] as Map<String, dynamic>? ?? {};
    final atividadePrincipal = estabelecimento['atividade_principal'] as Map<String, dynamic>? ?? {};
    final pais = estabelecimento['pais'] as Map<String, dynamic>? ?? {};
    final estado = estabelecimento['estado'] as Map<String, dynamic>? ?? {};
    final cidade = estabelecimento['cidade'] as Map<String, dynamic>? ?? {};

    final dtAtualizacao = json['atualizado_em'] != null ? DateTime.parse(json['atualizado_em'] as String) : null;

    return Empresa(
      razaoSocial: json['razao_social'] as String,
      capitalSocial: json['capital_social'] as String?,
      dataAtualzacao: dtAtualizacao,
      porte: porte['descricao'] as String,
      naturezaJuridica: naturezaJuridica['descricao'] as String,
      cnpj: estabelecimento['cnpj'] as String,
      nomeFantasia: estabelecimento['nome_fantasia'] as String?,
      situacao: estabelecimento['situacao_cadastral'] as String,
      tipoLogradouro: estabelecimento['tipo_logradouro'] as String?,
      logradouro: estabelecimento['logradouro'] as String,
      numero: estabelecimento['numero'] as String,
      bairro: estabelecimento['bairro'] as String,
      cep: estabelecimento['cep'] as String,
      atividadePrincipal: atividadePrincipal['descricao'] as String,
      pais: pais['nome'] as String,
      estado: estado['nome'] as String,
      cidade: cidade['nome'] as String,
      inscricaoEstaduais: (estabelecimento['inscricoes_estaduais'] as List<dynamic>?)
          ?.map((item) => InscricaoEstadual.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
