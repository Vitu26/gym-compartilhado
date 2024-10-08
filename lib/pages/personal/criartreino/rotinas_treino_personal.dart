import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_event.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_state.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_event.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_state.dart';
import 'package:sprylife/pages/personal/criartreino/criar_treino.dart';
import 'package:sprylife/pages/personal/criartreino/detalhes_rotina_de_treino.dart';
import 'package:sprylife/pages/personal/criartreino/rotinas_treino_treino_personal.dart';
import 'package:sprylife/utils/colors.dart';

class RotinasScreen extends StatelessWidget {
  final String personalId;
  final Function(String) onRotinaSelected;
  final Map<String, dynamic> alunoData;

  RotinasScreen({
    required this.personalId,
    required this.onRotinaSelected,
    required this.alunoData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Rotinas'),
        backgroundColor: personalColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _navigateToCriarTreino(context);
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => RotinaDeTreinoBloc()..add(GetAllRotinasDeTreino()),
        child: BlocBuilder<RotinaDeTreinoBloc, RotinaDeTreinoState>(
          builder: (context, state) {
            if (state is RotinaDeTreinoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RotinaDeTreinoLoaded) {
              final rotinas = state.rotinas;
              return ListView.builder(
                itemCount: rotinas.length,
                itemBuilder: (context, index) {
                  final rotina = rotinas[index];
                  return ListTile(
                    title: Text(rotina['nome'] ?? 'Nome Indisponível'),
                    subtitle: Text(
                        'Data Início: ${rotina['data-inicio']}, Data Fim: ${rotina['data-fim']}'),
                    onTap: () {
                      _checkIfRotinaHasTreinos(context, rotina['id'].toString());
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

  // Verifica se a rotina possui treinos
  void _checkIfRotinaHasTreinos(BuildContext context, String rotinaId) {
    final rotinaHasTreinoBloc = context.read<RotinaHasTreinoBloc>();

    // Dispara o evento para buscar os treinos da rotina
    rotinaHasTreinoBloc.add(GetAllRotinasHasTreinos(rotinaId: rotinaId));

    // Escuta o estado do BLoC e navega com base no estado
    rotinaHasTreinoBloc.stream.listen((state) {
      if (state is RotinaHasTreinoLoaded) {
        if (state.rotinasHasTreinos.isNotEmpty) {
          // Se houver treinos, navega para a tela de Treinos
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  RotinaTreinosScreen(rotinaId: int.parse(rotinaId)),
            ),
          );
        } else {
          // Se não houver treinos, navega para adicionar treinos
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RotinaTreinoDetalhes(
                rotinaId: int.parse(rotinaId),
              ),
            ),
          );
        }
      } else if (state is RotinaHasTreinoFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao verificar os treinos: ${state.error}')),
        );
      }
    });
  }

  // Navega para a tela de criação de treino
  void _navigateToCriarTreino(BuildContext context) {
    final alunoId = alunoData['id'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarTreinoPersonal(
          personalsId: personalId,
          alunoId: alunoId.toString(),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_bloc.dart';
// import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_event.dart';
// import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_state.dart';
// import 'package:sprylife/pages/personal/criartreino/criar_treino.dart';
// import 'package:sprylife/pages/personal/criartreino/rotinas_treino_treino_personal.dart';

// class RotinasScreen extends StatefulWidget {
//   final String personalId;
//   final Function(String) onRotinaSelected;
//   final Map<String, dynamic> alunoData;

//   RotinasScreen({
//     required this.personalId,
//     required this.onRotinaSelected,
//     required this.alunoData,
//   });

//   @override
//   State<RotinasScreen> createState() => _RotinasScreenState();
// }

// class _RotinasScreenState extends State<RotinasScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Acessa o rotinaId a partir de alunoData corretamente.
//     final String rotinaId = widget.alunoData['rotinaId'].toString();
//     BlocProvider.of<RotinaHasTreinoBloc>(context)
//         .add(GetAllRotinasHasTreinos(rotinaId: rotinaId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rotinas de Treino'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add), // Ícone de adicionar rotina
//             onPressed: () {
//               _navigateToCriarTreino(context);
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<RotinaHasTreinoBloc, RotinaHasTreinoState>(
//         builder: (context, state) {
//           if (state is RotinaHasTreinoLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is RotinaHasTreinoLoaded) {
//             if (state.rotinasHasTreinos.isNotEmpty) {
//               return ListView.builder(
//                 itemCount: state.rotinasHasTreinos.length,
//                 itemBuilder: (context, index) {
//                   final rotina = state.rotinasHasTreinos[index];
//                   return ListTile(
//                     title: Text('Rotina ${rotina['nome']}'),
//                     onTap: () {
//                       if (mounted) {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => RotinaTreinosScreen(
//                               rotinaId: int.parse(rotina['rotina_id']),
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                   );
//                 },
//               );
//             } else {
//               return Center(
//                 child: Text('Nenhuma rotina de treino encontrada.'),
//               );
//             }
//           } else if (state is RotinaHasTreinoFailure) {
//             return Center(
//               child: Text('Erro ao carregar as rotinas: ${state.error}'),
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }

//   // Função para navegar para a tela de criação de treino
//   void _navigateToCriarTreino(BuildContext context) {
//     final alunoId = widget.alunoData['id'];
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CriarTreinoPersonal(
//           personalsId: widget.personalId,
//           alunoId: alunoId.toString(),
//         ),
//       ),
//     );
//   }
// }
