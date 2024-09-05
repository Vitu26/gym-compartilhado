import 'package:equatable/equatable.dart';

abstract class TreinoEvent extends Equatable {
  const TreinoEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todos os treinos
class GetAllTreinos extends TreinoEvent {}

// Evento para criar um novo treino
class CreateTreino extends TreinoEvent {
  final Map<String, dynamic> treinoData;
  final String rotinaDeTreinoId; // Inclua o ID da rotina

  const CreateTreino(this.treinoData, this.rotinaDeTreinoId);

  @override
  List<Object?> get props => [treinoData, rotinaDeTreinoId];
}



// Evento para obter os detalhes de um treino específico
class GetTreino extends TreinoEvent {
  final String id;

  const GetTreino(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar um treino específico
class UpdateTreino extends TreinoEvent {
  final String id;
  final Map<String, dynamic> treinoData;

  const UpdateTreino(this.id, this.treinoData);

  @override
  List<Object?> get props => [id, treinoData];
}

// Evento para deletar um treino específico
class DeleteTreino extends TreinoEvent {
  final String id;

  const DeleteTreino(this.id);

  @override
  List<Object?> get props => [id];
}
