import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_event.dart';
import 'package:sprylife/bloc/treino/treino_bloc.dart';
import 'package:sprylife/bloc/treino/treino_event.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';

class CriarTreinoRotina extends StatelessWidget {
  final int rotinaId;

  CriarTreinoRotina({required this.rotinaId});

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController obsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Criar Treino',
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: obsController,
                decoration: InputDecoration(
                  labelText: 'Obs/Instruções',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (nomeController.text.isNotEmpty &&
                        obsController.text.isNotEmpty) {
                      final treinoData = {
                        'nome': nomeController.text,
                        'observacoes': obsController.text,
                      };

                      // Pass both treinoData and rotinaId to CreateTreino event
                      context.read<TreinoBloc>().add(CreateTreino(
                          treinoData: treinoData, rotinaDeTreinoId: rotinaId));
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Por favor, preencha todos os campos obrigatórios'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: personalColor,
                  ),
                  child: Text('Salvar', style: TextStyle(fontSize: 16)),
                ),
              )
            ])));
  }
}
