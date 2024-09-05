import 'package:equatable/equatable.dart';
import 'package:sprylife/models/model_tudo.dart';


abstract class TurmaState extends Equatable {
  const TurmaState();

  @override
  List<Object?> get props => [];
}

class TurmaInitial extends TurmaState {}

class TurmaLoading extends TurmaState {}

class TurmaLoaded extends TurmaState {
  final List<Turma> turmas;

  const TurmaLoaded({required this.turmas});

  @override
  List<Object?> get props => [turmas];
}

class TurmaDetailsLoaded extends TurmaState {
  final Turma turma;

  const TurmaDetailsLoaded({required this.turma});

  @override
  List<Object?> get props => [turma];
}

class TurmaSuccess extends TurmaState {
  final String message;

  const TurmaSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class TurmaFailure extends TurmaState {
  final String error;

  const TurmaFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
