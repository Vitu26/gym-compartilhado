import 'package:equatable/equatable.dart';

abstract class AlunoEvent extends Equatable {
  const AlunoEvent();

  @override
  List<Object> get props => [];
}

class AlunoLogin extends AlunoEvent {
  final String email;
  final String password;

  const AlunoLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AlunoCadastro extends AlunoEvent {
  final Map<String, dynamic> alunoData;

  const AlunoCadastro(this.alunoData);

  @override
  List<Object> get props => [alunoData];
}

class GetAllAlunos extends AlunoEvent {
  final String? searchQuery;

  const GetAllAlunos({this.searchQuery});

  @override
  List<Object> get props => [searchQuery ?? ''];
}


class GetAluno extends AlunoEvent {
  final String id;

  const GetAluno(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateAluno extends AlunoEvent {
  final String id;
  final Map<String, dynamic> alunoData;

  const UpdateAluno(this.id, this.alunoData);

  @override
  List<Object> get props => [id, alunoData];
}

class DeleteAluno extends AlunoEvent {
  final String id;

  const DeleteAluno(this.id);

  @override
  List<Object> get props => [id];
}



class FetchObjetivos extends AlunoEvent {}
class FetchModalidades extends AlunoEvent {}
class FetchNiveisAtividade extends AlunoEvent {}

class FetchAllData extends AlunoEvent {}
