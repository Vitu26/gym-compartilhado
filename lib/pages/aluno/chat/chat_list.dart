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

class ChatListScreen extends StatelessWidget {
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
            create: (context) => AlunoBloc()..add(GetAlunoLogado()), // Buscar o aluno logado
          ),
        ],
        child: BlocBuilder<AlunoBloc, AlunoState>(
          builder: (context, alunoState) {
            if (alunoState is AlunoSuccess) {
              final alunoId = alunoState.data['id'].toString(); // ID do aluno logado

              return BlocBuilder<PersonalBloc, PersonalState>(
                builder: (context, personalState) {
                  if (personalState is PersonalSuccess) {
                    print(personalState.data); // Verifica o conteúdo dos personais

                    final Map<String, dynamic> personalMap = personalState.data;

                    if (personalMap.containsKey('data') &&
                        personalMap['data'] is List) {
                      final List<dynamic> personalList = personalMap['data'];

                      return ListView.builder(
                        itemCount: personalList.length,
                        itemBuilder: (context, index) {
                          final personal = personalList[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                personal['foto'] ?? 'https://via.placeholder.com/150',
                              ),
                            ),
                            title: Text(
                              personal['nome'] ?? 'Nome do Personal',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Última mensagem...'),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    senderId: alunoId, // ID do aluno logado
                                    receiverId: personal['id'].toString(), // ID do personal
                                    alunoData: alunoState.data, // Passando os dados do aluno
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('Não há dados de personais disponíveis.'));
                    }
                  } else if (personalState is PersonalFailure) {
                    return Center(child: Text('Erro ao carregar personal: ${personalState.error}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else if (alunoState is AlunoFailure) {
              return Center(child: Text('Erro ao carregar aluno logado: ${alunoState.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
