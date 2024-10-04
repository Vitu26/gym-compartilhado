import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';

class LocaisAtendimentoScreen extends StatefulWidget {
  final String email;
  final String phone;
  final String password;
  final String selectedGender;
  final List<String> selectedModalities;
  final String name;
  final String cpf;
  final String cref;
  final String redesSociais;
  final String especializacao;
  final String qualificacoes;
  final File? imageFile;

  const LocaisAtendimentoScreen({
    super.key,
    required this.email,
    required this.phone,
    required this.password,
    required this.selectedGender,
    required this.selectedModalities,
    required this.name,
    required this.cpf,
    required this.cref,
    required this.redesSociais,
    required this.especializacao,
    required this.qualificacoes,
    this.imageFile,
  });

  @override
  _LocaisAtendimentoScreenState createState() => _LocaisAtendimentoScreenState();
}

class _LocaisAtendimentoScreenState extends State<LocaisAtendimentoScreen> {
  bool atendimentoOnline = false;
  bool atendimentoPresencial = false;
  bool aulaExperimental = false;
  bool isPresencialSelected = false;

  final TextEditingController bairroController = TextEditingController();
  final TextEditingController academiaController = TextEditingController();
  final TextEditingController novaAcademiaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Locais de Atendimento',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text("Atendimento Online"),
              value: atendimentoOnline,
              onChanged: (newValue) {
                setState(() {
                  atendimentoOnline = newValue!;
                });
              },
              activeColor: Colors.blue.shade800,
            ),
            CheckboxListTile(
              title: const Text("Atendimento Presencial"),
              value: atendimentoPresencial,
              onChanged: (newValue) {
                setState(() {
                  atendimentoPresencial = newValue!;
                  isPresencialSelected = newValue!;
                });
              },
              activeColor: Colors.blue.shade800,
            ),
            CheckboxListTile(
              title: const Text("Aula experimental gratuita"),
              value: aulaExperimental,
              onChanged: (newValue) {
                setState(() {
                  aulaExperimental = newValue!;
                });
              },
              activeColor: Colors.blue.shade800,
            ),
            const SizedBox(height: 16),
            if (isPresencialSelected) ...[
              // Campo de pesquisa por bairro
              TextField(
                controller: bairroController,
                decoration: InputDecoration(
                  labelText: 'Pesquise seu bairro',
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Campo de pesquisa por academia
              TextField(
                controller: academiaController,
                decoration: InputDecoration(
                  labelText: 'Pesquise sua academia',
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Opção para adicionar nova academia
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Inserir academia'),
                        content: TextField(
                          controller: novaAcademiaController,
                          decoration: const InputDecoration(
                            labelText: 'Nome da academia',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Lógica para adicionar nova academia
                              Navigator.of(context).pop();
                            },
                            child: const Text('Salvar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Inserir nova academia',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _cadastrarPersonal(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _cadastrarPersonal(BuildContext context) {
    final Map<String, dynamic> personalData = {
      'nome': widget.name,
      'email': widget.email,
      'password': widget.password,
      'cpf': widget.cpf,
      'sobre': widget.qualificacoes,
      'endereco': {
        'estado': 'Preencha', // Adicionar valores reais conforme necessidade
        'cidade': 'Preencha',
        'bairro': bairroController.text,
        'rua': 'Preencha',
        'complemento': 'Preencha',
        'numero': 'Preencha',
      },
      'confef': 'Preencha', // Pode ser ajustado conforme a necessidade
      'cref': widget.cref,
      'especialidade-do-personal': widget.especializacao,
      'atendimento_online': atendimentoOnline ? '1' : '0',
      'atendimento_presencial': atendimentoPresencial ? '1' : '0',
      'aula_experimental': aulaExperimental ? '1' : '0',
    };

    print('Dados do personal sendo enviados: $personalData');

    context.read<PersonalBloc>().add(PersonalCadastro(personalData));
  }
}
