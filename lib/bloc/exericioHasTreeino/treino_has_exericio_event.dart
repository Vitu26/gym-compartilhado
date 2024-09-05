import 'package:equatable/equatable.dart';

abstract class ExercicioTreinoEvent extends Equatable {
  const ExercicioTreinoEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todos os treinos com exercícios
class GetAllTreinosComExercicios extends ExercicioTreinoEvent {}

// Evento para criar um treino com exercício
class AddExercicioToTreino extends ExercicioTreinoEvent {
  final int treinoId;
  final int exercicioId;

  const AddExercicioToTreino({required this.treinoId, required this.exercicioId});

  @override
  List<Object?> get props => [treinoId, exercicioId];
}

// Evento para obter um treino específico com exercício
class GetTreinoComExercicio extends ExercicioTreinoEvent {
  final int id;

  const GetTreinoComExercicio(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para deletar um treino com exercício
class DeleteExercicioFromTreino extends ExercicioTreinoEvent {
  final int id;

  const DeleteExercicioFromTreino(this.id);

  @override
  List<Object?> get props => [id];
}
