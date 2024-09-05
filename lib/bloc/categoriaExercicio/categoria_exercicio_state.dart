import 'package:equatable/equatable.dart';

abstract class CategoriaExercicioState extends Equatable {
  const CategoriaExercicioState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class CategoriaExercicioInitial extends CategoriaExercicioState {}

// Estado de carregamento
class CategoriaExercicioLoading extends CategoriaExercicioState {}

// Estado de sucesso ao obter todas as categorias de exercícios
class CategoriaExercicioLoaded extends CategoriaExercicioState {
  final List<dynamic> categorias;

  const CategoriaExercicioLoaded(this.categorias);

  @override
  List<Object?> get props => [categorias];
}

// Estado de sucesso ao obter detalhes de uma categoria de exercício específica
class CategoriaExercicioDetailLoaded extends CategoriaExercicioState {
  final Map<String, dynamic> categoria;

  const CategoriaExercicioDetailLoaded(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

// Estado de sucesso ao criar, atualizar ou deletar uma categoria de exercício
class CategoriaExercicioSuccess extends CategoriaExercicioState {
  final String message;

  const CategoriaExercicioSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado de falha
class CategoriaExercicioFailure extends CategoriaExercicioState {
  final String error;

  const CategoriaExercicioFailure(this.error);

  @override
  List<Object?> get props => [error];
}
