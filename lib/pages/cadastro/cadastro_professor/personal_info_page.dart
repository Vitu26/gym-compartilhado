import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/models/cadastro_aluno_model.dart';
import 'package:sprylife/widgets/bottom_navigation.dart';

class PersonalPPage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;

  PersonalPPage({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  _PersonalPPageState createState() => _PersonalPPageState();
}

class _PersonalPPageState extends State<PersonalPPage> {
  final TextEditingController cpfController = TextEditingController(); // Novo campo para CPF
  final TextEditingController sobreController = TextEditingController();
  final TextEditingController confefController = TextEditingController();
  final TextEditingController crefController = TextEditingController();
  final TextEditingController especialidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:BlocListener<PersonalBloc, PersonalState>(
        listener: (context, state) {
          if (state is PersonalSuccess) {
            // Navegar para NavBarPersonal se o cadastro for bem-sucedido
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavBarPersonal(personalData: state.data),
              ),
            );
          } else if (state is PersonalFailure) {
            // Mostrar mensagem de erro
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child:SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: cpfController,
              decoration: InputDecoration(
                labelText: 'CPF',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: sobreController,
              decoration: InputDecoration(
                labelText: 'Sobre',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confefController,
              decoration: InputDecoration(
                labelText: 'CONFEP',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: crefController,
              decoration: InputDecoration(
                labelText: 'CREF',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: especialidadeController,
              decoration: InputDecoration(
                labelText: 'Especialidade',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: estadoController,
              decoration: InputDecoration(
                labelText: 'Estado',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cidadeController,
              decoration: InputDecoration(
                labelText: 'Cidade',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bairroController,
              decoration: InputDecoration(
                labelText: 'Bairro',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ruaController,
              decoration: InputDecoration(
                labelText: 'Rua',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: complementoController,
              decoration: InputDecoration(
                labelText: 'Complemento',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numeroController,
              decoration: InputDecoration(
                labelText: 'Número',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _cadastrarPersonal(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Cadastrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    ));
  }

  void _cadastrarPersonal(BuildContext context) {
    
    final cadastroState = context.read<CadastroCubit>().state;

    
    final Map<String, dynamic> personalData = {
      'nome': widget.name,
      'email': widget.email,
      'password': widget.password,
      'cpf': cpfController.text,  
      'sobre': sobreController.text,
      'endereco': {
        'estado': estadoController.text,
        'cidade': cidadeController.text,
        'bairro': bairroController.text,
        'rua': ruaController.text,
        'complemento': complementoController.text,
        'numero': numeroController.text,
      },
      'confef': confefController.text,
      'cref': crefController.text,
      'especialidade-do-personal': especialidadeController.text,
    };

    
    print('Dados do personal sendo enviados: ${jsonEncode(personalData)}');

    
    context.read<PersonalBloc>().add(PersonalCadastro(personalData));
  }
}
