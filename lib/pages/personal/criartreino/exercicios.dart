import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/exercicios/exercicios_event.dart';
import 'package:sprylife/bloc/exercicios/exericios_bloc.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/textfield.dart';

class CriarExercicioScreen extends StatefulWidget {
  final String treinoId;

  CriarExercicioScreen({required this.treinoId});

  @override
  _CriarExercicioScreenState createState() => _CriarExercicioScreenState();
}

class _CriarExercicioScreenState extends State<CriarExercicioScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _iconTipController = TextEditingController();
  final TextEditingController _iconExercicioController =
      TextEditingController();
  final TextEditingController _enderecoVideoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Exercício'),
        backgroundColor: personalColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldLC(
              controller: _nomeController,
              obscureText: false,
              maxLines: 1,
            ),
            SizedBox(height: 16),
            TextFieldLC(
              controller: _iconTipController,
              obscureText: false,
              maxLines: 1,
            ),
            SizedBox(height: 16),
            TextFieldLC(
              controller: _iconExercicioController,
              obscureText: false,
              maxLines: 1,
            ),
            SizedBox(height: 16),
            TextFieldLC(
              controller: _enderecoVideoController,
              obscureText: false,
              maxLines: 1,
            ),
            SizedBox(height: 30),
            CustomButton(
              text: 'Salvar',
              backgroundColor: personalColor,
              onPressed: () {
                final exercicioData = {
                  'nome': _nomeController.text,
                  'icon-tip': _iconTipController.text,
                  'icon-exercicio': _iconExercicioController.text,
                  'endereco-video': _enderecoVideoController.text,
                  'categoria-treinos_id': '1',
                };

                context.read<ExercicioBloc>().add(CreateExercicio(exercicioData));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
