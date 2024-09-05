import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/models/cadastro_aluno_model.dart';

class CurriculoProfissionalScreen extends StatefulWidget {
  @override
  _CurriculoProfissionalScreenState createState() => _CurriculoProfissionalScreenState();
}

class _CurriculoProfissionalScreenState extends State<CurriculoProfissionalScreen> {
  final TextEditingController especialidadeController = TextEditingController();

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
              'Preencha seu Currículo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Descreva suas qualificações para que possamos criar seu perfil completo.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: especialidadeController,
              decoration: InputDecoration(
                labelText: 'Qual é sua principal especialidade?',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<CadastroCubit>().updateEspecialidadeDoPersonal(value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Lógica para a próxima ação, por exemplo, salvar o currículo e navegar para outra tela
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Próximo', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
