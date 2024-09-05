import 'package:equatable/equatable.dart';

abstract class InformacoesComunsState extends Equatable {
  const InformacoesComunsState();

  @override
  List<Object> get props => [];
}

class InformacoesComunsLoading extends InformacoesComunsState {}

class InformacoesComunsLoaded extends InformacoesComunsState {
  final Map<String, dynamic> informacoesComuns;

  const InformacoesComunsLoaded(this.informacoesComuns);

  @override
  List<Object> get props => [informacoesComuns];
}

class InformacoesComunsCreated extends InformacoesComunsState {
  final int id; // Inclua o campo id

  const InformacoesComunsCreated(this.id); // Passe o id no construtor

  @override
  List<Object> get props => [id]; // Adicione o id nos props
}


class InformacoesComunsUpdated extends InformacoesComunsState {}

class InformacoesComunsDeleted extends InformacoesComunsState {}

class InformacoesComunsError extends InformacoesComunsState {
  final String error;

  const InformacoesComunsError(this.error);

  @override
  List<Object> get props => [error];
}
