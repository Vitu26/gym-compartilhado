import 'package:equatable/equatable.dart';

abstract class RotinaHasTreinoEvent extends Equatable {
  const RotinaHasTreinoEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todas as rotinas com treino, agora com suporte para rotinaId
class GetAllRotinasHasTreinos extends RotinaHasTreinoEvent {
  final String rotinaId;

  const GetAllRotinasHasTreinos({required this.rotinaId});

  @override
  List<Object?> get props => [rotinaId];
}

// Evento para criar uma nova rotina com treino
class CreateRotinaHasTreino extends RotinaHasTreinoEvent {
  final Map<String, dynamic> rotinaHasTreinoData;

  const CreateRotinaHasTreino(this.rotinaHasTreinoData);

  @override
  List<Object?> get props => [rotinaHasTreinoData];
}

// Evento para obter os detalhes de uma rotina com treino específica
class GetRotinaHasTreino extends RotinaHasTreinoEvent {
  final String id;

  const GetRotinaHasTreino(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar uma rotina com treino específica
class UpdateRotinaHasTreino extends RotinaHasTreinoEvent {
  final String id;
  final Map<String, dynamic> rotinaHasTreinoData;

  const UpdateRotinaHasTreino(this.id, this.rotinaHasTreinoData);

  @override
  List<Object?> get props => [id, rotinaHasTreinoData];
}

// Evento para deletar uma rotina com treino específica
class DeleteRotinaHasTreino extends RotinaHasTreinoEvent {
  final String id;

  const DeleteRotinaHasTreino(this.id);

  @override
  List<Object?> get props => [id];
}
