import 'package:equatable/equatable.dart';

abstract class AlunoState extends Equatable {
  const AlunoState();

  @override
  List<Object> get props => [];
}

class AlunoInitial extends AlunoState {}

class AlunoLoading extends AlunoState {}

class AlunoSuccess extends AlunoState {
  final dynamic data; // Alterando o nome para 'data'

  const AlunoSuccess(this.data);

  @override
  List<Object> get props => [data];
}


class AlunoFailure extends AlunoState {
  final String error;

  const AlunoFailure(this.error);

  @override
  List<Object> get props => [error];
}

// aluno_state.dart

class ObjetivosLoaded extends AlunoState {
  final List<dynamic> objetivos;

  ObjetivosLoaded({required this.objetivos});

  @override
  List<Object> get props => [objetivos];
}

class ModalidadesLoaded extends AlunoState {
  final List<dynamic> modalidades;

  ModalidadesLoaded({required this.modalidades});

  @override
  List<Object> get props => [modalidades];
}

class NiveisAtividadeLoaded extends AlunoState {
  final List<dynamic> niveisAtividade;

  NiveisAtividadeLoaded({required this.niveisAtividade});

  @override
  List<Object> get props => [niveisAtividade];
}

class AllDataLoaded extends AlunoState {
  final List<dynamic> objetivos;
  final List<dynamic> modalidades;
  final List<dynamic> niveisAtividade;

  AllDataLoaded({
    required this.objetivos,
    required this.modalidades,
    required this.niveisAtividade,
  });
}


