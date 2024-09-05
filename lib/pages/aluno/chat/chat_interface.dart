// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sprylife/bloc/chat/chat_bloc.dart';
// import 'package:sprylife/bloc/chat/chat_event.dart';
// import 'package:sprylife/bloc/chat/chat_state.dart';
// import 'package:sprylife/chat_service.dart';


// class ChatScreen extends StatelessWidget {
//   // final String chatId;

//   // ChatScreen({required this.chatId,});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ChatBloc(ChatService())..add(LoadMessages(chatId)),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Chat'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: BlocBuilder<ChatBloc, ChatState>(
//                 builder: (context, state) {
//                   if (state is ChatLoading) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (state is ChatLoaded) {
//                     return ListView.builder(
//                       itemCount: state.messages.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(state.messages[index].text),
//                           subtitle: Text(state.messages[index].timestamp.toString()),
//                         );
//                       },
//                     );
//                   } else if (state is ChatError) {
//                     return Center(child: Text('Erro: ${state.error}'));
//                   } else {
//                     return Center(child: Text('Nenhuma mensagem ainda'));
//                   }
//                 },
//               ),
//             ),
//             _buildMessageInput(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput(BuildContext context) {
//     final TextEditingController _controller = TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(hintText: 'Digite sua mensagem'),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {
//               if (_controller.text.isNotEmpty) {
//                 BlocProvider.of<ChatBloc>(context).add(SendMessage(chatId, _controller.text));
//                 _controller.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:sprylife/widgets/custom_appbar.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Conversa',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Exemplo com 10 mensagens
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Mensagem $index'),
                  subtitle: Text('12:34 PM'), // Exemplo de horário fixo
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
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
              _controller.clear(); // Limpa o campo de texto ao enviar
            },
          ),
        ],
      ),
    );
  }
}
