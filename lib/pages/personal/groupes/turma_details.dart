import 'package:flutter/material.dart';
import 'package:sprylife/models/model_tudo.dart';


class TurmaDetailPage extends StatelessWidget {
  final Turma turma;

  TurmaDetailPage({required this.turma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Turma'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navegar para a página de edição da turma
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Confirmar exclusão da turma
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal: ${turma.personal.nome}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text('Alunos:', style: TextStyle(fontSize: 18)),
            ...turma.alunos.map((aluno) => ListTile(
              title: Text(aluno.nome),
              subtitle: Text(aluno.email),
            )),
          ],
        ),
      ),
    );
  }
}
