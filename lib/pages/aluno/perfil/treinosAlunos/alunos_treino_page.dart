import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_bloc.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_event.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_state.dart';
import 'package:sprylife/widgets/custom_appbar.dart';

class AlunoTreinosPage extends StatelessWidget {
  final String alunoId;

  AlunoTreinosPage({required this.alunoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Meus Treino',
      ),
      body: BlocProvider(
        create: (context) => AlunoHasRotinaBloc()
          ..add(FetchAlunoHasRotina(int.parse(alunoId))),
        child: BlocBuilder<AlunoHasRotinaBloc, AlunoHasRotinaState>(
          builder: (context, state) {
            if (state is AlunoHasRotinaLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AlunoHasRotinaLoaded) {
              final rotinas = state.rotinas;
              if (rotinas.isEmpty) {
                return Center(child: Column(
                  children: [
                    Text('Nenhuma rotina de treino cadastrada.'),
                    Text('Fale com seu personal'),
                  ],
                ));
              }
              return ListView.builder(
                itemCount: rotinas.length,
                itemBuilder: (context, index) {
                  final rotina = rotinas[index];
                  return ListTile(
                    title: Text('Rotina ${rotina['rotina-de-treino_id']}'),
                    subtitle: Text('Aluno ID: ${rotina['aluno_id']}'),
                    onTap: () {
                      // Ação quando o usuário clica
                    },
                  );
                },
              );
            } else if (state is AlunoHasRotinaFailure) {
              return Center(child: Text('Erro: ${state.error}'));
            } else {
              return Center(child: Text('Nenhum treino encontrado.'));
            }
          },
        ),
      ),
    );
  }
}
