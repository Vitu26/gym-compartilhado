import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/exercicios/exercicios_event.dart';
import 'package:sprylife/bloc/exercicios/exercicios_state.dart';
import 'package:sprylife/bloc/exercicios/exericios_bloc.dart';
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exercicio_bloc.dart';
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exericio_event.dart';

class ExerciseSelectionPage extends StatefulWidget {
  final int treinoId;
  final int groupId;

  ExerciseSelectionPage({required this.treinoId, required this.groupId});

  @override
  _ExerciseSelectionPageState createState() => _ExerciseSelectionPageState();
}

class _ExerciseSelectionPageState extends State<ExerciseSelectionPage> {
  // Lista local para armazenar os exercícios já adicionados
  Set<int> _exerciciosAdicionados = {};

  @override
  void initState() {
    super.initState();
    // Dispara o evento para buscar os exercícios da categoria
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Disparando evento GetAllExerciciosByCategory para categoria: ${widget.groupId}');
      context.read<ExercicioBloc>().add(GetAllExerciciosByCategory(categoryId: widget.groupId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Exercícios'),
      ),
      body: BlocBuilder<ExercicioBloc, ExercicioState>(
        builder: (context, state) {
          print('Estado atual: $state'); // Log do estado atual

          if (state is ExercicioLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ExercicioLoaded) {
            final exercicios = state.exercicios;
            if (exercicios.isEmpty) {
              return Center(child: Text('Nenhum exercício encontrado.'));
            }

            return ListView.builder(
              itemCount: exercicios.length,
              itemBuilder: (context, index) {
                final exercise = exercicios[index];
                final isAdded = _exerciciosAdicionados.contains(exercise['id']);

                return ListTile(
                  title: Text(exercise['nome'] ?? 'Nome indisponível'),
                  trailing: ElevatedButton(
                    onPressed: isAdded
                        ? null
                        : () {
                            setState(() {
                              _exerciciosAdicionados.add(exercise['id']);
                            });

                            // Aqui adicionamos o exercício ao treino utilizando o novo BLoC
                            context.read<ExercicioTreinoBloc>().add(AddExercicioToTreino(
                                  treinoId: widget.treinoId,
                                  exercicioId: exercise['id'],
                                ));

                            print('Adicionando exercício ID: ${exercise['id']} ao treino: ${widget.treinoId}');
                          },
                    child: Text(isAdded ? 'Adicionado' : 'Adicionar'),
                  ),
                );
              },
            );
          } else if (state is ExercicioFailure) {
            return Center(child: Text('Erro ao carregar exercícios: ${state.error}'));
          }
          return Center(child: Text('Carregando exercícios...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(); // Retorna para a página anterior
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
