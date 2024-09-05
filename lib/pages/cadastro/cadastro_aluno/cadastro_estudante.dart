import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/textfield.dart';

class CadastroAlunoScreen extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<AlunoBloc, AlunoState>(
          listener: (context, state) {
            if (state is AlunoSuccess) {
              // Navegar para a tela de login ou mostrar uma mensagem de sucesso
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cadastro realizado com sucesso!')),
              );

              Navigator.pushNamed(
                context,
                '/verify',
                arguments: emailController.text,
              );
            } else if (state is AlunoFailure) {
              // Mostrar mensagem de erro
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Falha no cadastro: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<AlunoBloc, AlunoState>(
            builder: (context, state) {
              if (state is AlunoLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Center(
                        child: Text(
                          'Criar Conta',
                          style: TextStyle(fontSize: 35, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Preencha suas informações abaixo ou registre-se com sua conta social.',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Nome'),
                        ],
                      ),
                      TextFieldLC(
                          controller: nomeController, obscureText: false),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('E-mail'),
                        ],
                      ),
                      TextFieldLC(
                          controller: emailController, obscureText: false),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('CPF'),
                        ],
                      ),
                      TextFieldLC(
                        controller: cpfController,
                        obscureText: true,
                        showPasswordToggle: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Senha'),
                        ],
                      ),
                      TextFieldLC(
                        controller: passwordController,
                        obscureText: true,
                        showPasswordToggle: true,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      CustomButton(
                        text: 'Criar',
                        backgroundColor: const Color(0xFFFF5F22),
                        onPressed: () {
                          Map<String, dynamic> alunoData = {
                            'nome': nomeController.text,
                            'email': emailController.text,
                            'password': passwordController.text,
                            'cpf': cpfController.text,
                          };
                          BlocProvider.of<AlunoBloc>(context).add(
                            AlunoCadastro(alunoData),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "Ou entre com",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 75,
                              width: 75,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[200],
                                child: Image.asset(
                                  'images/apple.png',
                                  height: 25,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 75,
                              width: 75,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[200],
                                child: Image.asset(
                                  'images/google.png',
                                  height: 35,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            // onTap: () => loginWithFacebook(),
                            child: Container(
                              height: 75,
                              width: 75,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[200],
                                child: Image.asset(
                                  'images/face.png',
                                  height: 35,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
