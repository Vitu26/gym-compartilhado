// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> _personals = [];
  bool _isLoadingPersonals = true;

  @override
  void initState() {
    super.initState();
    _loadPersonals(); // Carregar os personals no init
  }

  // Função para carregar os personals
  Future<void> _loadPersonals() async {
    try {
      List<Map<String, dynamic>> personals = await _fetchRandomPersonals();
      setState(() {
        _personals = personals;
        _isLoadingPersonals = false;
      });
    } catch (e) {
      print('Erro ao carregar personals: $e');
      setState(() {
        _isLoadingPersonals = false;
      });
    }
  }

  // Widget build
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
                  _buildMeusTreinosSection(treinos),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildTopPersonalsSection(),
          const SizedBox(height: 25,)
        ],
      ),
    );
  }

  // Widget para "Meus Treinos"
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
        treinos.isEmpty
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
                    return _buildTreinoCard(
                      treinos[index]['title'],
                      treinos[index]['instructor'],
                      treinos[index]['imagePath'],
                      treinos[index]['rating'],
                      treinos[index]['category'],
                    );
                  },
                ),
              ),
      ],
    );
  }

  // Função para exibir os personals no topo
  Widget _buildTopPersonalsSection() {
    if (_isLoadingPersonals) {
      return Center(child: CircularProgressIndicator());
    }

    if (_personals.isEmpty) {
      return Text(
        "Nenhum personal encontrado.",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top Personals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Ver todos",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _personals.length,
            itemBuilder: (context, index) {
              final personal = _personals[index];
              return _buildPersonalAvatar(personal);
            },
          ),
        ),
      ],
    );
  }

  // Widget para exibir o avatar dos personals
  Widget _buildPersonalAvatar(Map<String, dynamic> personal) {
    final data = personal['data'];
    String nomeCompleto = data['nome'] ?? 'Nome desconhecido';
    String primeiroNome =
        nomeCompleto.split(' ').first; // Pega apenas o primeiro nome

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: data['foto'] != null
                ? NetworkImage(data['foto'])
                : AssetImage('images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 8),
          Text(
            primeiroNome, // Exibe apenas o primeiro nome
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

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
}

// Função para gerar uma lista de IDs aleatórios
List<int> _generateRandomIds(int count, int maxId) {
  Random random = Random();
  Set<int> randomIds = {};
  while (randomIds.length < count) {
    randomIds.add(random.nextInt(maxId) + 1); // Gera números de 1 até maxId
  }
  print('IDs aleatórios gerados: $randomIds'); // Log dos IDs gerados
  return randomIds.toList();
}

// Função para buscar os dados de um profissional baseado no ID

Future<Map<String, dynamic>> _fetchPersonalById(int id) async {
  print('entrou nessa função');
  final token = await getToken();
  print('Buscando personal com ID: $id'); // Log do ID sendo buscado
  final response = await http.get(
    Uri.parse('https://developerxpb.com.br/api/personal/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Caso precise de autenticação
    },
  );

  if (response.statusCode == 200) {
    final personalData = jsonDecode(response.body);
    print(
        'Dados recebidos para o ID $id: $personalData'); // Log dos dados recebidos
    return personalData;
  } else {
    print(
        'Erro ao buscar personal com ID $id, Status code: ${response.statusCode}');
    throw Exception('Falha ao buscar personal com id $id');
  }
}

// Função para buscar múltiplos personals
Future<List<Map<String, dynamic>>> _fetchRandomPersonals() async {
  List<int> randomIds = _generateRandomIds(5, 564); // Gera 5 IDs aleatórios
  List<Map<String, dynamic>> personals = [];

  for (int id in randomIds) {
    try {
      Map<String, dynamic> personal = await _fetchPersonalById(id);
      personals.add(personal);
    } catch (e) {
      print('Erro ao buscar personal com id $id: $e');
    }
  }

  print(
      'Lista final de personals: $personals'); // Log da lista final de personals
  return personals;
}

class TopPersonalsSection extends StatefulWidget {
  @override
  _TopPersonalsSectionState createState() => _TopPersonalsSectionState();
}

class _TopPersonalsSectionState extends State<TopPersonalsSection> {
  List<Map<String, dynamic>> _personals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersonals();
  }

  Future<void> _loadPersonals() async {
    try {
      print('Carregando personals aleatórios...'); // Log do início da operação
      List<Map<String, dynamic>> personals = await _fetchRandomPersonals();
      setState(() {
        _personals = personals;
        _isLoading = false;
      });
      print('Personals carregados com sucesso.'); // Log de sucesso
    } catch (e) {
      print('Erro ao carregar personals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top Personals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Ver todos",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _personals.length,
            itemBuilder: (context, index) {
              final personal = _personals[index];
              return _buildPersonalAvatar(personal);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalAvatar(Map<String, dynamic> personal) {
    // Acessa os dados dentro da chave 'data'
    final data = personal['data'];

    // URL de uma imagem de avatar genérica
    const placeholderAvatarUrl = 'https://via.placeholder.com/150';

    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35, // Tamanho do avatar
            backgroundImage: data['foto'] != null && data['foto'].isNotEmpty
                ? NetworkImage(data['foto'])
                : NetworkImage(
                    placeholderAvatarUrl), // Usa a URL da imagem genérica
          ),
          const SizedBox(height: 8),
          // Aqui acessamos o nome corretamente dentro de 'data'
          Text(
            data['nome'] != null && data['nome'].isNotEmpty
                ? data['nome'] // Garante que o nome será exibido corretamente
                : 'Nome desconhecido', // Exibe mensagem padrão se o nome for nulo ou vazio
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
