import 'package:flutter_bloc/flutter_bloc.dart';

class CadastroStateProfi {
  final String nome;
  final String email;
  final String password;
  final String cpf;
  final String genero;
  final String sobre;
  final String confef;
  final String cref;
  final String especialidadeDoPersonal;

  CadastroStateProfi({
    this.nome = '',
    this.email = '',
    this.password = '',
    this.cpf = '',
    this.genero = '',
    this.sobre = '',
    this.confef = '',
    this.cref = '',
    this.especialidadeDoPersonal  = '',
  });
  
  CadastroStateProfi copyWith({
    String? nome,
    String? email,
    String? password,
    String? cpf,
    String? genero,
    String? sobre,
    String? confef,
    String? cref,
    String? especialidadeDoPersonal
  }){
    return CadastroStateProfi(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      password: password ?? this.password,
      cpf: cpf ?? this.cpf,
      genero: genero ?? this.genero,
      sobre: sobre ?? this.sobre,
      confef: confef ?? this.confef,
      cref: cref ?? this.cref,
      especialidadeDoPersonal: especialidadeDoPersonal ?? this.especialidadeDoPersonal,
    );
  }
}

class CadastroCubit extends Cubit<CadastroStateProfi> {
  CadastroCubit() : super(CadastroStateProfi());

  void updateNome(String nome) => emit(state.copyWith(nome: nome));
  void updateEmail(String email) => emit(state.copyWith(email: email));
  void updatePassword(String password) => emit(state.copyWith(password: password));
  void updateCpf(String cpf) => emit(state.copyWith(cpf: cpf));
  void updateGenero(String genero) => emit(state.copyWith(genero: genero));
  void updateSobre(String sobre) => emit(state.copyWith(sobre: sobre));
  void updateConfef(String confef) => emit(state.copyWith(confef: confef));
  void updateCref(String cref) => emit(state.copyWith(cref: cref));
  void updateEspecialidadeDoPersonal(String especialidadeDoPersonal) => emit(state.copyWith(especialidadeDoPersonal: especialidadeDoPersonal));
}
