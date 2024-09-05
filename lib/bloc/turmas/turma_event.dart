import 'package:equatable/equatable.dart';
import 'package:sprylife/models/model_tudo.dart';


abstract class TurmaEvent extends Equatable {
  const TurmaEvent();

  @override
  List<Object?> get props => [];
}

class LoadTurmas extends TurmaEvent {}

class AddTurma extends TurmaEvent {
  final Turma turma;

  const AddTurma({required this.turma});

  @override
  List<Object?> get props => [turma];
}

class UpdateTurma extends TurmaEvent {
  final Turma turma;

  const UpdateTurma({required this.turma});

  @override
  List<Object?> get props => [turma];
}

class DeleteTurma extends TurmaEvent {
  final int id;

  const DeleteTurma({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetTurmaDetails extends TurmaEvent {
  final int id;

  const GetTurmaDetails({required this.id});

  @override
  List<Object?> get props => [id];
}
