import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_event.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_state.dart';
import 'package:sprylife/pages/personal/criartreino/treino_exercicios.dart';
import 'package:sprylife/utils/colors.dart';

class RotinaTreinosScreen extends StatelessWidget {
  final String rotinaId;

  RotinaTreinosScreen({required this.rotinaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinos da Rotina'),
        backgroundColor: personalColor,
      ),
      body: BlocProvider(
        create: (context) => RotinaHasTreinoBloc()
          ..add(GetAllRotinasHasTreinos(rotinaId: rotinaId)), // Passando o id correto
        child: BlocBuilder<RotinaHasTreinoBloc, RotinaHasTreinoState>(
          builder: (context, state) {
            if (state is RotinaHasTreinoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RotinaHasTreinoLoaded) {
              final treinos = state.rotinasHasTreinos;
              return ListView.builder(
                itemCount: treinos.length,
                itemBuilder: (context, index) {
                  final treino = treinos[index];
                  return ListTile(
                    title: Text(treino['nome']),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TreinoExerciciosScreen(
                              treinoId: treino['id'])));
                    },
                  );
                },
              );
            } else if (state is RotinaHasTreinoFailure) {
              return Center(child: Text('Falha ao carregar os treinos: ${state.error}'));
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicionar navegação para criar treino
        },
        child: Icon(Icons.add),
        backgroundColor: personalColor,
      ),
    );
  }
}
