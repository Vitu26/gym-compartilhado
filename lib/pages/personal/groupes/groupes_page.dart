import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/turmas/tumas_bloc.dart';
import 'package:sprylife/bloc/turmas/turma_event.dart';
import 'package:sprylife/bloc/turmas/turma_state.dart';
import 'package:sprylife/models/model_tudo.dart';
import 'package:sprylife/pages/personal/groupes/add_turma_page.dart';
import 'package:sprylife/pages/personal/groupes/turma_details.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';
import 'package:sprylife/widgets/custom_button.dart';

class TurmaListPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Personal personal;

  TurmaListPage({required this.navigatorKey, required this.personal});

  @override
  _TurmaListPageState createState() => _TurmaListPageState();
}

class _TurmaListPageState extends State<TurmaListPage> {
  @override
  void initState() {
    super.initState();
    // Dispara o evento para carregar as turmas
    BlocProvider.of<TurmaBloc>(context).add(LoadTurmas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(title: 'Gerenciar grupos'),
      body: Column(
        children: [
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 1,
          ),
          Expanded(
            child: BlocBuilder<TurmaBloc, TurmaState>(
              builder: (context, state) {
                if (state is TurmaLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TurmaLoaded) {
                  if (state.turmas.isEmpty) {
                    // Mostra uma mensagem se não houver turmas cadastradas
                    return Center(
                      child: Text(
                        'Nenhuma turma cadastrada.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.turmas.length,
                    itemBuilder: (context, index) {
                      final turma = state.turmas[index];
                      return ListTile(
                        title: Text(turma.personal.nome),
                        subtitle: Text('${turma.alunos.length} alunos'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TurmaDetailPage(turma: turma),
                          ));
                        },
                      );
                    },
                  );
                } else if (state is TurmaFailure) {
                  return Center(
                      child: Text('Erro ao carregar turmas: ${state.error}'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddTurmaPage(personal: widget.personal)),
            );
          },
          child: const Text(
            'Cadastrar novo grupo',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: personalColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
