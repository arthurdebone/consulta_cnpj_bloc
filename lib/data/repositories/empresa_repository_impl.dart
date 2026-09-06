import 'package:consulta_cnpj_bloc/core/errors/exceptions.dart';
import 'package:consulta_cnpj_bloc/core/errors/failures.dart';
import 'package:consulta_cnpj_bloc/core/result/result.dart';
import 'package:consulta_cnpj_bloc/data/datasources/empresa_remote_datasource.dart';
import 'package:consulta_cnpj_bloc/domain/entities/empresa.dart';
import 'package:consulta_cnpj_bloc/domain/repositories/empresa_repository.dart';

class EmpresaRepositoryImpl implements EmpresaRepository {
  final EmpresaRemoteDatasource _datasource;
  const EmpresaRepositoryImpl(this._datasource);

  @override
  Future<Result<Empresa, Failures>> getEmpresa({required String cnpj}) async {
    try {
      final empresa = await _datasource.getEmpresa(cnpj: cnpj);
      return Result.success(empresa);
    } on ServerException catch (e) {
      return Result.failure(FalhaServidor(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Result.failure(FalhaConexao(e.message));
    } catch (e) {
      return Result.failure(FalhaDesconhecida(e.toString()));
    }
  }
}
