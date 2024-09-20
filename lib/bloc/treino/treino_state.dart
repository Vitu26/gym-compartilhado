import 'package:equatable/equatable.dart';

abstract class TreinoState extends Equatable {
  const TreinoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class TreinoInitial extends TreinoState {}

// Estado de carregamento
class TreinoLoading extends TreinoState {}

// Estado de sucesso ao obter todos os treinos
class TreinoLoaded extends TreinoState {
  final List<dynamic> treinos;

  const TreinoLoaded(this.treinos);

  @override
  List<Object?> get props => [treinos];
}

// Estado de sucesso ao obter detalhes de um treino específico
class TreinoDetailLoaded extends TreinoState {
  final Map<String, dynamic> treino;

  const TreinoDetailLoaded(this.treino);

  @override
  List<Object?> get props => [treino];
}

// Estado de sucesso ao criar, atualizar ou deletar um treino
class TreinoSuccess extends TreinoState {
  final String message;
  final int? treinoId; // Adiciona o treinoId opcional

  const TreinoSuccess(this.message, {this.treinoId});

  @override
  List<Object?> get props => [message, treinoId];
}

// Estado de falha
class TreinoFailure extends TreinoState {
  final String error;

  const TreinoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
