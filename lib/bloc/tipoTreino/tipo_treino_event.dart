import 'package:equatable/equatable.dart';

abstract class TipoTreinoEvent extends Equatable {
  const TipoTreinoEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todos os tipos de treino
class GetAllTiposDeTreino extends TipoTreinoEvent {}

// Evento para criar um novo tipo de treino
class CreateTipoDeTreino extends TipoTreinoEvent {
  final Map<String, dynamic> tipoTreinoData;

  const CreateTipoDeTreino(this.tipoTreinoData);

  @override
  List<Object?> get props => [tipoTreinoData];
}

// Evento para obter os detalhes de um tipo de treino específico
class GetTipoDeTreino extends TipoTreinoEvent {
  final String id;

  const GetTipoDeTreino(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar um tipo de treino específico
class UpdateTipoDeTreino extends TipoTreinoEvent {
  final String id;
  final Map<String, dynamic> tipoTreinoData;

  const UpdateTipoDeTreino(this.id, this.tipoTreinoData);

  @override
  List<Object?> get props => [id, tipoTreinoData];
}

// Evento para deletar um tipo de treino específico
class DeleteTipoDeTreino extends TipoTreinoEvent {
  final String id;

  const DeleteTipoDeTreino(this.id);

  @override
  List<Object?> get props => [id];
}
