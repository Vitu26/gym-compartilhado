import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/utils/colors.dart';

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
                items: ['Sim', 'Não'].map<DropdownMenuItem<String>>((String value) {
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
                    if (nomePlanoController.text.isNotEmpty &&
                        valorPlanoController.text.isNotEmpty) {
                      final planoData = {
                        'nome-do-plano': nomePlanoController.text,
                        'periodicidade': periodicidade!,
                        'valor-do-plano': valorPlanoController.text, // Enviar valor como string simples
                        'descricao-do-plano': descricaoController.text.isNotEmpty
                            ? descricaoController.text
                            : 'Sem descrição',
                        'assinatura-recorrente': assinaturaRecorrente ? '0' : '1',
                        'personal_id': personalId, // Certificar-se de que o ID é passado corretamente
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
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
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
