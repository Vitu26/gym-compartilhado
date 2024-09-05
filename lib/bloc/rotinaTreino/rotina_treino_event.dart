import 'package:equatable/equatable.dart';

abstract class RotinaDeTreinoEvent extends Equatable {
  const RotinaDeTreinoEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todas as rotinas de treino
class GetAllRotinasDeTreino extends RotinaDeTreinoEvent {}

// Evento para criar uma nova rotina de treino
class CreateRotinaDeTreino extends RotinaDeTreinoEvent {
  final Map<String, dynamic> rotinaData;

  const CreateRotinaDeTreino(this.rotinaData);

  @override
  List<Object?> get props => [rotinaData];
}

// Evento para obter os detalhes de uma rotina de treino específica
class GetRotinaDeTreino extends RotinaDeTreinoEvent {
  final String id;

  const GetRotinaDeTreino(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar uma rotina de treino específica
class UpdateRotinaDeTreino extends RotinaDeTreinoEvent {
  final String id;
  final Map<String, dynamic> rotinaData;

  const UpdateRotinaDeTreino(this.id, this.rotinaData);

  @override
  List<Object?> get props => [id, rotinaData];
}

// Evento para deletar uma rotina de treino específica
class DeleteRotinaDeTreino extends RotinaDeTreinoEvent {
  final String id;

  const DeleteRotinaDeTreino(this.id);

  @override
  List<Object?> get props => [id];
}
