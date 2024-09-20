import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_event.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_state.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/criar_treino_screen.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/treinos_detalhe_page.dart';

class RotinaTreinoDetalhes extends StatelessWidget {
  final int rotinaId; // Correct type is int

  RotinaTreinoDetalhes({required this.rotinaId});

  @override
  Widget build(BuildContext context) {
    print('Página de detalhes da rotina carregada com rotinaId: $rotinaId');

    // Disparar o evento para buscar os treinos ao carregar a página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
          'Disparando evento GetAllRotinasHasTreinos para rotinaId: $rotinaId');
      context
          .read<RotinaHasTreinoBloc>()
          .add(GetAllRotinasHasTreinos(rotinaId: rotinaId.toString()));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Rotina de Treino'),
      ),
      body: BlocBuilder<RotinaHasTreinoBloc, RotinaHasTreinoState>(
        builder: (context, state) {
          print('Estado atual do Bloc: $state');

          if (state is RotinaHasTreinoLoading) {
            print('Estado: Carregando treinos...');
            return Center(child: CircularProgressIndicator());
          } else if (state is RotinaHasTreinoLoaded) {
            final treinos = state.rotinasHasTreinos;
            print('Treinos carregados: $treinos');

            if (treinos.isEmpty) {
              print('Nenhum treino associado encontrado.');
              return Center(child: Text('Nenhum treino associado'));
            }

            return ListView.builder(
              itemCount: treinos.length,
              itemBuilder: (context, index) {
                final treino = treinos[index]['treino'];
                print('Treino exibido: $treino');

                return ListTile(
                  title: Text(treino['nome']),
                  subtitle: Text(treino['observacoes']),
                  onTap: () {
                    // Navegar para a página de detalhes do treino
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            TreinoDetalhesPage(treinoId: treino['id']),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is RotinaHasTreinoFailure) {
            print('Erro ao carregar treinos: ${state.error}');
            return Center(child: Text('Erro: ${state.error}'));
          }

          print('Estado inicial ou desconhecido. Mostrando mensagem padrão.');
          return Center(child: Text('Carregue os treinos'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(
              'Botão de adicionar treino pressionado, abrindo tela de criação.');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CriarTreinoRotina(rotinaId: rotinaId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
