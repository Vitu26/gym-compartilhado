import 'package:equatable/equatable.dart';

abstract class AgendaEvent extends Equatable {
  const AgendaEvent();

  @override
  List<Object> get props => [];
}

class GetAllAgendas extends AgendaEvent {}

class CreateAgenda extends AgendaEvent {
  final Map<String, dynamic> agendaData;

  const CreateAgenda(this.agendaData);

  @override
  List<Object> get props => [agendaData];
}

class UpdateAgenda extends AgendaEvent {
  final String id;
  final Map<String, dynamic> agendaData;

  const UpdateAgenda(this.id, this.agendaData);

  @override
  List<Object> get props => [id, agendaData];
}

class DeleteAgenda extends AgendaEvent {
  final String id;

  const DeleteAgenda(this.id);

  @override
  List<Object> get props => [id];
}
// Evento que busca agendamentos de um dia específico
class GetAllAgendasForDay extends AgendaEvent {
  final DateTime day;
  GetAllAgendasForDay(this.day);
}
