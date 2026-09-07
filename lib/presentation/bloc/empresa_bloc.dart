import 'package:consulta_cnpj_bloc/core/result/result.dart';
import 'package:consulta_cnpj_bloc/domain/repositories/empresa_repository.dart';
import 'package:consulta_cnpj_bloc/presentation/bloc/empresa_event.dart';
import 'package:consulta_cnpj_bloc/presentation/bloc/empresa_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpresaBloc extends Bloc<EmpresaEvent, EmpresaState> {
  final EmpresaRepository _repository;

  EmpresaBloc(this._repository) : super(EmpresaInitial()) {
    on<BuscarEmpresaEvent>((event, emit) async {
      emit(EmpresaLoading());

      final result = await _repository.getEmpresa(cnpj: event.cnpj);

      switch (result) {
        case Ok(value: final empresa):
          emit(EmpresaSuccess(empresa: empresa));
        case Err(error: final error):
          emit(EmpresaError(error));
      }
    });
  }
}
