import 'package:equatable/equatable.dart';

abstract class PersonalState extends Equatable {
  const PersonalState();

  @override
  List<Object> get props => [];
}

// Estado inicial antes de qualquer ação ser tomada
class PersonalInitial extends PersonalState {}

// Estado de carregamento, usado enquanto uma operação está em andamento
class PersonalLoading extends PersonalState {}

// Estado de sucesso, que contém os dados retornados da operação bem-sucedida
class PersonalSuccess extends PersonalState {
  final dynamic data;

  const PersonalSuccess(this.data);

  @override
  List<Object> get props => [data];
}

// Estado de falha, que contém uma mensagem de erro
class PersonalFailure extends PersonalState {
  final String error;

  const PersonalFailure(this.error);

  @override
  List<Object> get props => [error];
}

// State for when the current password is loaded
class PersonalPasswordLoaded extends PersonalState {
  final String password;

  PersonalPasswordLoaded(this.password);

  @override
  List<Object> get props => [password];
}


