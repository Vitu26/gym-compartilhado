import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/utils/colors.dart';

class EditiCurriculoPersonalPage extends StatelessWidget {
  final Map<String, dynamic> personalData;

  EditiCurriculoPersonalPage({required this.personalData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalBloc(),
      child: EditCurriculoView(personalData: personalData),
    );
  }
}

class EditCurriculoView extends StatefulWidget {
  final Map<String, dynamic> personalData;

  EditCurriculoView({required this.personalData});

  @override
  _EditCurriculoViewState createState() => _EditCurriculoViewState();
}

class _EditCurriculoViewState extends State<EditCurriculoView> {
  final TextEditingController _sobreController = TextEditingController();
  final TextEditingController _especialidadeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _sobreController.text = widget.personalData['sobre'] ?? '';
    _especialidadeController.text =
        widget.personalData['especialidade-do-personal'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar currículo'),
        backgroundColor: personalColor,
      ),
      body: BlocListener<PersonalBloc, PersonalState>(
        listener: (context, state) {
          if (state is PersonalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Perfil atualizado com sucesso!')),
            );
            if (mounted) {
              Navigator.of(context).pop(); // Volta para a tela anterior
            }
          } else if (state is PersonalFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Erro ao atualizar perfil: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Especialidade:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _especialidadeController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                const Text('Sobre:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _sobreController,
                  maxLines: 5,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateCurriculo,
                    child: Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: personalColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

void _updateCurriculo() {
  final endereco = widget.personalData['endereco'] ?? {};

  // Conversão do ID para inteiro, caso necessário
  int id = int.tryParse(widget.personalData['id'].toString()) ?? 0;

  // Imprime o valor e o tipo do ID
  print('Valor do id: $id');
  print('Tipo do id: ${id.runtimeType}'); // Verifica o tipo do id

  final updatedData = {
    'id': id,  // Envia o ID como inteiro
    'nome': widget.personalData['nome'], // Campo obrigatório
    'email': widget.personalData['email'], // Campo obrigatório
    'cpf': widget.personalData['cpf'], // Campo obrigatório
    'foto': widget.personalData['foto'], // Opcional
    'sobre': _sobreController.text, // Campo sendo atualizado
    'confef': widget.personalData['confef'] ?? '000000', // Substitua pelo valor padrão se for null
    'cref': widget.personalData['cref'], // Campo obrigatório
    'especialidade-do-personal': _especialidadeController.text, // Campo sendo atualizado
    'tipo_atendimento': widget.personalData['tipo_atendimento'] ?? 'presencial', // Adicione um valor padrão
    'genero': widget.personalData['genero'] ?? '', // Opcional
    'experimental_gratuita': widget.personalData['experimental_gratuita'] ?? '0', // Opcional
    'endereco': {
      'estado': endereco['estado'] ?? 'Estado Padrão', // Adicione valor padrão se estiver vazio
      'cidade': endereco['cidade'] ?? 'Cidade Padrão', // Adicione valor padrão
      'bairro': endereco['bairro'] ?? 'Bairro Padrão', // Adicione valor padrão
      'rua': endereco['rua'] ?? 'Rua Padrão', // Adicione valor padrão
      'numero': endereco['numero'] ?? 'S/N', // Adicione valor padrão
      'complemento': endereco['complemento'] ?? '', // Opcional
    }
  };

  print('Dados enviados para atualização: $updatedData');

  context.read<PersonalBloc>().add(UpdatePersonalProfile(updatedData: updatedData));
}



}
