import 'package:equatable/equatable.dart';

abstract class RotinaHasTreinoState extends Equatable {
  const RotinaHasTreinoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class RotinaHasTreinoInitial extends RotinaHasTreinoState {}

// Estado de carregamento
class RotinaHasTreinoLoading extends RotinaHasTreinoState {}

// Estado de sucesso ao obter todas as rotinas com treino
// class RotinaHasTreinoLoaded extends RotinaHasTreinoState {
//   final List<dynamic> rotinasHasTreinos;

//   const RotinaHasTreinoLoaded(this.rotinasHasTreinos);

//   @override
//   List<Object?> get props => [rotinasHasTreinos];
// }

// Estado de sucesso ao obter detalhes de uma rotina com treino específica
class RotinaHasTreinoDetailLoaded extends RotinaHasTreinoState {
  final Map<String, dynamic> rotinaHasTreino;

  const RotinaHasTreinoDetailLoaded(this.rotinaHasTreino);

  @override
  List<Object?> get props => [rotinaHasTreino];
}

// Estado de sucesso ao criar, atualizar ou deletar uma rotina com treino
class RotinaHasTreinoSuccess extends RotinaHasTreinoState {
  final String message;

  const RotinaHasTreinoSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado de falha
class RotinaHasTreinoFailure extends RotinaHasTreinoState {
  final String error;

  const RotinaHasTreinoFailure(this.error);

  @override
  List<Object?> get props => [error];
}


class RotinaHasTreinoLoaded extends RotinaHasTreinoState {
  final List<dynamic> rotinasHasTreinos;

  RotinaHasTreinoLoaded(this.rotinasHasTreinos);
}
