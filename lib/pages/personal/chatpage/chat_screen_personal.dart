import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/chat/chat_bloc.dart';
import 'package:sprylife/bloc/chat/chat_event.dart';
import 'package:sprylife/bloc/chat/chat_state.dart';
import 'package:sprylife/widgets/custom_appbar.dart';

class ChatScreenPersonal extends StatelessWidget {
  final String senderId;
  final String receiverId;

  ChatScreenPersonal({required this.senderId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()
        ..add(LoadMessages(senderId: senderId, receiverId: receiverId)),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Conversa',
        ),
        body: Column(
          children: [
            Expanded(child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isSender = message['sender'] == senderId;

                      return Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 14.0),
                          decoration: BoxDecoration(
                            color: isSender
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: isSender
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(
                                  color: isSender
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                DateTime.fromMillisecondsSinceEpoch(
                                        message['timestamp'])
                                    .toLocal()
                                    .toString(),
                                style: TextStyle(
                                  color: isSender
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatMessageSent) {
                  // Volta ao estado de carregamento de mensagens para exibir as atualizações
                  BlocProvider.of<ChatBloc>(context).add(LoadMessages(
                    senderId: senderId,
                    receiverId: receiverId,
                  ));
                  return Container(); // Placeholder enquanto as mensagens são recarregadas
                } else if (state is ChatError) {
                  return Center(child: Text('Erro: ${state.error}'));
                } else {
                  return Center(child: Text('Nenhuma mensagem ainda'));
                }
              },
            )),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                BlocProvider.of<ChatBloc>(context).add(SendMessage(
                  senderId: senderId,
                  receiverId: receiverId,
                  message: _controller.text,
                ));
                _controller.clear(); // Limpa o campo de texto após o envio
              }
            },
          ),
        ],
      ),
    );
  }
}
