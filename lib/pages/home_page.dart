import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Adicionando logs para mostrar se entrou como aluno ou personal

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text(
          'Você é um Aluno' 'Você é um Profissional',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
