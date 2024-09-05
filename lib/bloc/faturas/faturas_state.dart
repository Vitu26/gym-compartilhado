import 'package:equatable/equatable.dart';

abstract class FaturaState extends Equatable {
  const FaturaState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class FaturaInitial extends FaturaState {}

// Estado de carregamento
class FaturaLoading extends FaturaState {}

// Estado de sucesso ao obter todas as faturas
class FaturaLoaded extends FaturaState {
  final List<dynamic> faturas;

  const FaturaLoaded(this.faturas);

  @override
  List<Object?> get props => [faturas];
}

// Estado de sucesso ao obter detalhes de uma fatura específica
class FaturaDetailLoaded extends FaturaState {
  final Map<String, dynamic> fatura;

  const FaturaDetailLoaded(this.fatura);

  @override
  List<Object?> get props => [fatura];
}

// Estado de sucesso ao criar, atualizar ou deletar uma fatura
class FaturaSuccess extends FaturaState {
  final String message;

  const FaturaSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado de falha
class FaturaFailure extends FaturaState {
  final String error;

  const FaturaFailure(this.error);

  @override
  List<Object?> get props => [error];
}
