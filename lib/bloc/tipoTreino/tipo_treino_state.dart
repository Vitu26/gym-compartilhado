import 'package:equatable/equatable.dart';

abstract class TipoTreinoState extends Equatable {
  const TipoTreinoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class TipoTreinoInitial extends TipoTreinoState {}

// Estado de carregamento
class TipoTreinoLoading extends TipoTreinoState {}

// Estado de sucesso ao obter todos os tipos de treino
class TipoTreinoLoaded extends TipoTreinoState {
  final List<dynamic> tiposTreino;

  const TipoTreinoLoaded(this.tiposTreino);

  @override
  List<Object?> get props => [tiposTreino];
}

// Estado de sucesso ao obter detalhes de um tipo de treino específico
class TipoTreinoDetailLoaded extends TipoTreinoState {
  final Map<String, dynamic> tipoTreino;

  const TipoTreinoDetailLoaded(this.tipoTreino);

  @override
  List<Object?> get props => [tipoTreino];
}

// Estado de sucesso ao criar, atualizar ou deletar um tipo de treino
class TipoTreinoSuccess extends TipoTreinoState {
  final String message;

  const TipoTreinoSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado de falha
class TipoTreinoFailure extends TipoTreinoState {
  final String error;

  const TipoTreinoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
