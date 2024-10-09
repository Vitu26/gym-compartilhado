import 'package:equatable/equatable.dart';

abstract class AvaliacaoEvent extends Equatable {
  const AvaliacaoEvent();

  @override
  List<Object?> get props => [];
}

class GetAllAvaliacoes extends AvaliacaoEvent {}

class CreateAvaliacao extends AvaliacaoEvent {
  final int nota;
  final String comentario;
  final int personalId;

  const CreateAvaliacao({
    required this.nota,
    required this.comentario,
    required this.personalId,
  });

  @override
  List<Object?> get props => [nota, comentario, personalId];
}

class GetAvaliacao extends AvaliacaoEvent {
  final int id;

  const GetAvaliacao({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateAvaliacao extends AvaliacaoEvent {
  final int id;
  final int nota;
  final String comentario;
  final int personalId;

  const UpdateAvaliacao({
    required this.id,
    required this.nota,
    required this.comentario,
    required this.personalId,
  });

  @override
  List<Object?> get props => [id, nota, comentario, personalId];
}

class DeleteAvaliacao extends AvaliacaoEvent {
  final int id;

  const DeleteAvaliacao({required this.id});

  @override
  List<Object?> get props => [id];
}

class FetchAvaliacoes extends AvaliacaoEvent {
  final int personalId;

  FetchAvaliacoes({required this.personalId});
}

class AddAvaliacao extends AvaliacaoEvent {
  final Map<String, dynamic> avaliacaoData;

  AddAvaliacao({required this.avaliacaoData});
}
