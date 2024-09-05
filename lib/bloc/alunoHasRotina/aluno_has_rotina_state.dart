import 'package:equatable/equatable.dart';

abstract class AlunoHasRotinaState extends Equatable {
  const AlunoHasRotinaState();

  @override
  List<Object> get props => [];
}

class AlunoHasRotinaInitial extends AlunoHasRotinaState {}

class AlunoHasRotinaLoading extends AlunoHasRotinaState {}

class AlunoHasRotinaLoaded extends AlunoHasRotinaState {
  final List<dynamic> rotinas;

  const AlunoHasRotinaLoaded(this.rotinas);

  @override
  List<Object> get props => [rotinas];
}

class AlunoHasRotinaFailure extends AlunoHasRotinaState {
  final String error;

  const AlunoHasRotinaFailure(this.error);

  @override
  List<Object> get props => [error];
}
