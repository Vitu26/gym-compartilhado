import 'package:flutter/material.dart';
import 'package:sprylife/pages/personal/aluno_treino_screen.dart';
import 'package:sprylife/pages/personal/arquivos/aluno_arquivo.dart';
import 'package:sprylife/pages/personal/faturasAndPlanos/faturas_srcreen.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_button.dart';

class AlunoPerfilScreen extends StatelessWidget {
  final Map<String, dynamic>? alunoData;
  final Map<String, dynamic>? personalData; // Adicione personalData aqui

  AlunoPerfilScreen({required this.alunoData, required this.personalData});

  @override
  Widget build(BuildContext context) {
    // Verifique se `alunoData` é nulo
    if (alunoData == null) {
      return Scaffold(
        body: Center(
          child: Text('Erro: Dados do aluno estão indisponíveis.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(),
          iconSize: 24,
        ),
        title: const Text(
          'Perfil Aluno',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildActionButtons(context),
            SizedBox(height: 20),
            _buildObjectiveSection(),
            SizedBox(height: 20),
            _buildAnnotationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Verificação de valores nulos com fallback para valores padrão
    final String nome =
        alunoData?['user']?['name']?.replaceAll(' ', '').toLowerCase() ??
            'default_image';
    final String nomeExibicao =
        alunoData?['user']?['name'] ?? 'Nome Indisponível';
    final String status = alunoData?['status']?.toString() ??
        'Status Indisponível'; // Conversão para string
    final String cidade = alunoData?['address']?['cidade']?.toString() ??
        'Localização Indisponível'; // Conversão para string

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('images/$nome.jpg'),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nomeExibicao,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              status,
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            Text(
              cidade,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(Icons.fitness_center, 'Treinos', context),
            _buildActionButton(Icons.loop, 'Planos', context),
            _buildActionButton(Icons.assessment, 'Avaliações', context),
            _buildActionButton(Icons.assignment, 'Progresso', context),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(Icons.history, 'Arquivo', context),
            _buildActionButton(Icons.message, 'Chat', context),
            _buildActionButton(Icons.message, 'Inativar', context),
            _buildActionButton(Icons.message, 'Excluir', context),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'Treinos') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlunoTreinosScreen(
                alunoData: alunoData!,
                treinos: [],
              ),
            ),
          );
        } else if (label == 'Faturas' || label == 'Planos') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlunoFaturaScreen(
                alunoData: alunoData!,
                personalData: personalData!, // Passe personalData aqui
              ),
            ),
          );
        } else if (label == 'Arquivos') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlunoArquivosScreen(alunoData: alunoData!),
            ),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: personalColor,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildObjectiveSection() {
    final String objetivo = alunoData?['informacoes_comuns']?['objetivo'] ??
        'Objetivos não informados';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objetivos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          objetivo,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAnnotationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anotações',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Escreva suas anotações aqui...',
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: CustomButton(
            text: 'Salvar',
            backgroundColor: personalColor,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
