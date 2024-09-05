import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/categoriaExercicio/categoria_exercicio_event.dart';
import 'package:sprylife/bloc/categoriaExercicio/categoria_exercicio_state.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/exercicio_selection_page.dart';
import '../../../../bloc/categoriaExercicio/categoria_exercicio_bloc.dart';

class GroupSelectionPage extends StatelessWidget {
  final int treinoId;

  GroupSelectionPage({required this.treinoId});

  @override
  Widget build(BuildContext context) {
    // Carrega todas as categorias ao montar a página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriaExercicioBloc>().add(GetAllCategoriasExercicio());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Grupo Muscular'),
      ),
      body: BlocBuilder<CategoriaExercicioBloc, CategoriaExercicioState>(
        builder: (context, state) {
          if (state is CategoriaExercicioLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoriaExercicioLoaded) {
            final categories = state.categorias;

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category['nome']),
                  onTap: () {
                    // Navegar para a página de seleção de exercícios, passando treinoId e groupId (categoria)
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ExerciseSelectionPage(
                        treinoId: treinoId,
                        groupId: category['id'],
                      ),
                    ));
                  },
                );
              },
            );
          } else if (state is CategoriaExercicioFailure) {
            return Center(child: Text('Erro ao carregar grupos musculares: ${state.error}'));
          }
          return Center(child: Text('Carregando grupos musculares...'));
        },
      ),
    );
  }
}
