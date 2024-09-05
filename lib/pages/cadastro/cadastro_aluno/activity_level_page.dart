import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/models/cadastro_aluno_model.dart';
import 'package:sprylife/widgets/gradiente_button.dart';
import 'package:sprylife/widgets/progress_widget.dart';


class ActivityLevelSelectionPage extends StatefulWidget {
  @override
  _ActivityLevelSelectionPageState createState() => _ActivityLevelSelectionPageState();
}

class _ActivityLevelSelectionPageState extends State<ActivityLevelSelectionPage> {
  String? selectedActivityLevel;

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
        title: ProgressBar(currentStep: 3, totalSteps: 3),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Qual o seu nível de atividade física?",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Isso nos ajuda a criar seu plano personalizado.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ActivityLevelOption(
                    label: "Iniciante",
                    isSelected: selectedActivityLevel == 'Iniciante',
                    onTap: () {
                      setState(() {
                        selectedActivityLevel = 'Iniciante';
                      });
                      BlocProvider.of<CadastroCubit>(context).updateNivelAtividade('Iniciante');
                    },
                  ),
                  ActivityLevelOption(
                    label: "Intermediário",
                    isSelected: selectedActivityLevel == 'Intermediário',
                    onTap: () {
                      setState(() {
                        selectedActivityLevel = 'Intermediário';
                      });
                      BlocProvider.of<CadastroCubit>(context).updateNivelAtividade('Intermediário');
                    },
                  ),
                  ActivityLevelOption(
                    label: "Avançado",
                    isSelected: selectedActivityLevel == 'Avançado',
                    onTap: () {
                      setState(() {
                        selectedActivityLevel = 'Avançado';
                      });
                      BlocProvider.of<CadastroCubit>(context).updateNivelAtividade('Avançado');
                    },
                  ),
                  ActivityLevelOption(
                    label: "Altamente treinado",
                    isSelected: selectedActivityLevel == 'Altamente treinado',
                    onTap: () {
                      setState(() {
                        selectedActivityLevel = 'Altamente treinado';
                      });
                      BlocProvider.of<CadastroCubit>(context).updateNivelAtividade('Altamente treinado');
                    },
                  ),
                  ActivityLevelOption(
                    label: "Atleta",
                    isSelected: selectedActivityLevel == 'Atleta',
                    onTap: () {
                      setState(() {
                        selectedActivityLevel = 'Atleta';
                      });
                      BlocProvider.of<CadastroCubit>(context).updateNivelAtividade('Atleta');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: "Próximo",
              onPressed: selectedActivityLevel != null
                  ? () {
                      // Ação do botão próximo
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

class ActivityLevelOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ActivityLevelOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Color(0xFFFF5F22) : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Color(0xFFFF5F22) : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.black : Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
