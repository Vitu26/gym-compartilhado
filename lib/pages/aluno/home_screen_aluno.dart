// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_bloc.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_event.dart';
import 'package:sprylife/pages/personal/notifica%C3%A7%C3%B5es/notificacoes.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/utils/token_storege.dart';

import 'package:sprylife/widgets/calendario.dart';
import 'package:sprylife/widgets/greetind.dart';

class HomeAlunoScreen extends StatefulWidget {
  final Map<String, dynamic> alunoData;
  final List<Map<String, dynamic>> notifications;

  HomeAlunoScreen({
    Key? key,
    required this.alunoData,
    this.notifications = const [],
  }) : super(key: key);

  @override
  _HomeAlunoScreenState createState() => _HomeAlunoScreenState();
}

class _HomeAlunoScreenState extends State<HomeAlunoScreen> {
  List<dynamic> treinos = [];
  bool _isLoadingTreinos = true;

  @override
  void initState() {
    super.initState();
    _loadAlunoRotinas();
    // _loadTreinos(); // Carregar as rotinas de treino no init
  }

  // Função para carregar as rotinas de treino do aluno
  // Future<void> _loadTreinos() async {
  //   try {
  //     final rotinas = await fetchAlunoHasRotinas(
  //         widget.alunoData['id']); // Chama a função que busca as rotinas
  //     setState(() {
  //       treinos = rotinas; // Armazena as rotinas de treino na variável treinos
  //       _isLoadingTreinos = false; // Atualiza o indicador de carregamento
  //     });
  //   } catch (e) {
  //     print('Erro ao carregar rotinas de treino: $e');
  //     setState(() {
  //       _isLoadingTreinos = false;
  //     });
  //   }
  // }

  void _loadAlunoRotinas() async {
    try {
      // Carrega as rotinas associadas ao aluno
      final rotinas = await fetchRotinasAluno(
          widget.alunoData['id'].toString()); // Converte para String

      setState(() {
        if (rotinas.isNotEmpty) {
          print('Rotinas encontradas: $rotinas');
          // Processa as rotinas, exibe no UI, etc.
        } else {
          print('Nenhuma rotina associada encontrada.');
        }
      });
    } catch (e) {
      print('Erro ao carregar rotinas de treino: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  CustomGreetingWidget(
                    name: '${widget.alunoData['nome']}',
                    profileVisitsText: null,
                    notificationCount: 5,
                    onNotificationTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationScreen(notifications: []),
                        ),
                      );
                    },
                    greetingTextColor: Colors.black,
                    nameTextColor: Colors.black,
                    profileVisitsTextColor: Colors.grey,
                    notificationIconColor: Colors.orange,
                    notificationBadgeColor: Colors.purple,
                    notificationBadgeTextColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  CalendarWidget(
                    defaultDayTextColor: Colors.black,
                    selectedDayBorderColor: alunoCor,
                    selectedDayTextColor: Colors.black,
                    todayBackgroundColor: alunoCor,
                    todayTextColor: Colors.white,
                    weekDayTextColor: Colors.grey,
                  ),
                  const SizedBox(height: 30),
                  _buildMeusTreinosSection(treinos), // Exibir os treinos
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25)
        ],
      ),
    );
  }

  // Widget para exibir a seção "Meus Treinos"
  Widget _buildMeusTreinosSection(List<dynamic> treinos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Meus Treinos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (treinos.isNotEmpty)
              Text(
                "Ver tudo",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        _isLoadingTreinos
            ? Center(child: CircularProgressIndicator())
            : treinos.isEmpty
                ? Text(
                    "Você não tem rotinas de treino cadastradas.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: treinos.length,
                      itemBuilder: (context, index) {
                        final treino =
                            treinos[index]; // Pega o treino de cada índice
                        return _buildTreinoCard(
                          treino['nome'], // Certifique-se de que 'nome' existe
                          treino['instructor'] ?? 'Instrutor desconhecido',
                          treino['foto'] ??
                              'images/default_treino.png', // Certifique-se de que a imagem está correta
                          '5', // Ajuste o campo de avaliação (rating) conforme necessário
                          treino['category'] ?? 'Categoria desconhecida',
                        );
                      },
                    ),
                  ),
      ],
    );
  }

  // Widget para exibir cada card de treino
  Widget _buildTreinoCard(String title, String instructor, String imagePath,
      String rating, String category) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.favorite_border, color: Colors.white),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                color: Colors.black54,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    instructor,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rating,
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        category,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<List<dynamic>> fetchAlunoHasRotinas(int alunoId) async {
  //   final token = await getToken(); // Pega o token de autenticação
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://developerxpb.com.br/api/alunos-has-rotinas/$alunoId'), // Corrigido para utilizar o ID do aluno
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print('Rotinas de treino recebidas: $data');

  //     // Verificar se o campo 'data' é null e retornar uma lista vazia caso seja
  //     if (data['data'] == null) {
  //       print('Nenhuma rotina de treino encontrada.');
  //       return []; // Retorna uma lista vazia
  //     } else {
  //       return data['data']; // Retorna as rotinas se houver dados
  //     }
  //   } else {
  //     print('Erro ao carregar rotinas: ${response.statusCode}');
  //     throw Exception('Erro ao carregar rotinas de treino');
  //   }
  // }

  Future<List<int>> fetchRotinasAluno(String alunoId) async {
    final token = await getToken(); // Pega o token de autenticação

    final response = await http.get(
      Uri.parse('https://developerxpb.com.br/api/alunos-has-rotinas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Verifica se há dados e filtra as rotinas associadas ao aluno
      if (data['data'] != null) {
        // Filtra apenas as rotinas associadas ao aluno com ID especificado
        final rotinasAluno = data['data']
            .where(
                (rotina) => rotina['aluno_id'].toString() == alunoId.toString())
            .toList();

        // Pega os IDs das rotinas filtradas
        final rotinaIds = rotinasAluno
            .map<int>((rotina) => rotina['rotina-de-treino_id'] as int)
            .toList();

        print('Rotinas associadas ao aluno $alunoId: $rotinaIds');
        return rotinaIds;
      } else {
        print('Nenhuma rotina encontrada para o aluno $alunoId');
        return [];
      }
    } else {
      print('Erro ao carregar rotinas: ${response.statusCode}');
      throw Exception('Erro ao carregar rotinas de treino');
    }
  }

  // // *** Aqui está a função para vincular aluno à rotina ***
  // Future<void> vincularAlunoComRotina(int alunoId, int rotinaDeTreinoId) async {
  //   final token = await getToken(); // Pega o token do storage
  //   final response = await http.post(
  //     Uri.parse('https://developerxpb.com.br/api/alunos-has-rotinas'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'aluno_id': alunoId.toString(),
  //       'rotina-de-treino_id': rotinaDeTreinoId.toString(),
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     print('Aluno vinculado à rotina com sucesso');
  //   } else {
  //     print('Erro ao vincular aluno à rotina: ${response.body}');
  //     throw Exception('Falha ao vincular o aluno à rotina');
  //   }
  // }

  void _associateRoutineToStudent(int rotinaDeTreinoId) {
  final associacaoData = {
    "aluno_id": widget.alunoData['id'].toString(),  // Certifica-se de que o ID é uma String
    "rotina-de-treino_id": rotinaDeTreinoId.toString(),  // Certifica-se de que o ID é uma String
  };

  print(
      'Associando rotina de treino ID: $rotinaDeTreinoId com aluno ID: ${widget.alunoData['id']}');

  if (mounted) {
    context
        .read<AlunoHasRotinaBloc>()
        .add(CreateAlunoHasRotina(associacaoData));
  }
}

}
