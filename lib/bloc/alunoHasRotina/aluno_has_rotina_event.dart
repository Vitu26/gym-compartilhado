import 'package:equatable/equatable.dart';

abstract class AlunoHasRotinaEvent extends Equatable {
  const AlunoHasRotinaEvent();

  @override
  List<Object> get props => [];
}

class CreateAlunoHasRotina extends AlunoHasRotinaEvent {
  final Map<String, dynamic> associacaoData;

  const CreateAlunoHasRotina(this.associacaoData);

  @override
  List<Object> get props => [associacaoData]; // Corrigido para List<Object>
}


class FetchAlunoHasRotina extends AlunoHasRotinaEvent {
  final int alunoId;

  const FetchAlunoHasRotina(this.alunoId);

  @override
  List<Object> get props => [alunoId];
}

