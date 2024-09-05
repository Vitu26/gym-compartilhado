import 'package:equatable/equatable.dart';

abstract class ExercicioTreinoState extends Equatable {
  const ExercicioTreinoState();

  @override
  List<Object?> get props => [];
}

class ExercicioTreinoInitial extends ExercicioTreinoState {}

class ExercicioTreinoLoading extends ExercicioTreinoState {}

class ExercicioTreinoLoaded extends ExercicioTreinoState {
  final List<dynamic> treinosExercicios;

  const ExercicioTreinoLoaded(this.treinosExercicios);

  @override
  List<Object?> get props => [treinosExercicios];
}

class ExercicioTreinoAdded extends ExercicioTreinoState {
  final String message;

  const ExercicioTreinoAdded(this.message);

  @override
  List<Object?> get props => [message];
}

class ExercicioTreinoDeleted extends ExercicioTreinoState {
  final String message;

  const ExercicioTreinoDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

class ExercicioTreinoFailure extends ExercicioTreinoState {
  final String error;

  const ExercicioTreinoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
