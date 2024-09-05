import 'package:flutter/material.dart';
import 'package:sprylife/pages/personal/aluno_treino_screen.dart';
import 'package:sprylife/pages/personal/alunoperfil/aluno_perfil_personal.dart';
import 'package:sprylife/pages/personal/cadastro_aluno_personal.dart';
import 'package:sprylife/pages/personal/faturasAndPlanos/faturas_srcreen.dart';
import 'package:sprylife/pages/personal/notificações/notificacoes.dart';
import 'package:sprylife/pages/personal/pesquisarAluno/pesquisa_aluno_page.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/calendario.dart';

class HomePersonalScreen extends StatelessWidget {
  final Map<String, dynamic> personalData;
  final List<Map<String, dynamic>> notifications;

  HomePersonalScreen({
    required this.personalData,
    this.notifications = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (personalData == null) {
      return Scaffold(
        body: Center(child: Text('Erro: Dados do personal estão faltando.')),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 65),
            _buildGreeting(context),
            const SizedBox(height: 20),
            CalendarWidget(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
            const SizedBox(height: 20),
            _buildStudentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bom dia,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${personalData['nome']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Seu perfil recebeu XX visitas nos últimos XX dias',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                    notifications: notifications
                        .map((notification) => notification.map(
                            (key, value) => MapEntry(key, value.toString())))
                        .toList(),
                  ),
                ));
              },
              icon: const Icon(Icons.notifications),
            ),
            if (notifications
                .where((notification) => notification['status'] == 'new')
                .isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notifications
                        .where(
                            (notification) => notification['status'] == 'new')
                        .length
                        .toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          'Convites',
          Icons.link,
          () {
            // Lógica para convites
          },
        ),
        _buildActionButton(
          'Planos',
          Icons.loop,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlunoFaturaScreen(
                  alunoData: personalData, // Passe os dados do aluno
                ),
              ),
            );
          },
        ),
        _buildActionButton(
          'Feedback',
          Icons.feedback,
          () {
            // Lógica para feedback
          },
        ),
        _buildActionButton(
          'Treinos',
          Icons.fitness_center,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlunoTreinosScreen(
                  alunoData: personalData, // Passe os dados do aluno
                  treinos: [
                    {'nome': 'Treino A', 'descricao': 'Treino de força'},
                    {'nome': 'Treino B', 'descricao': 'Treino de resistência'},
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: personalColor,
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 28),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildStudentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CadastroAlunoPersonalScreen()));
          },
          child: const Text(
            'Cadastrar novo aluno',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: personalColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PesquisaAlunoPage()));
          },
          child: const Text(
            'Pesquisar aluno',
            style: TextStyle(color: personalColor, fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(
                color: personalColor,
                width: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildStudentList(context),
      ],
    );
  }

  Widget _buildStudentList(BuildContext context) {
    final students = [
      {'name': 'Renato Oliveira', 'goal': 'Aumento de massa muscular'},
      {'name': 'Carlos Costa', 'goal': 'Redução de gordura'},
      {'name': 'Anita Ferreira', 'goal': 'Definição muscular'},
      {'name': 'Rodrigo Costa', 'goal': 'Performance'},
    ];

    return Column(
      children: students.map((student) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
                'images/${student['name']?.replaceAll(' ', '').toLowerCase()}.jpg'),
            radius: 25,
          ),
          title: Text(student['name']!),
          subtitle: Text(student['goal']!),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showStudentDialog(context, student);
          },
        );
      }).toList(),
    );
  }

  void _showStudentDialog(BuildContext context, Map<String, String> student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDialogButton(Icons.fitness_center, 'Treinos'),
                    _buildDialogButton(Icons.loop, 'Planos'),
                    _buildDialogButton(Icons.assessment, 'Avaliações'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDialogButton(Icons.assignment, 'Atividades'),
                    _buildDialogButton(Icons.access_time, 'Histórico'),
                    _buildDialogButton(Icons.message, 'Chat'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AlunoPerfilScreen(alunoData: student);
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Ir para perfil do aluno',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: personalColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: personalColor,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
