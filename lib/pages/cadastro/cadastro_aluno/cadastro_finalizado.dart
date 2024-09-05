import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/models/cadastro_aluno_model.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';

class FinalizarCadastroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finalizar Cadastro'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final cadastroState = BlocProvider.of<CadastroCubit>(context).state;
            Map<String, dynamic> alunoData = {
              'nome': cadastroState.nome,
              'email': cadastroState.email,
              'password': cadastroState.password,
              'cpf': cadastroState.cpf,
              'genero': cadastroState.genero,
              'objetivo': cadastroState.objetivo,
              'nivelAtividade': cadastroState.nivelAtividade,
              // Adicione outros campos conforme necessário
            };
            BlocProvider.of<AlunoBloc>(context).add(AlunoCadastro(alunoData));
          },
          child: Text('Finalizar Cadastro'),
        ),
      ),
    );
  }
}
