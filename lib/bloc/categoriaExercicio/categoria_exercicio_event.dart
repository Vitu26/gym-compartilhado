import 'package:equatable/equatable.dart';

abstract class CategoriaExercicioEvent extends Equatable {
  const CategoriaExercicioEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todas as categorias de exercícios
class GetAllCategoriasExercicio extends CategoriaExercicioEvent {}

// Evento para criar uma nova categoria de exercício
class CreateCategoriaExercicio extends CategoriaExercicioEvent {
  final Map<String, dynamic> categoriaData;

  const CreateCategoriaExercicio(this.categoriaData);

  @override
  List<Object?> get props => [categoriaData];
}

// Evento para obter os detalhes de uma categoria de exercício específica
class GetCategoriaExercicio extends CategoriaExercicioEvent {
  final String id;

  const GetCategoriaExercicio(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar uma categoria de exercício específica
class UpdateCategoriaExercicio extends CategoriaExercicioEvent {
  final String id;
  final Map<String, dynamic> categoriaData;

  const UpdateCategoriaExercicio(this.id, this.categoriaData);

  @override
  List<Object?> get props => [id, categoriaData];
}

// Evento para deletar uma categoria de exercício específica
class DeleteCategoriaExercicio extends CategoriaExercicioEvent {
  final String id;

  const DeleteCategoriaExercicio(this.id);

  @override
  List<Object?> get props => [id];
}
