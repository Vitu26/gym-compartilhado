import 'package:equatable/equatable.dart';

abstract class AlunoHasRotinaEvent extends Equatable {
  const AlunoHasRotinaEvent();

  @override
  List<Object> get props => [];
}

class FetchAlunoHasRotina extends AlunoHasRotinaEvent {
  final int alunoId;

  const FetchAlunoHasRotina(this.alunoId);

  @override
  List<Object> get props => [alunoId];
}
