import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/pages/pesquisar/treiner_details.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Entrou na ResultsScreen");

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('PROFISSIONAIS', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<PersonalBloc, PersonalState>(
        builder: (context, state) {
          if (state is PersonalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PersonalSuccess) {
            final List<dynamic> personais = state.data['data'];

            return ListView.builder(
              itemCount: personais.length,
              itemBuilder: (context, index) {
                final personal = personais[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    child: personal['foto'] != null &&
                            personal['foto'].contains('http')
                        ? null
                        : const Icon(Icons.person,
                            size: 30, color: Colors.white),
                    backgroundImage: personal['foto'] != null &&
                            personal['foto'].contains('http')
                        ? NetworkImage(personal['foto'])
                        : null,
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(personal['nome']),
                  subtitle: Text(personal['especialidade-do-personal']),
                  trailing: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text('4.8'),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                  onTap: () {
                    print("Personal selecionado: ${personal['nome']}");
                    
                    // Agora navegando para a página correta sem interferência de login
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TrainerDetailsPage(
                          personalData: personal,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is PersonalFailure) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('Nenhum resultado encontrado.'));
          }
        },
      ),
    );
  }
}
