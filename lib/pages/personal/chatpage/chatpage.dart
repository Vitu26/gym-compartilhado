import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/pages/personal/chatpage/chat_screen_personal.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(
        title: "Lista de Conversas",
      ),
      body: BlocProvider(
        create: (context) => PersonalBloc()..add(GetPersonalLogado()), // Buscar personal logado
        child: BlocBuilder<PersonalBloc, PersonalState>(
          builder: (context, personalState) {
            if (personalState is PersonalLoading) {
              return Center(child: CircularProgressIndicator()); // Indicador de carregamento
            } else if (personalState is PersonalSuccess) {
              final personalData = personalState.data;

              // Verifique se personalData contém a lista de alunos associados
              if (personalData.containsKey('alunos') && personalData['alunos'] is List) {
                final List<dynamic> alunosList = personalData['alunos'];

                if (alunosList.isEmpty) {
                  return Center(child: Text('Nenhum aluno disponível.'));
                }

                return ListView.builder(
                  itemCount: alunosList.length,
                  itemBuilder: (context, index) {
                    final aluno = alunosList[index];

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: aluno['foto'] != null && aluno['foto'] != ""
                            ? NetworkImage(aluno['foto'])
                            : AssetImage('images/default_placeholder.jpg'), // Placeholder padrão
                      ),
                      title: Text(
                        aluno['nome'] ?? 'Nome do Aluno',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Última mensagem...',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '10:35 PM', // Exemplo de horário fixo
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreenPersonal(
                              senderId: personalData['id'].toString(), // ID do personal logado
                              receiverId: aluno['id'].toString(), // ID do aluno clicado
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return Center(child: Text('Nenhum aluno associado ao personal.'));
              }
            } else if (personalState is PersonalFailure) {
              return Center(child: Text('Erro ao carregar personal: ${personalState.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
