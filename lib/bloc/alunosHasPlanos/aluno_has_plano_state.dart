import 'package:equatable/equatable.dart';

abstract class AlunoHasPlanoState extends Equatable {
  const AlunoHasPlanoState();

  @override
  List<Object?> get props => [];
}

class AlunoHasPlanoInitial extends AlunoHasPlanoState {}

class AlunoHasPlanoLoading extends AlunoHasPlanoState {}

class AlunoHasPlanoSuccess extends AlunoHasPlanoState {
  final dynamic data;

  const AlunoHasPlanoSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AlunoHasPlanoFailure extends AlunoHasPlanoState {
  final String error;

  const AlunoHasPlanoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
