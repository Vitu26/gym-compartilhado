import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_button.dart';

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
    print('Valor do personalId: $personalId');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Criar novo plano',
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
              CustomButton(
                text: 'Salvar',
                backgroundColor: personalColor,
                onPressed: () {
                  if (nomePlanoController.text.isNotEmpty &&
                      valorPlanoController.text.isNotEmpty) {
                    // Verifique se personalId é válido
                    if (personalId.isNotEmpty && personalId != 'null') {
                      final planoData = {
                        'nome-do-plano': nomePlanoController.text,
                        'periodicidade': periodicidade!,
                        'valor-do-plano': valorPlanoController.text,
                        'descricao-do-plano':
                            descricaoController.text.isNotEmpty
                                ? descricaoController.text
                                : 'Sem descrição',
                        'assinatura-recorrente':
                            assinaturaRecorrente ? '0' : '1',
                        'personal_id':
                            personalId, // Certifique-se de que o ID é válido
                      };

                      context.read<PlanoBloc>().add(CreatePlano(planoData));
                      Navigator.of(context).pop();
                    } else {
                      // Caso o personalId esteja nulo ou vazio
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Erro: ID do personal trainer está inválido ou não foi fornecido')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Por favor, preencha todos os campos obrigatórios')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
