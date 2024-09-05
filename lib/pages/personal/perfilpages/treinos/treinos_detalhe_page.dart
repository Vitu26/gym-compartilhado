import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exercicio_bloc.dart';
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exercicio_state.dart';
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exericio_event.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/grupo_selection_page.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_button.dart';

class TreinoDetalhesPage extends StatelessWidget {
  final int treinoId;

  TreinoDetalhesPage({required this.treinoId});

  @override
  Widget build(BuildContext context) {
    // Disparar o evento GetAllTreinosComExercicios assim que a página for carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Disparando evento GetAllTreinosComExercicios para treinoId: $treinoId');
      context.read<ExercicioTreinoBloc>().add(GetAllTreinosComExercicios());
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: "Detalhes do treino",
      ),
      floatingActionButton: FloatingActionButton( onPressed: () {
                      // Navegar para a página de seleção de grupo muscular
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupSelectionPage(treinoId: treinoId),
                      ));
                    },),
      
      body: BlocListener<ExercicioTreinoBloc, ExercicioTreinoState>(
        listener: (context, state) {
          if (state is ExercicioTreinoAdded) {
            print('Exercício adicionado com sucesso!');
          } else if (state is ExercicioTreinoFailure) {
            print('Erro ao carregar exercícios: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao carregar exercícios: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<ExercicioTreinoBloc, ExercicioTreinoState>(
          builder: (context, state) {
            if (state is ExercicioTreinoLoading) {
              print('Estado: Carregando');
              return Center(child: CircularProgressIndicator());
            } else if (state is ExercicioTreinoLoaded) {
              final treinosExercicios = state.treinosExercicios
                  .where((treinoExercicio) => treinoExercicio['treinos_id'] == treinoId)
                  .toList();

              if (treinosExercicios.isEmpty) {
                return Center(
                    child: Text(
                        'Nenhum exercício adicionado a este treino ainda.'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: treinosExercicios.length,
                      itemBuilder: (context, index) {
                        final treinoExercicio = treinosExercicios[index];
                        final exercicio = treinoExercicio['exercicio'];

                        return ListTile(
                          title: Text(exercicio['nome'] ?? 'Exercício sem nome'),
                          subtitle: Text(exercicio['descricao'] ?? ''),
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    text: 'Adicionar exercício',
                    backgroundColor: personalColor,
                    onPressed: () {
                      // Navegar para a página de seleção de grupo muscular
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupSelectionPage(treinoId: treinoId),
                      ));
                    },
                  )
                ],
              );
            } else if (state is ExercicioTreinoFailure) {
              return Center(child: Text('Erro: ${state.error}'));
            }
            return Center(child: Text('Carregando exercícios...'));
          },
        ),
      ),
    );
  }
}
