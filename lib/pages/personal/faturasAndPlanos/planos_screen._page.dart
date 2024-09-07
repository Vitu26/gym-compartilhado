import 'package:flutter/material.dart';
import 'package:sprylife/pages/personal/faturasAndPlanos/criar_plano.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/bloc/planos/planos_state.dart';

class PlanosScreen extends StatelessWidget {
  final String personalId;

  PlanosScreen({required this.personalId}) {
    // Verifica se o personalId não está vazio ao instanciar a tela
    assert(personalId.isNotEmpty, 'O personalId não pode ser nulo ou vazio');
    print('Personal ID fornecido: $personalId'); // Debug
  }

  @override
  Widget build(BuildContext context) {
    print('Construindo PlanosScreen com personalId: $personalId'); // Debug

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Planos',
      ),
      body: BlocProvider(
        create: (context) => PlanoBloc()..add(GetAllPlanos(personalId)),
        child: BlocBuilder<PlanoBloc, PlanoState>(
          builder: (context, state) {
            if (state is PlanoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PlanoLoaded) {
              return _buildPlanosList(context, state.planos);
            } else if (state is PlanoFailure) {
              return Center(child: Text('Falha ao carregar os planos.'));
            }
            return Container();
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (personalId.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CriarPlanoScreen(personalId: personalId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'O ID do personal está faltando. Não é possível criar um plano.')),
              );
            }
          },
          child: Text('Novo Plano'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: personalColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanosList(BuildContext context, List<dynamic> planos) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: planos.length,
      itemBuilder: (context, index) {
        final plano = planos[index];

        final String nomePlano =
            plano['nome-do-plano'] ?? 'Nome não disponível';
        final String assinaturaRecorrente = plano['assinatura-recorrente']
            .toString(); // Convertendo int para String
        final String periodicidade = plano['periodicidade'] ?? 'Desconhecida';
        final String descricaoPlano =
            plano['descricao-do-plano'] ?? 'Sem descrição';
        final String valorPlano =
            plano['valor-do-plano'].toString(); // Convertendo int para String

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(nomePlano),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Pagamento: ${assinaturaRecorrente == '1' ? 'Recorrente' : 'Manual'}'),
                Text('Fatura a cada: ${_getPeriodicidadeText(periodicidade)}'),
                Text(descricaoPlano),
                Text('Valor de cada fatura: $valorPlano'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'editar') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CriarPlanoScreen(
                          personalId: plano['personal_id']
                              .toString()), // Convertendo int para String
                    ),
                  );
                } else if (result == 'excluir') {
                  _showDeleteConfirmationDialog(context,
                      plano['id'].toString()); // Convertendo int para String
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'editar',
                  child: Text('Editar'),
                ),
                const PopupMenuItem<String>(
                  value: 'excluir',
                  child: Text('Excluir'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getPeriodicidadeText(String periodicidade) {
    switch (periodicidade) {
      case 'mensal':
        return '1 mês';
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
