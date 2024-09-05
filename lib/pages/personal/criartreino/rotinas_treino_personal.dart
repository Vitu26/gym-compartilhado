import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_event.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_state.dart';
import 'package:sprylife/pages/personal/criartreino/criar_treino.dart';
import 'package:sprylife/pages/personal/criartreino/rotinas_treino_treino_personal.dart';
import 'package:sprylife/utils/colors.dart';

class RotinasScreen extends StatelessWidget {
  final String personalId;
  final Function(String)
      onRotinaSelected; // Callback to pass the selected routine ID

  RotinasScreen({required this.personalId, required this.onRotinaSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Rotinas'),
        backgroundColor: personalColor,
      ),
      body: BlocProvider(
        create: (context) => RotinaDeTreinoBloc()
          ..add(GetAllRotinasDeTreino()), // Fetch all routines
        child: BlocBuilder<RotinaDeTreinoBloc, RotinaDeTreinoState>(
          builder: (context, state) {
            if (state is RotinaDeTreinoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RotinaDeTreinoLoaded) {
              final rotinas =
                  state.rotinas; // Correctly access the loaded routines
              return ListView.builder(
                itemCount: rotinas.length,
                itemBuilder: (context, index) {
                  final rotina = rotinas[index];
                  return ListTile(
                    title: Text(rotina['nome']),
                    subtitle: Text(
                        'Data Início: ${rotina['data-inicio']}, Data Fim: ${rotina['data-fim']}'),
                    onTap: () {
                      // Pass the selected rotinaDeTreinoId to the callback
                      onRotinaSelected(rotina['id'].toString());
                      Navigator.of(context)
                          .pop(); // Close the routine selection screen
                    },
                  );
                },
              );
            } else if (state is RotinaDeTreinoFailure) {
              return Center(child: Text('Falha ao carregar as rotinas'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
