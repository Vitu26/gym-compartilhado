import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/turmas/tumas_bloc.dart';
import 'package:sprylife/bloc/turmas/turma_event.dart';
import 'package:sprylife/models/model_tudo.dart';

class EditTurmaPage extends StatefulWidget {
  final Turma turma;

  EditTurmaPage({required this.turma});

  @override
  _EditTurmaPageState createState() => _EditTurmaPageState();
}

class _EditTurmaPageState extends State<EditTurmaPage> {
  late Personal selectedPersonal;
  late List<Aluno> selectedAlunos;

  @override
  void initState() {
    super.initState();
    selectedPersonal = widget.turma.personal;
    selectedAlunos = List.from(widget.turma.alunos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Turma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecione um Personal', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            DropdownButton<Personal>(
              isExpanded: true,
              value: selectedPersonal,
              hint: Text('Escolha um personal'),
              items: _getPersonalDropdownItems(),
              onChanged: (value) {
                setState(() {
                  selectedPersonal = value!;
                });
              },
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
                        ;
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
                  if (selectedPersonal != null && selectedAlunos.isNotEmpty) {
                    Turma updatedTurma = Turma(
                      id: widget.turma.id,
                      personal: selectedPersonal,
                      alunos: selectedAlunos,
                    );

                    // Despachar evento para atualizar a turma
                    BlocProvider.of<TurmaBloc>(context)
                        .add(UpdateTurma(turma: updatedTurma));
                    Navigator.of(context).pop();
                  } else {
                    // Mostrar mensagem de erro
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Por favor, selecione um personal e pelo menos um aluno.')),
                    );
                  }
                },
                child: Text('Salvar Alterações'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Personal>> _getPersonalDropdownItems() {
    List<Personal> personals = [
      Personal(
        id: 1, // ID do Personal A
        nome: 'Personal A',
        email: 'a@example.com',
        cpf: '123',
        foto:
            '', // Se não tiver uma foto, pode deixar como string vazia ou null
        sobre: 'Descrição do Personal A', // Insira a descrição apropriada
        confef: '123',
        cref: '123',
        especialidade: 'Musculação',
        address:
            null, // Caso não tenha endereço, você pode deixar como null ou fornecer um objeto Address
      ),
      Personal(
        id: 2, // ID do Personal B
        nome: 'Personal B',
        email: 'b@example.com',
        cpf: '456',
        foto: '',
        sobre: 'Descrição do Personal B',
        confef: '456',
        cref: '456',
        especialidade: 'Musculação',
        address: null,
      ),
    ];

    return personals.map((personal) {
      return DropdownMenuItem<Personal>(
        value: personal,
        child: Text(personal.nome),
      );
    }).toList();
  }

  List<Aluno> _getAlunos() {
    return [
      Aluno(
          nome: 'Aluno 1',
          email: 'aluno1@example.com',
          cpf: '111',
          foto: '',
          sexo: 'masculino',
          dataDeNascimento: DateTime.now(),
          objetivoId: 1,
          nivelAtividadeId: 1,
          modalidadeAlunoId: 1,
          telefone: '123456789'),
      Aluno(
          nome: 'Aluno 2',
          email: 'aluno2@example.com',
          cpf: '222',
          foto: '',
          sexo: 'feminino',
          dataDeNascimento: DateTime.now(),
          objetivoId: 1,
          nivelAtividadeId: 1,
          modalidadeAlunoId: 1,
          telefone: '987654321'),
    ];
  }
}
