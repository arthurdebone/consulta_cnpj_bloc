import 'package:consulta_cnpj_bloc/core/errors/failures.dart';
import 'package:consulta_cnpj_bloc/core/result/result.dart';
import 'package:consulta_cnpj_bloc/domain/entities/empresa.dart';

abstract class EmpresaRepository {
  Future<Result<Empresa, Failures>> getEmpresa({required String cnpj});
}
