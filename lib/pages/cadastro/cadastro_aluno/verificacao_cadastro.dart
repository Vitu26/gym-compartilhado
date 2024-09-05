import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String email;
  final TextEditingController codeController = TextEditingController();

  VerifyCodeScreen({required this.email});

  void _verifyCode(BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://seu_servidor/api/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': codeController.text}),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Email verificado com sucesso.');
      // Navegar para a próxima tela ou home page
    } else {
      Fluttertoast.showToast(msg: 'Código de verificação inválido.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verificação de Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: 'Código de Verificação'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _verifyCode(context),
              child: Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}
