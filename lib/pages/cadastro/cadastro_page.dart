import 'package:flutter/material.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/complete_cadastro_aluno.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/gender_page.dart';
import 'package:sprylife/pages/cadastro/cadastro_professor/personal_info_page.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/textfield_login.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool termsAccepted = false;
  bool notificationsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Criar Conta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Digite as informações abaixo e crie sua conta na SpryLife.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text('E-mail'),
            TextFieldLogin(controller: emailController, obscureText: false),
            const SizedBox(height: 16),
            Text('Telefone'),
            TextFieldLogin(controller: phoneController, obscureText: false),
            const SizedBox(height: 16),
            Text('Senha'),
            TextFieldLogin(controller: passwordController, obscureText: true),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      termsAccepted = value!;
                    });
                  },
                  activeColor: Colors.orange,
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Concordo com os ',
                      style: TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Termos e Condições',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: notificationsAccepted,
                  onChanged: (value) {
                    setState(() {
                      notificationsAccepted = value!;
                    });
                  },
                  activeColor: Colors.orange,
                ),
                const Expanded(
                  child: Text(
                    'Autorizo o recebimento de notificações.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: termsAccepted
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CadastroGeneroObjNivel(
                          email: emailController.text,
                          phone: phoneController.text,
                          password: passwordController
                              .text, // Nível de atividade também
                        ),
                      ));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: alunoCor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Aluno', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: termsAccepted
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PersonalPPage(
                          email: emailController.text,
                          phone: phoneController.text,
                          password: passwordController.text,
                          name: '',
                        ),
                      ));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: personalColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Profissional',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Já tem uma conta? Faça Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
