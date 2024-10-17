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

class ChatListScreenPersonal extends StatefulWidget {
  @override
  State<ChatListScreenPersonal> createState() => _ChatListScreenPersonalState();
}

class _ChatListScreenPersonalState extends State<ChatListScreenPersonal> {
  late Future<List<dynamic>> _alunoListFuture;

  @override
  void initState() {
    super.initState();
    _alunoListFuture = _loadConversations();
  }

  Future<List<dynamic>> _loadConversations() async {
    // Obtém o personal logado
    PersonalBloc personalBloc = BlocProvider.of<PersonalBloc>(context);
    final personalState = personalBloc.state;

    if (personalState is PersonalSuccess) {
      final personalId = personalState.data['id'].toString();

      // Obtém todos os alunos
      AlunoBloc alunoBloc = BlocProvider.of<AlunoBloc>(context);
      final alunoState = alunoBloc.state;

      if (alunoState is AlunoSuccess && alunoState.data is List<dynamic>) {
        final List<dynamic> alunoList = alunoState.data;
        
        // Carrega as conversas ativas de forma paralela
        final filteredAlunos = await _filterConversations(personalId, alunoList);

        // Carrega todas as últimas mensagens de forma paralela
        final lastMessages = await _loadLastMessages(personalId, filteredAlunos);

        // Combina alunos com suas últimas mensagens
        return filteredAlunos.asMap().entries.map((entry) {
          final index = entry.key;
          final aluno = entry.value;
          return {
            'aluno': aluno,
            'lastMessage': lastMessages[index]
          };
        }).toList();
      }
    }

    return [];
  }

  Future<List<Map<String, dynamic>?>> _loadLastMessages(
      String personalId, List<dynamic> alunoList) async {
    List<Future<Map<String, dynamic>?>> futures = alunoList.map((aluno) {
      return _getLastMessage(personalId, aluno['id'].toString());
    }).toList();

    return await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(
        title: "Lista de Conversas",
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _alunoListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar conversas.'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final conversations = snapshot.data!;
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final aluno = conversation['aluno'];
                final lastMessage = conversation['lastMessage'];

                String lastMessagePreview = "Nenhuma mensagem";
                if (lastMessage != null) {
                  bool isSentByPersonal = lastMessage['sender'] == personalId;
                  lastMessagePreview = isSentByPersonal
                      ? "Você: ${lastMessage['message'] ?? 'Arquivo enviado'}"
                      : lastMessage['message'] ?? 'Arquivo recebido';
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
                          senderId: personalId,
                          receiverId: aluno['id'].toString(),
                          receiverName: aluno['nome'],
                          personalData: personalState.data,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('Você ainda não tem conversas.'));
          }
        },
      ),
    );
  }

  // Função para filtrar apenas os alunos com conversas ativas
  Future<List<dynamic>> _filterConversations(
      String personalId, List<dynamic> alunoList) async {
    List<Future<bool>> conversationChecks = alunoList.map((aluno) {
      return _hasConversation(personalId, aluno['id'].toString());
    }).toList();

    List<bool> hasConversations = await Future.wait(conversationChecks);

    List<dynamic> filteredAlunos = [];
    for (int i = 0; i < alunoList.length; i++) {
      if (hasConversations[i]) {
        filteredAlunos.add(alunoList[i]);
      }
    }

    return filteredAlunos;
  }

  Future<Map<String, dynamic>?> _getLastMessage(
      String personalId, String alunoId) async {
    List<String> ids = [personalId, alunoId]..sort();
    String chatPath = ids.join('_');

    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chats').child(chatPath);

    try {
      DataSnapshot snapshot =
          (await chatRef.orderByChild('timestamp').limitToLast(1).once())
              .snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> messages =
            snapshot.value as Map<dynamic, dynamic>;
        String lastMessageKey = messages.keys.last;
        Map<dynamic, dynamic> lastMessage =
            messages[lastMessageKey] as Map<dynamic, dynamic>;
        return lastMessage.map((key, value) => MapEntry(key.toString(), value));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
