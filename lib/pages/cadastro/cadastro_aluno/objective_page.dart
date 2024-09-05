import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/models/cadastro_aluno_model.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/activity_level_page.dart';
import 'package:sprylife/widgets/gradiente_button.dart';
import 'package:sprylife/widgets/objectiveOption.dart';
import 'package:sprylife/widgets/progress_widget.dart';

class ObjectiveSelectionPage extends StatefulWidget {
  @override
  _ObjectiveSelectionPageState createState() => _ObjectiveSelectionPageState();
}

class _ObjectiveSelectionPageState extends State<ObjectiveSelectionPage> {
  String? selectedObjective;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: ProgressBar(currentStep: 2, totalSteps: 3),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Quais os seus Objetivos?",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Por favor, informe quais os objetivos que busca para ajudarmos a alcançá-los.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ObjectiveOption(
                    label: "Redução de gordura e aumento da massa muscular",
                    isSelected: selectedObjective ==
                        'Redução de gordura e aumento da massa muscular',
                    onTap: () {
                      setState(() {
                        selectedObjective =
                            'Redução de gordura e aumento da massa muscular';
                      });
                      BlocProvider.of<CadastroCubit>(context).updateObjetivo(
                          'Redução de gordura e aumento da massa muscular');
                    },
                  ),
                  ObjectiveOption(
                    label: "Condicionamento físico ou performance",
                    isSelected: selectedObjective ==
                        'Condicionamento físico ou performance',
                    onTap: () {
                      setState(() {
                        selectedObjective =
                            'Condicionamento físico ou performance';
                      });
                      BlocProvider.of<CadastroCubit>(context).updateObjetivo(
                          'Condicionamento físico ou performance');
                    },
                  ),
                  ObjectiveOption(
                    label: "Aumento da massa muscular",
                    isSelected:
                        selectedObjective == 'Aumento da massa muscular',
                    onTap: () {
                      setState(() {
                        selectedObjective = 'Aumento da massa muscular';
                      });
                      BlocProvider.of<CadastroCubit>(context)
                          .updateObjetivo('Aumento da massa muscular');
                    },
                  ),
                  ObjectiveOption(
                    label: "Redução de gordura",
                    isSelected: selectedObjective == 'Redução de gordura',
                    onTap: () {
                      setState(() {
                        selectedObjective = 'Redução de gordura';
                      });
                      BlocProvider.of<CadastroCubit>(context)
                          .updateObjetivo('Redução de gordura');
                    },
                  ),
                  ObjectiveOption(
                    label: "Qualidade de vida & saúde",
                    isSelected:
                        selectedObjective == 'Qualidade de vida & saúde',
                    onTap: () {
                      setState(() {
                        selectedObjective = 'Qualidade de vida & saúde';
                      });
                      BlocProvider.of<CadastroCubit>(context)
                          .updateObjetivo('Qualidade de vida & saúde');
                    },
                  ),
                  ObjectiveOption(
                    label: "Definição muscular",
                    isSelected: selectedObjective == 'Definição muscular',
                    onTap: () {
                      setState(() {
                        selectedObjective = 'Definição muscular';
                      });
                      BlocProvider.of<CadastroCubit>(context)
                          .updateObjetivo('Definição muscular');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: "Próximo",
              onPressed: selectedObjective != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityLevelSelectionPage()),
                      );
                    }
                  : null,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
