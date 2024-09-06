import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_event.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_state.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/criar_treino_personal.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/rotina_de_treino_detalhes.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_button.dart';

class MeusTreinosPage extends StatelessWidget {
  final String personalId;

  MeusTreinosPage({required this.personalId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          iconSize: 24,
        ),
        title: const Text(
          'Meus Treinos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => RotinaDeTreinoBloc()..add(GetAllRotinasDeTreino()),
        child: BlocBuilder<RotinaDeTreinoBloc, RotinaDeTreinoState>(
          builder: (context, state) {
            if (state is RotinaDeTreinoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RotinaDeTreinoLoaded) {
              final rotinas = state.rotinas;
              if (rotinas.isEmpty) {
                return Center(
                  child: Text(
                    'Você ainda não adicionou nenhuma rotina de treino.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: rotinas.length,
                itemBuilder: (context, index) {
                  final rotina = rotinas[index];
                  return ListTile(
                    title: Text(rotina['nome'] ?? 'Nome não disponível'),
                    subtitle: Text(
                      'Data Início: ${rotina['data-inicio']}, Data Fim: ${rotina['data-fim']}',
                    ),
                    onTap: () {
                      // Navegar para a tela de detalhes da rotina de treino, passando os parâmetros necessários
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RotinaTreinoDetalhesPage(
                            rotinaId: rotina['id'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is RotinaDeTreinoFailure) {
              return Center(
                child: Text(
                  'Falha ao carregar as rotinas de treino',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          backgroundColor: personalColor,
          text: 'Criar rotina',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CriarRotinaDeTreinoScreen(personalId: personalId),
            ));
          },
        ),
      ),
    );
  }
}
