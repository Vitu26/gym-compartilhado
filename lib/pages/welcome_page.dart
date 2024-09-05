import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.8, // Ajuste o tamanho da imagem aqui
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset(
                    'images/welcome.png', // Atualize o caminho da sua imagem
                    fit:
                        BoxFit.cover, // Ajuste a imagem para cobrir o container
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Encontre o Profissional de Saúde ideal para você',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navegação para a tela de encontrar profissional
                            },
                            child: const Text('Encontre um Profissional',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5F22),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/loginAluno');
                            },
                            child: const Text('Fazer Login',
                                style: TextStyle(color: Color(0xFFFF5F22))),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFF5F22),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontSize: 18,
                              ),
                              side: const BorderSide(color: Color(0xFFFF5F22)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Não tem uma conta? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/gender');
                                // Navigator.pushNamed(context, '/cadastroAluno');
                              },
                              child: const Text(
                                "Cadastre-se",
                                style: TextStyle(
                                  color: Color(0xFFFF5F22),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("É um profissional? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/loginPersonal');
                              },
                              child: const Text(
                                " Fazer Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
