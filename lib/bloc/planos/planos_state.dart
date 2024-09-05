import 'package:equatable/equatable.dart';

abstract class PlanoState extends Equatable {
  const PlanoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class PlanoInitial extends PlanoState {}

// Estado de carregamento
class PlanoLoading extends PlanoState {}

// Estado de sucesso ao obter todos os planos
class PlanoLoaded extends PlanoState {
  final List<dynamic> planos;

  const PlanoLoaded(this.planos);

  @override
  List<Object?> get props => [planos];
}

// Estado de sucesso ao obter detalhes de um plano específico
class PlanoDetailLoaded extends PlanoState {
  final Map<String, dynamic> data;

  PlanoDetailLoaded(this.data);

  @override
  List<Object> get props => [data];
}


// Estado de sucesso ao criar, atualizar ou deletar um plano
class PlanoSuccess extends PlanoState {
  final String message;

  const PlanoSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado de falha
class PlanoFailure extends PlanoState {
  final String error;

  const PlanoFailure(this.error);

  @override
  List<Object?> get props => [error];
}


