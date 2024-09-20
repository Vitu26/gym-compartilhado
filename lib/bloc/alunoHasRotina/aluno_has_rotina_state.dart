import 'package:equatable/equatable.dart';

abstract class AlunoHasRotinaState extends Equatable {
  const AlunoHasRotinaState();

  @override
  List<Object> get props => [];
}

class AlunoHasRotinaInitial extends AlunoHasRotinaState {}

class AlunoHasRotinaLoading extends AlunoHasRotinaState {}

class AlunoHasRotinaLoaded extends AlunoHasRotinaState {
  final List<dynamic> data;

  const AlunoHasRotinaLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class AlunoHasRotinaSuccess extends AlunoHasRotinaState {
  final String message;

  const AlunoHasRotinaSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AlunoHasRotinaFailure extends AlunoHasRotinaState {
  final String error;

  const AlunoHasRotinaFailure(this.error);

  @override
  List<Object> get props => [error];
}
