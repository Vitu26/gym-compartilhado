import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_event.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_state.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/criar_treino_screen.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/treinos_detalhe_page.dart';
import 'package:sprylife/utils/colors.dart';

class RotinaTreinoDetalhes extends StatefulWidget {
  final int rotinaId;

  RotinaTreinoDetalhes({required this.rotinaId});

  @override
  State<RotinaTreinoDetalhes> createState() => _RotinaTreinoDetalhesState();
}

class _RotinaTreinoDetalhesState extends State<RotinaTreinoDetalhes> {
  @override
  void initState() {
    super.initState();
    // Disparar o evento para buscar os treinos ao iniciar o estado
    context
        .read<RotinaHasTreinoBloc>()
        .add(GetAllRotinasHasTreinos(rotinaId: widget.rotinaId.toString()));

    print("Fetching treinos for Rotina ID: ${widget.rotinaId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganho de Força'), // Pode ser o nome da rotina também
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<RotinaHasTreinoBloc, RotinaHasTreinoState>(
        listener: (context, state) {
          if (state is RotinaHasTreinoFailure) {
            print("Error loading treinos: ${state.error}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao carregar treinos: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<RotinaHasTreinoBloc, RotinaHasTreinoState>(
          builder: (context, state) {
            if (state is RotinaHasTreinoLoading) {
              print("Loading treinos...");
              return Center(child: CircularProgressIndicator());
            } else if (state is RotinaHasTreinoLoaded) {
              print("Treinos loaded: ${state.rotinasHasTreinos}");
              final treinos = state.rotinasHasTreinos;

              if (treinos.isNotEmpty) {
                // Se houver treinos, exibe a lista
                return _buildTreinoList(treinos);
              } else {
                // Exibe uma mensagem de que não há treinos
                return _buildEmptyTreino();
              }
            } else if (state is RotinaHasTreinoFailure) {
              return Center(child: Text('Erro: ${state.error}'));
            }
            return Center(child: Text('Carregue os treinos'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegação manual para a tela de CriarTreinoRotina ao clicar no botão
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CriarTreinoRotina(rotinaId: widget.rotinaId),
            ),
          );
        },
        backgroundColor: personalColor,
        child: Icon(Icons.add),
      ),
    );
  }

  // Exibe a tela quando não houver treinos
  Widget _buildEmptyTreino() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A rotina de treinos está vazia. Pressione o botão para adicionar um treino.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navegar para a tela de adicionar treino ao clicar no botão
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CriarTreinoRotina(rotinaId: widget.rotinaId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: personalColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Adicionar treino',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Exibe a lista de treinos associados à rotina
  Widget _buildTreinoList(List<dynamic> treinos) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: treinos.length,
      itemBuilder: (context, index) {
        final treino = treinos[index]['treino'];
        return ListTile(
          leading: Icon(Icons.fitness_center, size: 40),
          title: Text(treino['nome']),
          subtitle: Text(treino['observacoes'] ?? ''),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TreinoDetalhesPage(treinoId: treino['id']),
              ),
            );
          },
        );
      },
    );
  }
}
