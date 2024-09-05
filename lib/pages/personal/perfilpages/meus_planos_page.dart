import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/bloc/planos/planos_state.dart';
import 'package:sprylife/pages/personal/perfilpages/planos/criar_plano_personal.dart';
import 'package:sprylife/pages/personal/perfilpages/planos/editar_plano.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_button.dart';

class MeusPlanosScreen extends StatelessWidget {
  final String personalId;

  const MeusPlanosScreen({super.key, required this.personalId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Meus Planos"),
      body: BlocProvider(
        create: (context) => PlanoBloc()..add(GetAllPlanos(personalId)),
        child: BlocBuilder<PlanoBloc, PlanoState>(
          builder: (context, state) {
            if (state is PlanoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlanoLoaded) {
              final planos = state.planos;
              if (planos.isEmpty) {
                return const Center(child: Text('Nenhum plano criado ainda.'));
              }
              return ListView.builder(
                itemCount: planos.length,
                itemBuilder: (context, index) {
                  final plano = planos[index];
                  return _buildPlanoItem(context, plano);
                },
              );
            } else if (state is PlanoFailure) {
              return Center(
                  child: Text('Falha ao carregar os planos: ${state.error}'));
            } else {
              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
            text: 'Novo Plano',
            backgroundColor: personalColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CriarPlanoScreenPersonal(
                    personalId: personalId,
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildPlanoItem(BuildContext context, Map<String, dynamic> plano) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plano['nome-do-plano'] ?? 'Nome não disponível',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'editar') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditarPlanoScreen(
                            personalId: personalId,
                            planoData: plano,
                          ),
                        ),
                      );
                    } else if (result == 'associar') {
                      // Ação para associar plano a alunos/grupos
                    } else if (result == 'excluir') {
                      _showDeleteConfirmationDialog(context, plano['id']);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'editar',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'associar',
                      child: Text('Associar a Aluno/Grupo'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'excluir',
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Pagamento: ${plano['assinatura-recorrente'] == '1' ? 'Recorrente' : 'Manual'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              'Fatura a cada: ${_getPeriodicidadeText(plano['periodicidade'] ?? 'Desconhecida')}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              plano['descricao-do-plano'] ?? 'Sem descrição',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              'Valor de cada fatura: ${plano['valor-do-plano'] ?? 'R\$ 0,00'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPeriodicidadeText(String periodicidade) {
    switch (periodicidade) {
      case 'mensal':
        return 'X meses';
      case 'semestral':
        return '6 meses';
      case 'trimestral':
        return '3 meses';
      case 'anual':
        return '12 meses';
      default:
        return 'Desconhecido';
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String planoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Plano'),
          content: Text('Tem certeza de que deseja excluir este plano?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<PlanoBloc>().add(DeletePlano(planoId));
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
