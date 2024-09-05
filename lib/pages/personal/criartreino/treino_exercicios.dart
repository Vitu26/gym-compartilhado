import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/treino/treino_bloc.dart';
import 'package:sprylife/bloc/treino/treino_event.dart';
import 'package:sprylife/bloc/treino/treino_state.dart';
import 'package:sprylife/pages/personal/criartreino/exercicios.dart';
import 'package:sprylife/utils/colors.dart';

class TreinoExerciciosScreen extends StatelessWidget {
  final String treinoId;

  TreinoExerciciosScreen({required this.treinoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios do Treino'),
        backgroundColor: personalColor,
      ),
      body: BlocProvider(
        create: (context) => TreinoBloc()..add(GetTreino(treinoId)),
        child: BlocBuilder<TreinoBloc, TreinoState>(
          builder: (context, state) {
            if (state is TreinoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TreinoDetailLoaded) {
              final exercicios = state.treino['exercicios'];
              return ListView.builder(
                itemCount: exercicios.length,
                itemBuilder: (context, index) {
                  final exercicio = exercicios[index];
                  return ListTile(
                    title: Text(exercicio['nome']),
                  );
                },
              );
            } else if (state is TreinoFailure) {
              return Center(child: Text('Falha ao carregar os exercícios'));
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CriarExercicioScreen(treinoId: treinoId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: personalColor,
      ),
    );
  }
}
