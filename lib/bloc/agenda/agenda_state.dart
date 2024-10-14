import 'package:equatable/equatable.dart';
import 'package:sprylife/models/model_tudo.dart';

abstract class AgendaState extends Equatable {
  const AgendaState();

  @override
  List<Object> get props => [];
}

class AgendaLoading extends AgendaState {}

// class AgendaLoaded extends AgendaState {
//   final List<Map<String, dynamic>> agendas;

//   const AgendaLoaded(this.agendas);

//   @override
//   List<Object> get props => [agendas];
// }

class AgendaLoaded extends AgendaState {
  final List<AgendaModel> agendas;

  AgendaLoaded(this.agendas);
}

class AgendaSuccess extends AgendaState {
  final String message;

  const AgendaSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AgendaError extends AgendaState {
  final String error;

  const AgendaError(this.error);

  @override
  List<Object> get props => [error];
}
