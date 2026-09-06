import 'dart:convert';
import 'dart:io';

import 'package:consulta_cnpj_bloc/core/constants/api_constants.dart';
import 'package:consulta_cnpj_bloc/core/errors/exceptions.dart';
import 'package:consulta_cnpj_bloc/domain/entities/empresa.dart';
import 'package:http/http.dart' as http;

abstract class EmpresaRemoteDatasource {
  Future<Empresa> getEmpresa({required String cnpj});
}

class EmpresaRemoteDatasourceImpl implements EmpresaRemoteDatasource {
  final http.Client _client;
  const EmpresaRemoteDatasourceImpl(this._client);

  @override
  Future<Empresa> getEmpresa({required String cnpj}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$cnpj');

    try {
      final response = await _client.get(url);

      switch (response.statusCode) {
        case 200:
          return Empresa.fromJson(jsonDecode(response.body));
        case 404:
          throw ServerException('CNPJ não encontrado na base de dados.', statusCode: 404);
        case 500:
          throw ServerException('Servidor instável. Tente novamente mais tarde.', statusCode: 500);
        default:
          throw ServerException('Erro de servidor não mapeado.', statusCode: response.statusCode);
      }
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet.');
    } on FormatException {
      throw const ServerException('Dados corrompidos ou formato inválido recebido da API.');
    }
  }
}
