import 'package:flutter_bloc/flutter_bloc.dart';

class CadastroState {
  final String? nome;
  final String? email;
  final String? password;
  final String? dataNascimento;
  final String? whatsapp;
  final String? cpf;
  final String? sobrenome;
  final String? genero;
  final String? objetivo;
  final String? nivelAtividade;
  final String? rua;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? cep;

  CadastroState({
    this.nome = '',
    this.email = '',
    this.password = '',
    this.dataNascimento = '',
    this.whatsapp = '',
    this.cpf = '',
    this.sobrenome = '',
    this.genero = '',
    this.objetivo = '',
    this.nivelAtividade = '',
    this.rua = '',
    this.numero = '',
    this.complemento = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.cep = '',
  });

  CadastroState copyWith({
    String? nome,
    String? sobrenome,
    String? email,
    String? dataNascimento,
    String? whatsapp,
    String? password,
    String? cpf,
    String? genero,
    String? objetivo,
    String? nivelAtividade,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado,
    String? cep,
  }) {
    return CadastroState(
      nome: nome ?? this.nome,
      sobrenome: sobrenome ?? this.sobrenome,
      email: email ?? this.email,
      password: password ?? this.password,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      whatsapp: whatsapp ?? this.whatsapp,
      cpf: cpf ?? this.cpf,
      genero: genero ?? this.genero,
      objetivo: objetivo ?? this.objetivo,
      nivelAtividade: nivelAtividade ?? this.nivelAtividade,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
    );
  }
}

class CadastroCubit extends Cubit<CadastroState> {
  CadastroCubit() : super(CadastroState());

  void updateNome(String nome) => emit(state.copyWith(nome: nome));
  void updateSobrenome(String sobrenome) => emit(state.copyWith(sobrenome: sobrenome));
  void updateEmail(String email) => emit(state.copyWith(email: email));
  void updateDataNascimento(String dataNascimento) => emit(state.copyWith(dataNascimento: dataNascimento));
  void updateWhatsApp(String whatsapp) => emit(state.copyWith(whatsapp: whatsapp));
  void updatePassword(String password) => emit(state.copyWith(password: password));
  void updateCpf(String cpf) => emit(state.copyWith(cpf: cpf));
  void updateGenero(String genero) => emit(state.copyWith(genero: genero));
  void updateObjetivo(String objetivo) => emit(state.copyWith(objetivo: objetivo));
  void updateNivelAtividade(String nivelAtividade) => emit(state.copyWith(nivelAtividade: nivelAtividade));
  void updateRua(String rua) => emit(state.copyWith(rua: rua));
  void updateNumero(String numero) => emit(state.copyWith(numero: numero));
  void updateComplemento(String complemento) => emit(state.copyWith(complemento: complemento));
  void updateBairro(String bairro) => emit(state.copyWith(bairro: bairro));
  void updateCidade(String cidade) => emit(state.copyWith(cidade: cidade));
  void updateEstado(String estado) => emit(state.copyWith(estado: estado));
  void updateCep(String cep) => emit(state.copyWith(cep: cep));


  void updateSobre(String value) {}

  void updateConfef(String value) {}

  void updateEspecialidadeDoPersonal(String value) {}
}
