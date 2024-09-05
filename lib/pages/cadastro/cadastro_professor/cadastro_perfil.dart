import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/models/cadastro_aluno_model.dart';
import 'package:sprylife/pages/cadastro/cadastro_professor/curriculo_personal.dart';

class CadastroPerfilProfissionalScreen extends StatefulWidget {
  @override
  _CadastroPerfilProfissionalScreenState createState() => _CadastroPerfilProfissionalScreenState();
}

class _CadastroPerfilProfissionalScreenState extends State<CadastroPerfilProfissionalScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController crefController = TextEditingController();
  final TextEditingController sobreController = TextEditingController();

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
              'Preencha seu Perfil na SpryLife',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Informe os dados abaixo para continuarmos com a criação do seu perfil.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<CadastroCubit>().updateNome(value);
              },
            ),
            const SizedBox(height: 16),
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
              onChanged: (value) {
                context.read<CadastroCubit>().updateCpf(value);
              },
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
              onChanged: (value) {
                context.read<CadastroCubit>().updateCpf(value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: sobreController,
              decoration: InputDecoration(
                labelText: 'Sobre você',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<CadastroCubit>().updateSobre(value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurriculoProfissionalScreen()),
                );
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
