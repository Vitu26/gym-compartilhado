import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprylife/bloc/faturas/fatruas_event.dart';
import 'package:sprylife/bloc/faturas/faturas_bloc.dart';
import 'package:sprylife/utils/colors.dart';

class CriarFaturaScreen extends StatefulWidget {
  final String alunoId;

  CriarFaturaScreen({required this.alunoId});

  @override
  State<CriarFaturaScreen> createState() => _CriarFaturaScreenState();
}

class _CriarFaturaScreenState extends State<CriarFaturaScreen> {
  final TextEditingController valorController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  DateTime? dataVencimento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Fatura'),
        backgroundColor: personalColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: valorController,
              decoration: InputDecoration(labelText: 'Valor da Fatura'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    dataVencimento = picked;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: dataVencimento != null
                        ? 'Data: ${DateFormat('dd/MM/yyyy').format(dataVencimento!)}'
                        : 'Data de Vencimento',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (valorController.text.isNotEmpty && dataVencimento != null) {
                  final descricao = descricaoController.text.isNotEmpty
                      ? descricaoController.text
                      : 'Sem descrição'; 

                  final faturaData = {
                    'plano_id': '1', // ID do plano ou escolha correta
                    'aluno_id': widget.alunoId,
                    'data_fatura': DateFormat('yyyy-MM-dd').format(dataVencimento!),
                    'fatura_paga': '0', // ou 1 se for paga
                    'descricao': descricao,
                  };

                  print('Criando fatura com os dados: $faturaData');
                  
                  context.read<FaturaBloc>().add(CreateFatura(faturaData));
                  
                  // Log de sucesso na criação
                  print('Fatura enviada para criação com sucesso.');
                  
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Por favor, preencha todos os campos obrigatórios')),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
