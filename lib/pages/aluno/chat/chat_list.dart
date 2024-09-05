import 'package:flutter/material.dart';
import 'package:sprylife/pages/aluno/chat/chat_interface.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(
        title: "Lista de Conversas",
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: 6, // Exemplo com 6 chats
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Exemplo de imagem
            ),
            title: Text(
              'Nome do Usuário $index',
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
                  builder: (context) => ChatScreen(), // Sua tela de chat
                ),
              );
            },
          );
        }
      ),
    );
  }
}
