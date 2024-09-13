import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/pages/aluno/chat/chat_interface.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatListScreen extends StatelessWidget {
  // Função que verifica se existe uma conversa entre o aluno e o personal
  Future<bool> _hasConversation(String alunoId, String personalId) async {
    // Ordena os IDs de forma consistente
    List<String> ids = [alunoId, personalId]..sort();
    String chatPath =
        ids.join('_'); // Gera o caminho "alunoId_personalId" de forma ordenada

    // Busca a conversa no Firebase Realtime Database
    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chats').child(chatPath);

    DatabaseEvent chatSnapshot = await chatRef.once();
    return chatSnapshot.snapshot.value != null;
  }

  Future<Map<String, dynamic>?> _getLastMessage(
      String alunoId, String personalId) async {
    List<String> ids = [alunoId, personalId]..sort();
    String chatPath = ids.join('_');

    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chats').child(chatPath);
    DataSnapshot snapshot =
        (await chatRef.orderByKey().limitToLast(1).once()).snapshot;

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
            create: (context) => PersonalBloc()..add(GetAllPersonais()),
          ),
          BlocProvider(
            create: (context) =>
                AlunoBloc()..add(GetAlunoLogado()), // Buscar o aluno logado
          ),
        ],
        child: BlocBuilder<AlunoBloc, AlunoState>(
          builder: (context, alunoState) {
            if (alunoState is AlunoSuccess) {
              final alunoId =
                  alunoState.data['id'].toString(); // ID do aluno logado

              return BlocBuilder<PersonalBloc, PersonalState>(
                builder: (context, personalState) {
                  if (personalState is PersonalSuccess) {
                    print(personalState
                        .data); // Verifica o conteúdo dos personais

                    final Map<String, dynamic> personalMap = personalState.data;

                    if (personalMap.containsKey('data') &&
                        personalMap['data'] is List) {
                      final List<dynamic> personalList = personalMap['data'];

                      return FutureBuilder<List<dynamic>>(
                        future: _filterConversations(alunoId, personalList),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Erro ao carregar conversas.'));
                          } else if (snapshot.hasData) {
                            final filteredPersonals = snapshot.data!;
                            if (filteredPersonals.isEmpty) {
                              return Center(
                                  child: Text('Você ainda não tem conversas.'));
                            }

                            return ListView.builder(
                              itemCount: filteredPersonals.length,
                              itemBuilder: (context, index) {
                                final personal = filteredPersonals[index];
                                return FutureBuilder<Map<String, dynamic>?>(
                                  future: _getLastMessage(
                                      alunoId, personal['id'].toString()),
                                  builder: (context, messageSnapshot) {
                                    String lastMessagePreview =
                                        "Nenhuma mensagem";
                                    if (messageSnapshot.hasData) {
                                      final lastMessage = messageSnapshot.data!;
                                      bool isSentByUser =
                                          lastMessage['sender'] == alunoId;

                                      if (isSentByUser) {
                                        lastMessagePreview =
                                            "Você: ${lastMessage['message']}";
                                      } else {
                                        lastMessagePreview =
                                            lastMessage['message'];
                                      }
                                    }

                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          personal['foto'] ??
                                              'https://via.placeholder.com/150',
                                        ),
                                      ),
                                      title: Text(
                                        personal['nome'] ?? 'Nome do Personal',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(lastMessagePreview),
                                      trailing: Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              senderId:
                                                  alunoId, // ID do aluno logado
                                              receiverId: personal['id']
                                                  .toString(), // ID do personal
                                              alunoData: alunoState
                                                  .data, // Passando os dados do aluno
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
                            return Center(
                                child: Text('Você ainda não tem conversas.'));
                          }
                        },
                      );
                    } else {
                      return Center(
                          child:
                              Text('Não há dados de personais disponíveis.'));
                    }
                  } else if (personalState is PersonalFailure) {
                    return Center(
                        child: Text(
                            'Erro ao carregar personal: ${personalState.error}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else if (alunoState is AlunoFailure) {
              return Center(
                  child: Text(
                      'Erro ao carregar aluno logado: ${alunoState.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  // Função para filtrar apenas os personais com conversas ativas
  Future<List<dynamic>> _filterConversations(
      String alunoId, List<dynamic> personalList) async {
    // Use Future.wait para executar todas as verificações de conversas em paralelo
    List<Future<bool>> conversationChecks = personalList.map((personal) {
      final personalId = personal['id'].toString();
      return _hasConversation(alunoId, personalId);
    }).toList();

    // Aguarde todos os futures serem resolvidos
    List<bool> hasConversations = await Future.wait(conversationChecks);

    // Filtrar apenas os personais com conversas ativas
    List<dynamic> filteredPersonals = [];
    for (int i = 0; i < personalList.length; i++) {
      if (hasConversations[i]) {
        filteredPersonals.add(personalList[i]);
      }
    }

    return filteredPersonals;
  }
}
