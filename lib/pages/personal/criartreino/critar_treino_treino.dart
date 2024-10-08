import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/treino/treino_bloc.dart';
import 'package:sprylife/bloc/treino/treino_event.dart';
import 'package:sprylife/bloc/treino/treino_state.dart';
import 'package:sprylife/utils/colors.dart';

class CriarTreinoRotina extends StatelessWidget {
  final int rotinaId;

  CriarTreinoRotina({required this.rotinaId});

  @override
  Widget build(BuildContext context) {
    final _treinoController = TextEditingController();
    final _nomeController = TextEditingController();
    final _observacoesController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('CRIAR TREINO'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _treinoController,
              decoration: InputDecoration(
                labelText: 'Treino',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _observacoesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Obs/Instruções',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Verifica se os campos não estão vazios
                  if (_treinoController.text.isNotEmpty && _nomeController.text.isNotEmpty) {
                    final treinoData = {
                      'treino': _treinoController.text,
                      'nome': _nomeController.text,
                      'observacoes': _observacoesController.text,
                    };

                    // Dispara o evento para criar o treino e associar à rotina
                    context.read<TreinoBloc>().add(CreateTreino(
                      treinoData: treinoData,
                      rotinaDeTreinoId: rotinaId,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Preencha todos os campos')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: personalColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Salvar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
