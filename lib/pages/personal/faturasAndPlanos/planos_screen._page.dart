import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/bloc/planos/planos_state.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'criar_plano.dart';

class PlanosScreen extends StatelessWidget {
  final String personalId;

  PlanosScreen({required this.personalId});

  @override
  Widget build(BuildContext context) {
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
        final String assinaturaRecorrente =
            plano['assinatura-recorrente'] ?? '0';
        final String periodicidade = plano['periodicidade'] ?? 'Desconhecida';
        final String descricaoPlano =
            plano['descricao-do-plano'] ?? 'Sem descrição';
        final String valorPlano =
            plano['valor-do-plano'] ?? 'Valor não disponível';

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
                      builder: (context) =>
                          CriarPlanoScreen(personalId: personalId),
                    ),
                  );
                } else if (result == 'excluir') {
                  _showDeleteConfirmationDialog(context, plano['id']);
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

class CriarPlanoScreen extends StatelessWidget {
  final String personalId;

  CriarPlanoScreen({required this.personalId});

  final TextEditingController nomePlanoController = TextEditingController();
  final TextEditingController valorPlanoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  String? periodicidade = 'mensal';
  bool assinaturaRecorrente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar novo plano'),
        backgroundColor: personalColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nomePlanoController,
                decoration: InputDecoration(
                  labelText: 'Nome do plano:',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: assinaturaRecorrente ? 'Sim' : 'Não',
                onChanged: (String? newValue) {
                  assinaturaRecorrente = newValue == 'Sim';
                },
                decoration: InputDecoration(
                  labelText: 'Assinatura recorrente?',
                  border: OutlineInputBorder(),
                ),
                items: ['Sim', 'Não']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: periodicidade,
                onChanged: (String? newValue) {
                  periodicidade = newValue!;
                },
                decoration: InputDecoration(
                  labelText: 'Periodicidade',
                  border: OutlineInputBorder(),
                ),
                items: <String>['mensal', 'semestral', 'trimestral', 'anual']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: valorPlanoController,
                decoration: InputDecoration(
                  labelText: 'Valor do plano:',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição do plano:',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (personalId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'O ID do personal está faltando. Não é possível criar um plano.')),
                      );
                      return;
                    }

                    if (nomePlanoController.text.isNotEmpty &&
                        valorPlanoController.text.isNotEmpty) {
                      final planoData = {
                        'nome-do-plano': nomePlanoController.text,
                        'periodicidade': periodicidade!,
                        'valor-do-plano': valorPlanoController.text,
                        'descricao-do-plano':
                            descricaoController.text.isNotEmpty
                                ? descricaoController.text
                                : 'Sem descrição',
                        'assinatura-recorrente':
                            assinaturaRecorrente ? '1' : '0',
                        'personal_id': personalId,
                      };

                      context.read<PlanoBloc>().add(CreatePlano(planoData));
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Por favor, preencha todos os campos obrigatórios')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: personalColor,
                  ),
                  child: Text('Salvar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
