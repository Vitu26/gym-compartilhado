import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/turmas/tumas_bloc.dart';
import 'package:sprylife/bloc/turmas/turma_event.dart';
import 'package:sprylife/models/model_tudo.dart';

class AddTurmaPage extends StatefulWidget {
  final Personal personal; // Receber o personal logado

  AddTurmaPage({required this.personal});

  @override
  _AddTurmaPageState createState() => _AddTurmaPageState();
}

class _AddTurmaPageState extends State<AddTurmaPage> {
  List<Aluno> selectedAlunos = [];
  TextEditingController turmaNameController = TextEditingController(); // Controlador para o nome da turma

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Turma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo para inserir o nome da turma
            Text('Nome da Turma', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              controller: turmaNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite o nome da turma',
              ),
            ),
            SizedBox(height: 20),
            Text('Selecione os Alunos', style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: _getAlunos().length,
                itemBuilder: (context, index) {
                  Aluno aluno = _getAlunos()[index];
                  return CheckboxListTile(
                    title: Text(aluno.nome),
                    value: selectedAlunos.contains(aluno),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedAlunos.add(aluno);
                        } else {
                          selectedAlunos.remove(aluno);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (turmaNameController.text.isNotEmpty && selectedAlunos.isNotEmpty) {
                    Turma newTurma = Turma(
                      id: 0, // ID será gerado automaticamente pela API
                      // nome: turmaNameController.text,
                      personal: widget.personal,
                      alunos: selectedAlunos,
                    );

                    // Despachar evento para adicionar a turma
                    BlocProvider.of<TurmaBloc>(context).add(AddTurma(turma: newTurma));
                    Navigator.of(context).pop();
                  } else {
                    // Mostrar mensagem de erro
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor, insira o nome da turma e selecione pelo menos um aluno.')),
                    );
                  }
                },
                child: Text('Salvar Turma'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Exemplo de como obter uma lista de Alunos - em um caso real, você pode obtê-los de uma API
  List<Aluno> _getAlunos() {
    // Substituir esta função pelo carregamento real dos alunos do personal
    return [
      Aluno(nome: 'Aluno 1', email: 'aluno1@example.com', cpf: '111', foto: '', sexo: 'masculino', dataDeNascimento: DateTime.now(), objetivoId: 1, nivelAtividadeId: 1, modalidadeAlunoId: 1, telefone: '123456789'),
      Aluno(nome: 'Aluno 2', email: 'aluno2@example.com', cpf: '222', foto: '', sexo: 'feminino', dataDeNascimento: DateTime.now(), objetivoId: 1, nivelAtividadeId: 1, modalidadeAlunoId: 1, telefone: '987654321'),
    ];
  }
}
