import 'package:equatable/equatable.dart';

abstract class AvaliacaoState extends Equatable {
  const AvaliacaoState();

  @override
  List<Object?> get props => [];
}

class AvaliacaoInitial extends AvaliacaoState {}

class AvaliacaoLoading extends AvaliacaoState {}

class AvaliacaoLoaded extends AvaliacaoState {
  final List<dynamic> avaliacoes;

  const AvaliacaoLoaded({required this.avaliacoes});

  @override
  List<Object?> get props => [avaliacoes];
}

class AvaliacaoDetailLoaded extends AvaliacaoState {
  final Map<String, dynamic> avaliacao;

  const AvaliacaoDetailLoaded({required this.avaliacao});

  @override
  List<Object?> get props => [avaliacao];
}

class AvaliacaoSuccess extends AvaliacaoState {
  final String message;

  const AvaliacaoSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AvaliacaoFailure extends AvaliacaoState {
  final String error;

  const AvaliacaoFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AvaliacaoError extends AvaliacaoState {
  final String message;

  AvaliacaoError({required this.message});
}
