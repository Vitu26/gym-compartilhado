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
  final Map<String, dynamic> treinoData; // Dados do treino
  final int rotinaDeTreinoId; // ID da rotina à qual o treino será associado

  CreateTreino({
    required this.treinoData,
    required this.rotinaDeTreinoId,
  });

  @override
  List<Object> get props => [treinoData, rotinaDeTreinoId];
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


// Adicione o evento de associação no arquivo treino_event.dart
class AssociateTreinoToRoutine extends TreinoEvent {
  final Map<String, dynamic> associarData;

  const AssociateTreinoToRoutine(this.associarData);

  @override
  List<Object?> get props => [associarData];
}
