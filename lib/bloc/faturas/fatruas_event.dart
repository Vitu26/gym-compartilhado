import 'package:equatable/equatable.dart';

abstract class FaturaEvent extends Equatable {
  const FaturaEvent();

  @override
  List<Object?> get props => [];
}

// Evento para obter todas as faturas
class GetAllFaturas extends FaturaEvent {}

// Evento para criar uma nova fatura
class CreateFatura extends FaturaEvent {
  final Map<String, dynamic> faturaData;

  const CreateFatura(this.faturaData);

  @override
  List<Object?> get props => [faturaData];
}

// Evento para obter os detalhes de uma fatura específica
class GetFatura extends FaturaEvent {
  final String id;

  const GetFatura(this.id);

  @override
  List<Object?> get props => [id];
}

// Evento para atualizar uma fatura específica
class UpdateFatura extends FaturaEvent {
  final String id;
  final Map<String, dynamic> faturaData;

  const UpdateFatura(this.id, this.faturaData);

  @override
  List<Object?> get props => [id, faturaData];
}

// Evento para deletar uma fatura específica
class DeleteFatura extends FaturaEvent {
  final String id;

  const DeleteFatura(this.id);

  @override
  List<Object?> get props => [id];
}
