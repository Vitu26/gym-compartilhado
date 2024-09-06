import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_button.dart';

class CriarPlanoScreenPersonal extends StatelessWidget {
  final String personalId;
  final TextEditingController nomePlanoController = TextEditingController();
  final TextEditingController precoPlanoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  String periodicidade = 'mensal';
  bool assinaturaRecorrente = false;

  CriarPlanoScreenPersonal({required this.personalId});

  @override
  Widget build(BuildContext context) {
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
              CustomButton(text: 'Salvar', backgroundColor: personalColor, onPressed: () {
                    if (nomePlanoController.text.isNotEmpty &&
                        precoPlanoController.text.isNotEmpty) {
                      final planoData = {
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

                      context.read<PlanoBloc>().add(CreatePlano(planoData));
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Por favor, preencha todos os campos obrigatórios')),
                      );
                    }
                  },)
            ],
          ),
        ),
      ),
    );
  }
}
