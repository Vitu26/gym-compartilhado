import 'package:flutter/material.dart';
import 'package:sprylife/utils/colors.dart';

class AlunoPlanosScreen extends StatelessWidget {
  final Map<String, dynamic> alunoData;

  AlunoPlanosScreen({required this.alunoData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planos de ${alunoData['name'] ?? 'Aluno'}'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Aqui você pode inserir os detalhes específicos dos planos.
          Text('Plano Atual', style: TextStyle(color: personalColor)),
          Text('Descrição: Plano Premium'),
          // Adicione mais detalhes e estilos conforme necessário
        ],
      ),
    );
  }
}