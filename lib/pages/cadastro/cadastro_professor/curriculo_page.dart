import 'package:flutter/material.dart';
import 'package:sprylife/components/button.dart';
import 'package:sprylife/widgets/progress_widget.dart';

class CurriculumPage extends StatefulWidget {
  const CurriculumPage({super.key});

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  final TextEditingController especController = TextEditingController();
  final TextEditingController qualiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Button(
          text: 'Próximo',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Atendimento()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const ProgressBar(currentStep: 3, totalSteps: 4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Preencha seu Currículo',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Preencha os campos de forma clara e detalhada, destacando suas qualificações e experiências. Forneça o máximo de '
              'informações relevantes para atrair o interesse dos alunos, incentivando-os a entrar em contato com você através da plataforma.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 38),
            TextField(
              controller: especController,
              decoration: InputDecoration(
                hintText: 'Qual sua principal especialização?',
                hintStyle: TextStyle(color: Colors.grey[600]),
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: qualiController,
              minLines: 15,
              maxLines: 45,
              decoration: InputDecoration(
                hintText: 'Detalhe todas as suas qualificações.',
                hintStyle: TextStyle(color: Colors.grey[600]),
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
