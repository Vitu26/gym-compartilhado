import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_event.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_state.dart';
import 'package:sprylife/pages/personal/criartreino/detalhes_rotina_de_treino.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/criar_treino_screen.dart';
import 'package:sprylife/utils/colors.dart';

class RotinaTreinosScreen extends StatefulWidget {
  final int rotinaId;

  RotinaTreinosScreen({required this.rotinaId});

  @override
  _RotinaTreinosScreenState createState() => _RotinaTreinosScreenState();
}

class _RotinaTreinosScreenState extends State<RotinaTreinosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinos da Rotina'),
        backgroundColor: personalColor,
      ),
      body: BlocProvider(
        create: (context) =>
            RotinaHasTreinoBloc()..add(GetAllRotinasHasTreinos(rotinaId: widget.rotinaId.toString())),
        child: BlocBuilder<RotinaHasTreinoBloc, RotinaHasTreinoState>(
          builder: (context, state) {
            if (state is RotinaHasTreinoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RotinaHasTreinoLoaded) {
              final treinos = state.rotinasHasTreinos;

              // Handle if no treinos are returned
              if (treinos == null || treinos.isEmpty) {
                return Center(child: Text('Nenhum treino associado'));
              }

              return ListView.builder(
                itemCount: treinos.length,
                itemBuilder: (context, index) {
                  final treino = treinos[index]['treino'];
                  return ListTile(
                    title: Text(treino['nome'] ?? 'Nome não disponível'),
                    subtitle: Text(treino['observacoes'] ?? 'Sem observações'),
                    onTap: () {
                      if (mounted) { // Check if the widget is still active
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RotinaTreinoDetalhes(rotinaId: widget.rotinaId),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            } else if (state is RotinaHasTreinoFailure) {
              return Center(child: Text('Erro ao carregar os treinos: ${state.error}'));
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) { // Check if the widget is still in the tree before navigating
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CriarTreinoRotina(rotinaId: widget.rotinaId),
              ),
            );
          }
        },
        child: Icon(Icons.add),
        backgroundColor: personalColor,
      ),
    );
  }
}
