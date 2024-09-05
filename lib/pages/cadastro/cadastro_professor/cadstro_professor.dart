import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/models/cadastro_aluno_model.dart';

class CadastroProfissionalScreen extends StatefulWidget {
  @override
  _CadastroProfissionalScreenState createState() => _CadastroProfissionalScreenState();
}

class _CadastroProfissionalScreenState extends State<CadastroProfissionalScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController sobreController = TextEditingController();
  final TextEditingController confefController = TextEditingController();
  final TextEditingController crefController = TextEditingController();

  List<String> selectedEspecialidades = [];
  List<String> especialidades = [
    'Todos',
    'Musculação',
    'Funcional',
    'Pilates',
    'Corrida',
    'Luta',
    'Dança',
    'Natação',
  ];

  List<String> selectedGeneros = [];
  List<String> generos = [
    'Todos',
    'Masculino',
    'Feminino',
    'Prefiro não informar',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showEspecialidadesDialog();
    });
  }

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
              'Primeiro nos informe sua formação acadêmica.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<CadastroCubit>().updateEmail(value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                context.read<CadastroCubit>().updatePassword(value);
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showGenerosDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Escolher Gênero', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ação ao clicar no botão "Próximo"
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

  void _showEspecialidadesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecione suas especialidades"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              children: especialidades.map((especialidade) {
                return ChoiceChip(
                  label: Text(especialidade),
                  selected: selectedEspecialidades.contains(especialidade),
                  onSelected: (selected) {
                    setState(() {
                      if (especialidade == 'Todos') {
                        selectedEspecialidades.clear();
                        if (selected) {
                          selectedEspecialidades.add('Todos');
                        }
                      } else {
                        selectedEspecialidades.remove('Todos');
                        if (selected) {
                          selectedEspecialidades.add(especialidade);
                        } else {
                          selectedEspecialidades.remove(especialidade);
                        }
                      }
                      context.read<CadastroCubit>().updateEspecialidadeDoPersonal(selectedEspecialidades.join(', '));
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  void _showGenerosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecione suas preferências de gênero"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              children: generos.map((genero) {
                return ChoiceChip(
                  label: Text(genero),
                  selected: selectedGeneros.contains(genero),
                  onSelected: (selected) {
                    setState(() {
                      if (genero == 'Todos') {
                        selectedGeneros.clear();
                        if (selected) {
                          selectedGeneros.add('Todos');
                        }
                      } else {
                        selectedGeneros.remove('Todos');
                        if (selected) {
                          selectedGeneros.add(genero);
                        } else {
                          selectedGeneros.remove(genero);
                        }
                      }
                      context.read<CadastroCubit>().updateGenero(selectedGeneros.join(', '));
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}
