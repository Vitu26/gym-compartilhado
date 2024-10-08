import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/utils/colors.dart';

class EditarPlanoScreen extends StatelessWidget {
  final String personalId;
  final Map<String, dynamic> planoData;
  final TextEditingController nomePlanoController;
  final TextEditingController precoPlanoController;
  final TextEditingController descricaoController;
  String periodicidade;
  bool assinaturaRecorrente;

  EditarPlanoScreen({
    required this.personalId,
    required this.planoData,
  })  : nomePlanoController = TextEditingController(text: planoData['nome-do-plano']),
        precoPlanoController =
            TextEditingController(text: planoData['valor-do-plano'].toString()),
        descricaoController =
            TextEditingController(text: planoData['descricao-do-plano']),
        periodicidade = planoData['periodicidade'] ?? 'mensal',
        assinaturaRecorrente = planoData['assinatura-recorrente'] == '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar plano'),
        backgroundColor: personalColor,
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
                  labelText: 'Nome do plano',
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
                controller: precoPlanoController,
                decoration: InputDecoration(
                  labelText: 'Valor do plano',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição do plano',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (nomePlanoController.text.isNotEmpty &&
                        precoPlanoController.text.isNotEmpty) {
                      final updatedPlanoData = {
                        'nome-do-plano': nomePlanoController.text,
                        'periodicidade': periodicidade,
                        'valor-do-plano': precoPlanoController.text,
                        'descricao-do-plano':
                            descricaoController.text.isNotEmpty
                                ? descricaoController.text
                                : 'Sem descrição',
                        'assinatura-recorrente':
                            assinaturaRecorrente ? '1' : '0',
                        'personal_id': personalId,
                      };

                      context.read<PlanoBloc>().add(UpdatePlano(
                            planoData['id'], // Passando o ID do plano
                            updatedPlanoData, // Passando os dados atualizados do plano
                          ));
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
                  child:
                      Text('Salvar alterações', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
