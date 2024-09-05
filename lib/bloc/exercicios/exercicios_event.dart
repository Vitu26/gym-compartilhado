import 'package:equatable/equatable.dart';

abstract class ExercicioEvent extends Equatable {
  const ExercicioEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todos os exercícios
class GetAllExercicios extends ExercicioEvent {}

// Evento para criar um novo exercício
class CreateExercicio extends ExercicioEvent {
  final Map<String, dynamic> exercicioData;

  const CreateExercicio(this.exercicioData);

  @override
  List<Object?> get props => [exercicioData];
}

// Evento para obter os detalhes de um exercício específico
class GetExercicio extends ExercicioEvent {
  final String id;

  const GetExercicio(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar um exercício específico
class UpdateExercicio extends ExercicioEvent {
  final String id;
  final Map<String, dynamic> exercicioData;

  const UpdateExercicio(this.id, this.exercicioData);

  @override
  List<Object?> get props => [id, exercicioData];
}

// Evento para deletar um exercício específico
class DeleteExercicio extends ExercicioEvent {
  final String id;

  const DeleteExercicio(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para obter todos os exercícios de um treino específico
class GetAllExerciciosForTreino extends ExercicioEvent {
  final int treinoId;

  const GetAllExerciciosForTreino({required this.treinoId});

  @override
  List<Object?> get props => [treinoId];
}

// Evento para obter todos os exercícios de uma categoria específica
class GetAllExerciciosByCategory extends ExercicioEvent {
  final int categoryId;

  const GetAllExerciciosByCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

// Evento para adicionar um exercício a um treino
class AddExerciseToTreino extends ExercicioEvent {
  final int treinoId;
  final int exerciseId;

  const AddExerciseToTreino({required this.treinoId, required this.exerciseId});

  @override
  List<Object?> get props => [treinoId, exerciseId];
}


// Evento para remover um exercício de um treino
class RemoveExerciseFromTreino extends ExercicioEvent {
  final int treinoId;
  final int exerciseId;

  const RemoveExerciseFromTreino({required this.treinoId, required this.exerciseId});

  @override
  List<Object?> get props => [treinoId, exerciseId];
}
