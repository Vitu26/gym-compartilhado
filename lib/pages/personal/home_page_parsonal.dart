import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/pages/personal/aluno_treino_screen.dart';
import 'package:sprylife/pages/personal/alunoperfil/aluno_perfil_personal.dart';
import 'package:sprylife/pages/personal/cadastro_aluno_personal.dart';
import 'package:sprylife/pages/personal/chatpage/chat_screen_personal.dart';
import 'package:sprylife/pages/personal/faturasAndPlanos/faturas_srcreen.dart';
import 'package:sprylife/pages/personal/notificações/notificacoes.dart';
import 'package:sprylife/pages/personal/pesquisarAluno/pesquisa_aluno_page.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/calendario.dart';

class HomePersonalScreen extends StatefulWidget {
  final Map<String, dynamic> personalData;
  final List<Map<String, dynamic>> notifications;
  final Map<String, dynamic>? alunoData;

  HomePersonalScreen({
    required this.personalData,
    this.notifications = const [],
    this.alunoData,
  });

  @override
  _HomePersonalScreenState createState() => _HomePersonalScreenState();
}

class _HomePersonalScreenState extends State<HomePersonalScreen> {
  @override
  void initState() {
    super.initState();
    // Dispara o evento de carregar alunos se ainda não houver dados carregados
    final alunoBloc = context.read<AlunoBloc>();
    if (alunoBloc.state is! AlunoSuccess) {
      alunoBloc.add(GetAllAlunos());
    }
  }

  @override
  Widget build(BuildContext context) {
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

  // Construir saudação na tela, incluindo o nome do personal
  Widget _buildGreeting(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              '${widget.personalData['nome']}', // Nome do personal vindo de 'personalData'
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Seu perfil recebeu XX visitas\n nos últimos XX dias',
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
                    notifications: widget.notifications
                        .map((notification) => notification.map(
                            (key, value) => MapEntry(key, value.toString())))
                        .toList(),
                  ),
                ));
              },
              icon: const Icon(Icons.notifications),
            ),
            if (widget.notifications
                .where((notification) => notification['status'] == 'new')
                .isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    widget.notifications
                        .where((notification) => notification['status'] == 'new')
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

  // Construir botões de ações rápidas
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
            if (widget.alunoData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlunoFaturaScreen(
                    alunoData: widget.alunoData!,
                    personalData: widget.personalData, // Passe personalData aqui
                  ),
                ),
              );
            }
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
                  alunoData: widget.personalData, // Passa os dados do personal
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

  // Função para criar botões de ação
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

  // Seção para os botões relacionados ao aluno
  Widget _buildStudentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CadastroAlunoPersonalScreen(),
              ),
            );
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
              MaterialPageRoute(
                builder: (context) => PesquisaAlunoPage(),
              ),
            );
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
        BlocBuilder<AlunoBloc, AlunoState>(
          builder: (context, state) {
            if (state is AlunoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AlunoFailure) {
              return Center(
                  child: Text('Erro ao carregar alunos: ${state.error}'));
            } else if (state is AlunoSuccess) {
              final students = state.data;

              if (students.isEmpty) {
                return Center(child: Text('Nenhum aluno encontrado.'));
              }

              // Certifique-se de retornar uma lista de widgets com `.toList()`
              return Column(
                children: students.take(4).map<Widget>((student) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(student['foto']),
                      radius: 25,
                    ),
                    title: Text(student['nome']),
                    subtitle: Text(student['informacoes_comuns']?['objetivo'] ??
                        'Objetivo não disponível'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showStudentDialog(context, student);
                    },
                  );
                }).toList(), // Aqui está a correção com toList()
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }

  // Diálogo de opções para cada aluno
  void _showStudentDialog(BuildContext context, Map<String, dynamic> student) {
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreenPersonal(
                              senderId: widget.personalData['id']
                                  .toString(), // ID do personal
                              receiverId:
                                  student['id'].toString(), // ID do aluno
                              personalData: widget.personalData,
                              receiverName: student['nome'],
                            ),
                          ),
                        );
                      },
                      child: _buildDialogButton(Icons.message, 'Chat'),
                    ),
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
                          return AlunoPerfilScreen(
                            alunoData: student,
                            personalData:
                                widget.personalData, // Passe o personalData aqui
                          );
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
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

  // Botão dentro do diálogo do aluno
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
