import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/pages/personal/chatpage/chat_screen_personal.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatListScreenPersonal extends StatelessWidget {
  // Função que verifica se existe uma conversa entre o personal e o aluno
  Future<bool> _hasConversation(String personalId, String alunoId) async {
    // Ordena os IDs de forma consistente
    List<String> ids = [personalId, alunoId]..sort();
    String chatPath = ids.join('_'); // Gera o caminho "personalId_alunoId" de forma ordenada

    // Busca a conversa no Firebase Realtime Database
    DatabaseReference chatRef = FirebaseDatabase.instance.ref().child('chats').child(chatPath);

    DatabaseEvent chatSnapshot = await chatRef.once();
    return chatSnapshot.snapshot.value != null;
  }

  Future<Map<String, dynamic>?> _getLastMessage(String personalId, String alunoId) async {
    List<String> ids = [personalId, alunoId]..sort();
    String chatPath = ids.join('_');

    DatabaseReference chatRef = FirebaseDatabase.instance.ref().child('chats').child(chatPath);
    DataSnapshot snapshot = (await chatRef.orderByKey().limitToLast(1).once()).snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> messages = snapshot.value as Map<dynamic, dynamic>;
      // Pega a última mensagem
      String lastMessageKey = messages.keys.last;
      return messages[lastMessageKey] as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(
        title: "Lista de Conversas",
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AlunoBloc()..add(GetAllAlunos()), // Buscar todos os alunos
          ),
          BlocProvider(
            create: (context) => PersonalBloc()..add(GetPersonalLogado()), // Buscar o personal logado
          ),
        ],
        child: BlocBuilder<PersonalBloc, PersonalState>(
          builder: (context, personalState) {
            if (personalState is PersonalSuccess) {
              final personalId = personalState.data['id'].toString(); // ID do personal logado

              return BlocBuilder<AlunoBloc, AlunoState>(
                builder: (context, alunoState) {
                  if (alunoState is AlunoSuccess) {
                    print(alunoState.data); // Verifica o conteúdo dos alunos

                    // Verificando se o data é uma lista de alunos
                    if (alunoState.data is List<dynamic>) {
                      final List<dynamic> alunoList = alunoState.data;

                      return FutureBuilder<List<dynamic>>(
                        future: _filterConversations(personalId, alunoList),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Erro ao carregar conversas.'));
                          } else if (snapshot.hasData) {
                            final filteredAlunos = snapshot.data!;
                            if (filteredAlunos.isEmpty) {
                              return Center(child: Text('Você ainda não tem conversas.'));
                            }

                            return ListView.builder(
                              itemCount: filteredAlunos.length,
                              itemBuilder: (context, index) {
                                final aluno = filteredAlunos[index];
                                return FutureBuilder<Map<String, dynamic>?>(
                                  future: _getLastMessage(personalId, aluno['id'].toString()),
                                  builder: (context, messageSnapshot) {
                                    String lastMessagePreview = "Nenhuma mensagem";
                                    if (messageSnapshot.hasData) {
                                      final lastMessage = messageSnapshot.data!;
                                      bool isSentByPersonal = lastMessage['sender'] == personalId;

                                      if (isSentByPersonal) {
                                        lastMessagePreview = "Você: ${lastMessage['message']}";
                                      } else {
                                        lastMessagePreview = lastMessage['message'];
                                      }
                                    }

                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          aluno['foto'] ?? 'https://via.placeholder.com/150',
                                        ),
                                      ),
                                      title: Text(
                                        aluno['nome'] ?? 'Nome do Aluno',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(lastMessagePreview),
                                      trailing: Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreenPersonal(
                                              senderId: personalId, // ID do personal logado
                                              receiverId: aluno['id'].toString(), personalData: personalState.data, // ID do aluno
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            return Center(child: Text('Você ainda não tem conversas.'));
                          }
                        },
                      );
                    } else {
                      return Center(child: Text('Não há dados de alunos disponíveis.'));
                    }
                  } else if (alunoState is AlunoFailure) {
                    return Center(child: Text('Erro ao carregar alunos: ${alunoState.error}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
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

  // Função para filtrar apenas os alunos com conversas ativas
  Future<List<dynamic>> _filterConversations(String personalId, List<dynamic> alunoList) async {
    // Use Future.wait para executar todas as verificações de conversas em paralelo
    List<Future<bool>> conversationChecks = alunoList.map((aluno) {
      final alunoId = aluno['id'].toString();
      return _hasConversation(personalId, alunoId);
    }).toList();

    // Aguarde todos os futures serem resolvidos
    List<bool> hasConversations = await Future.wait(conversationChecks);

    // Filtrar apenas os alunos com conversas ativas
    List<dynamic> filteredAlunos = [];
    for (int i = 0; i < alunoList.length; i++) {
      if (hasConversations[i]) {
        filteredAlunos.add(alunoList[i]);
      }
    }

    return filteredAlunos;
  }
}
