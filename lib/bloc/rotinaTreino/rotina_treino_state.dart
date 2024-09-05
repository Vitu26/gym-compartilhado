import 'package:equatable/equatable.dart';

abstract class RotinaDeTreinoState extends Equatable {
  const RotinaDeTreinoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class RotinaDeTreinoInitial extends RotinaDeTreinoState {}

// Estado de carregamento
class RotinaDeTreinoLoading extends RotinaDeTreinoState {}

// Estado de sucesso ao obter todas as rotinas de treino
class RotinaDeTreinoLoaded extends RotinaDeTreinoState {
  final List<dynamic> rotinas;

  const RotinaDeTreinoLoaded(this.rotinas);

  @override
  List<Object?> get props => [rotinas];
}

// Estado de sucesso ao obter detalhes de uma rotina específica
class RotinaDeTreinoDetailLoaded extends RotinaDeTreinoState {
  final Map<String, dynamic> rotina;

  const RotinaDeTreinoDetailLoaded(this.rotina);

  @override
  List<Object?> get props => [rotina];
}

// Estado de sucesso ao criar, atualizar ou deletar uma rotina
class RotinaDeTreinoSuccess extends RotinaDeTreinoState {
  final String message;

  const RotinaDeTreinoSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado de falha
class RotinaDeTreinoFailure extends RotinaDeTreinoState {
  final String error;

  const RotinaDeTreinoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
