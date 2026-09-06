import 'package:consulta_cnpj_bloc/core/errors/failures.dart';
import 'package:consulta_cnpj_bloc/domain/entities/empresa.dart';
import 'package:equatable/equatable.dart';

sealed class EmpresaState extends Equatable {
  const EmpresaState();

  @override
  List<Object?> get props => [];
}

final class EmpresaInitial extends EmpresaState {
  const EmpresaInitial();
}

final class EmpresaLoading extends EmpresaState {
  const EmpresaLoading();
}

final class EmpresaSuccess extends EmpresaState {
  final Empresa empresa;

  const EmpresaSuccess({required this.empresa});

  @override
  List<Object?> get props => [empresa];
}

final class EmpresaError extends EmpresaState {
  final Failures failure;

  const EmpresaError(this.failure);

  @override
  List<Object?> get props => [failure];
}
