import 'package:equatable/equatable.dart';

abstract class AlunoHasPlanoEvent extends Equatable {
  const AlunoHasPlanoEvent();

  @override
  List<Object?> get props => [];
}

class FetchAlunosHasPlano extends AlunoHasPlanoEvent {
  final String alunoId;

  FetchAlunosHasPlano(this.alunoId);

  @override
  List<Object> get props => [alunoId];
}


class CreateAlunoHasPlano extends AlunoHasPlanoEvent {
  final int planoId;
  final int alunoId;

  const CreateAlunoHasPlano({required this.planoId, required this.alunoId});

  @override
  List<Object?> get props => [planoId, alunoId];
}

class GetAlunoHasPlano extends AlunoHasPlanoEvent {
  final int id;

  const GetAlunoHasPlano(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateAlunoHasPlano extends AlunoHasPlanoEvent {
  final int id;
  final int planoId;
  final int alunoId;

  const UpdateAlunoHasPlano(
      {required this.id, required this.planoId, required this.alunoId});

  @override
  List<Object?> get props => [id, planoId, alunoId];
}

class DeleteAlunoHasPlano extends AlunoHasPlanoEvent {
  final int id;

  const DeleteAlunoHasPlano(this.id);

  @override
  List<Object?> get props => [id];
}


