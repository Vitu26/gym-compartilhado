import 'package:equatable/equatable.dart';

abstract class PlanoEvent extends Equatable {
  const PlanoEvent();

  @override
  List<Object?> get props => [];
}


// Evento para criar um novo plano
class CreatePlano extends PlanoEvent {
  final Map<String, dynamic> planoData;

  const CreatePlano(this.planoData);

  @override
  List<Object?> get props => [planoData];
}

// Evento para obter os detalhes de um plano específico
class GetPlano extends PlanoEvent {
  final String id;

  const GetPlano(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar um plano específico
class UpdatePlano extends PlanoEvent {
  final String id;
  final Map<String, dynamic> planoData;

  const UpdatePlano(this.id, this.planoData);

  @override
  List<Object?> get props => [id, planoData];
}

// Evento para deletar um plano específico
class DeletePlano extends PlanoEvent {
  final String id;

  const DeletePlano(this.id);

  @override
  List<Object?> get props => [id];
}

class GetAllPlanos extends PlanoEvent {
  final String personalId;

  const GetAllPlanos(this.personalId);

  @override
  List<Object> get props => [personalId];
}