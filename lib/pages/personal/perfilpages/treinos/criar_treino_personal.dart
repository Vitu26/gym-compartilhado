import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_event.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_button.dart';

class CriarRotinaDeTreinoScreen extends StatelessWidget {
  final String personalId;
  final Map<String, dynamic>? rotinaData;

  final TextEditingController observacoesController;
  String tipoTreino;
  int objetivoId;
  int nivelAtividadeId;
  bool baixarTreino;
  DateTime dataInicio;
  DateTime dataFim;

  CriarRotinaDeTreinoScreen({
    required this.personalId,
    this.rotinaData,
  })  : observacoesController = TextEditingController(text: rotinaData?['observacoes'] ?? ''),
        tipoTreino = rotinaData?['tipo-treino_id']?.toString() ?? '1',
        objetivoId = rotinaData?['objetivo_id'] ?? 1,
        nivelAtividadeId = rotinaData?['nivel-atividade_id'] ?? 1,
        baixarTreino = rotinaData?['baixar-treino'] == '1',
        dataInicio = rotinaData?['data-inicio'] != null
            ? DateTime.parse(rotinaData!['data-inicio'])
            : DateTime.now(),
        dataFim = rotinaData?['data-fim'] != null
            ? DateTime.parse(rotinaData!['data-fim'])
            : DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isEditing = rotinaData != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Editar Rotina de Treino' : 'Criar Rotina de Treino',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: observacoesController,
                decoration: InputDecoration(
                  labelText: 'Observações:',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: tipoTreino,
                onChanged: (String? newValue) {
                  tipoTreino = newValue!;
                },
                decoration: InputDecoration(
                  labelText: 'Tipo de Treino',
                  border: OutlineInputBorder(),
                ),
                items: <String>['1', '2']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value == '1' ? 'Semanal' : 'Numérico'),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: objetivoId,
                onChanged: (int? newValue) {
                  objetivoId = newValue!;
                },
                decoration: InputDecoration(
                  labelText: 'Objetivo',
                  border: OutlineInputBorder(),
                ),
                items: <int>[1, 2, 3, 4, 5, 6]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(_getObjetivoLabel(value)),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: nivelAtividadeId,
                onChanged: (int? newValue) {
                  nivelAtividadeId = newValue!;
                },
                decoration: InputDecoration(
                  labelText: 'Nível de Atividade',
                  border: OutlineInputBorder(),
                ),
                items: <int>[1, 2, 3, 4, 5]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(_getNivelAtividadeLabel(value)),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text('Permitir que o aluno baixe o treino em PDF?'),
                value: baixarTreino,
                onChanged: (bool value) {
                  baixarTreino = value;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Início',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: _formatDate(dataInicio)),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: dataInicio,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          dataInicio = picked;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Fim',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: _formatDate(dataFim)),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: dataFim,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          dataFim = picked;
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomButton(text: 'Salvar', backgroundColor: personalColor, onPressed: () {
                    if (_validateForm()) {
                      final rotinaData = {
                        'tipo-treino_id': int.parse(tipoTreino),
                        'data-inicio': _formatDate(dataInicio, apiFormat: true),
                        'data-fim': _formatDate(dataFim, apiFormat: true),
                        'objetivo_id': objetivoId,
                        'personal_id': int.parse(personalId),
                        'nivel-atividade_id': nivelAtividadeId,
                        'observacoes': observacoesController.text.isNotEmpty
                            ? observacoesController.text
                            : 'Sem observações',
                        'baixar-treino': baixarTreino ? 1 : 2,
                      };

                      if (isEditing) {
                        context.read<RotinaDeTreinoBloc>().add(UpdateRotinaDeTreino(
                              this.rotinaData!['id'], 
                              rotinaData,
                            ));
                      } else {
                        context.read<RotinaDeTreinoBloc>().add(CreateRotinaDeTreino(rotinaData));
                      }
                      Navigator.of(context).pop(true);
                    } 
                    // else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('Por favor, preencha todos os campos obrigatórios'),
                    //     ),
                    //   );
                    // }
                  },)
            ],
          ),
        ),
      ),
    );
  }

  String _getObjetivoLabel(int id) {
    switch (id) {
      case 1:
        return 'Redução gordura/aumento massa muscular';
      case 2:
        return 'Condicionamento físico ou performance';
      case 3:
        return 'Aumento da massa muscular';
      case 4:
        return 'Redução de gordura';
      case 5:
        return 'Qualidade de vida & saúde';
      case 6:
        return 'Definição muscular';
      default:
        return 'Objetivo desconhecido';
    }
  }

  String _getNivelAtividadeLabel(int id) {
    switch (id) {
      case 1:
        return 'Iniciante';
      case 2:
        return 'Intermediário';
      case 3:
        return 'Avançado';
      case 4:
        return 'Altamente Treinado';
      case 5:
        return 'Atleta';
      default:
        return 'Nível desconhecido';
    }
  }

  String _formatDate(DateTime date, {bool apiFormat = false}) {
    if (apiFormat) {
      return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  bool _validateForm() {
    return observacoesController.text.isNotEmpty &&
        _formatDate(dataInicio, apiFormat: true).isNotEmpty &&
        _formatDate(dataFim, apiFormat: true).isNotEmpty;
  }
}
