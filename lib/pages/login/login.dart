import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/pages/cadastro/cadastro_page.dart';
import 'package:sprylife/pages/home_page.dart';
import 'package:sprylife/pages/personal/home_page_parsonal.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/bottom_navigation.dart';
import 'package:sprylife/widgets/bottom_navigator_aluno.dart';
import 'package:sprylife/widgets/circleravatar.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/custom_button_borda.dart';
import 'package:sprylife/widgets/textfield.dart';
import 'package:sprylife/widgets/textfield_login.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PersonalBloc, PersonalState>(
        listener: (context, personalState) {
          if (personalState is PersonalSuccess) {
            final personalData = personalState.data;

            // Certifique-se de que 'data' está presente e é um Map
            if (personalData is Map<String, dynamic>) {
              print("Login realizado como Personal");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavBarPersonal(
                    personalData: personalData,
                  ),
                ),
              );
            } else {
              print(
                  "Erro: Estrutura de resposta inesperada. Esperava 'data' como Map.");
              _showDialog(context, 'Erro inesperado',
                  'Erro ao fazer login como personal.');
            }
          } else if (personalState is PersonalFailure) {
            print('Erro no PersonalFailure: ${personalState.error}');
            _showDialog(context, 'Erro no login',
                'Login falhou: ${personalState.error}');
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/telafinal1.png',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.23),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Encontre',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Profissionais',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Qualificados e',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Certificados',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                        text: 'Encontre um profissional',
                        backgroundColor: alunoCor,
                        onPressed: () {
                          Navigator.pushNamed(context, '/filter');
                        }),
                    const SizedBox(height: 20),
                    const Text(
                      'E-mail',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextFieldLC(
                      controller: emailController,
                      obscureText: false,
                      fillColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Senha',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextFieldLogin(
                      controller: passwordController,
                      obscureText: true,
                      fillColor: Colors.grey.shade200,
                      showPasswordToggle: true,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // Navegar para a tela de recuperação de senha
                      },
                      style: TextButton.styleFrom(
                          alignment: Alignment.centerRight),
                      child: const Text('Esqueceu a senha?'),
                    ),
                    const SizedBox(height: 20),
                    CustomButtonBorda(
                        text: 'Entrar',
                        textStyle: const TextStyle(color: alunoCor),
                        backgroundColor: Colors.white,
                        borderColor: alunoCor,
                        onPressed: () {
                          _loginAluno(context);
                        }),
                    const SizedBox(height: 15),
                    CustomButtonBorda(
                        text: 'Entrar Personal',
                        textStyle: const TextStyle(color: personalColor),
                        backgroundColor: Colors.white,
                        borderColor: personalColor,
                        onPressed: () {
                          _loginPersonal(context);
                        }),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BorderedCircleAvatar(
                          borderColor: Colors.black,
                          imagePath: 'images/apple.png',
                          radius: 25,
                          borderWidth: 0.5,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        BorderedCircleAvatar(
                          borderColor: Colors.black,
                          imagePath: 'images/google.png',
                          radius: 25,
                          borderWidth: 0.5,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        BorderedCircleAvatar(
                          borderColor: Colors.black,
                          imagePath: 'images/face.png',
                          radius: 25,
                          borderWidth: 0.5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CadastroScreen()));
                      },
                      child: const Text('Não tem uma conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginAluno(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    BlocProvider.of<AlunoBloc>(context).add(AlunoLogin(email, password));

    // Listener para tratar a resposta do login como aluno
    BlocProvider.of<AlunoBloc>(context).stream.listen((alunoState) {
      try {
        print("Resposta da API para aluno: ${alunoState}");

        if (alunoState is AlunoFailure) {
          _showDialog(context, 'Erro no login', 'Login como Aluno falhou.');
        } else if (alunoState is AlunoSuccess) {
          print("Dados recebidos no login do aluno: ${alunoState.data}");

          // Verifica se a chave 'id' e 'nome' existem nos dados
          if (alunoState.data.containsKey('id') &&
              alunoState.data.containsKey('nome')) {
            final alunoData = alunoState.data;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => NavBarAluno(
                  alunoData: alunoData,
                ),
              ),
            );
          } else {
            _showDialog(
                context, 'Erro inesperado', 'Erro inesperado durante o login.');
          }
        }
      } catch (e) {
        print("Erro durante o login como aluno: $e");
      }
    });
  }

  void _loginPersonal(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    BlocProvider.of<PersonalBloc>(context).add(PersonalLogin(email, password));

    // Listener para tratar a resposta do login como personal
    BlocProvider.of<PersonalBloc>(context).stream.listen((personalState) {
      try {
        print("Resposta da API para personal: ${personalState}");

        if (personalState is PersonalFailure) {
          _showDialog(context, 'Erro no login', 'Login como Personal falhou.');
        } else if (personalState is PersonalSuccess) {
          print("Dados recebidos no login do personal: ${personalState.data}");

          // Verifica se a chave 'id' e 'nome' existem nos dados
          if (personalState.data.containsKey('id') &&
              personalState.data.containsKey('nome')) {
            final personalData = personalState.data;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => NavBarPersonal(
                  personalData: personalData,
                ),
              ),
            );
          } else {
            _showDialog(
                context, 'Erro inesperado', 'Erro inesperado durante o login.');
          }
        }
      } catch (e) {
        print("Erro durante o login como personal: $e");
      }
    });
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
