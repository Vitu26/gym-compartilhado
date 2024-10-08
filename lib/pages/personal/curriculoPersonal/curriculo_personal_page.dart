import 'package:flutter/material.dart';
import 'package:sprylife/pages/personal/curriculoPersonal/editi_curriculo_personal_page.dart';
import 'package:sprylife/utils/colors.dart';

class CurriculoPersonalPage extends StatelessWidget {
  final Map<String, dynamic> personalData;

  CurriculoPersonalPage({required this.personalData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Personal'),
        backgroundColor: personalColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInfo(),
            const SizedBox(height: 20),
            _buildQualifications(),
            const SizedBox(height: 20),
            _buildEditButton(context), // Botão para editar o perfil
          ],
        ),
      ),
    );
  }

  // Exibe as informações do personal
  Widget _buildPersonalInfo() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            personalData['foto'] != null && personalData['foto'].isNotEmpty
                ? personalData['foto'] // Se a URL for válida, exibe a foto do personal
                : 'https://via.placeholder.com/150', // Placeholder para quando não houver foto
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          personalData['nome'] ?? 'Nome não disponível',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          personalData['sobre'] ?? 'Informação não disponível',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Exibe as qualificações do personal
  Widget _buildQualifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Qualificações:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(personalData['especialidade-do-personal'] ?? 'Especialidade não disponível'),
        const SizedBox(height: 5),
        Text('CREF: ${personalData['cref'] ?? 'CREF não disponível'}'),
        const SizedBox(height: 5),
        Text('CONFEF: ${personalData['confef'] ?? 'CONFEF não disponível'}'),
      ],
    );
  }

  // Botão de edição de perfil
  Widget _buildEditButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(Icons.edit, color: personalColor),
        onPressed: () {
          // Navegar para a tela de edição com os dados atuais do personal
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditiCurriculoPersonalPage(personalData: personalData),
            ),
          );
        },
      ),
    );
  }
}
