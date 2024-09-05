import 'package:equatable/equatable.dart';

abstract class ExercicioState extends Equatable {
  const ExercicioState();

  @override
  List<Object?> get props => [];

  // Getters para acessar os dados nos estados
  List<dynamic> get exercicios => [];
  Map<String, dynamic> get exercicio => {};
  String get message => '';
  String get error => '';
}

// Estado inicial
class ExercicioInitial extends ExercicioState {}

// Estado de carregamento
class ExercicioLoading extends ExercicioState {}

// Estado de sucesso ao obter todos os exercícios
class ExercicioLoaded extends ExercicioState {
  final List<dynamic> _exercicios;

  const ExercicioLoaded(this._exercicios);

  @override
  List<Object?> get props => [_exercicios];

  // Getter para exercícios
  @override
  List<dynamic> get exercicios => _exercicios;
}

// Estado de sucesso ao obter detalhes de um exercício específico
class ExercicioDetailLoaded extends ExercicioState {
  final Map<String, dynamic> _exercicio;

  const ExercicioDetailLoaded(this._exercicio);

  @override
  List<Object?> get props => [_exercicio];

  // Getter para o exercício específico
  @override
  Map<String, dynamic> get exercicio => _exercicio;
}

// Estado de sucesso ao criar, atualizar ou deletar um exercício
class ExercicioSuccess extends ExercicioState {
  final String _message;

  const ExercicioSuccess(this._message);

  @override
  List<Object?> get props => [_message];

  // Getter para mensagem de sucesso
  @override
  String get message => _message;
}

// Estado de falha
class ExercicioFailure extends ExercicioState {
  final String _error;

  const ExercicioFailure(this._error);

  @override
  List<Object?> get props => [_error];

  // Getter para a mensagem de erro
  @override
  String get error => _error;
}
