// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'chat_event.dart';
// import 'chat_state.dart';

// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();

//   ChatBloc() : super(ChatInitial()) {
//     on<LoadMessages>(_onLoadMessages);
//     on<SendMessage>(_onSendMessage);
//   }

//   Future<void> _onLoadMessages(
//       LoadMessages event, Emitter<ChatState> emit) async {
//     emit(ChatLoading());

//     try {
//       // Caminho para ambas as direções (4433_1 e 1_4433)
//       DatabaseReference chatRef1 = _database.child("chats/${event.senderId}_${event.receiverId}");
//       DatabaseReference chatRef2 = _database.child("chats/${event.receiverId}_${event.senderId}");

//       print('Carregando mensagens entre ${event.senderId} e ${event.receiverId}');

//       List<Map<String, dynamic>> messages = [];

//       // Carregar as mensagens de 4433 para 1
//       DatabaseEvent databaseEvent1 = await chatRef1.once();
//       DataSnapshot snapshot1 = databaseEvent1.snapshot;
//       final data1 = snapshot1.value as Map<dynamic, dynamic>?;
//       if (data1 != null) {
//         data1.forEach((key, value) {
//           messages.add({
//             'sender': value['sender'],
//             'message': value['message'],
//             'timestamp': value['timestamp'],
//           });
//         });
//       }

//       // Carregar as mensagens de 1 para 4433
//       DatabaseEvent databaseEvent2 = await chatRef2.once();
//       DataSnapshot snapshot2 = databaseEvent2.snapshot;
//       final data2 = snapshot2.value as Map<dynamic, dynamic>?;
//       if (data2 != null) {
//         data2.forEach((key, value) {
//           messages.add({
//             'sender': value['sender'],
//             'message': value['message'],
//             'timestamp': value['timestamp'],
//           });
//         });
//       }

//       // Ordenar as mensagens por timestamp
//       messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

//       if (messages.isNotEmpty) {
//         print('Mensagens carregadas: $messages');
//         emit(ChatLoaded(messages));
//       } else {
//         print('Nenhuma mensagem encontrada');
//         emit(ChatLoaded([])); // Nenhuma mensagem ainda
//       }
//     } catch (e) {
//       print('Erro ao carregar mensagens: $e');
//       emit(ChatError("Erro ao carregar mensagens: $e"));
//     }
//   }

//   Future<void> _onSendMessage(
//       SendMessage event, Emitter<ChatState> emit) async {
//     try {
//       print('Enviando mensagem de ${event.senderId} para ${event.receiverId}');

//       DatabaseReference chatRef =
//           _database.child("chats/${event.senderId}_${event.receiverId}");

//       await chatRef.push().set({
//         'sender': event.senderId,
//         'message': event.message,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       });

//       print('Mensagem enviada com sucesso');
//       emit(ChatMessageSent()); // Estado de sucesso no envio
//     } catch (e) {
//       print('Erro ao enviar mensagem: $e');
//       emit(ChatError("Erro ao enviar mensagem: $e"));
//     }
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  ChatBloc() : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  // Função para determinar o caminho único do chat
  String _getChatPath(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId]..sort();
    return "chats/${ids[0]}_${ids[1]}";
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      String chatPath = _getChatPath(event.senderId, event.receiverId);
      DatabaseReference chatRef = _database.child(chatPath);

      print('Carregando mensagens entre ${event.senderId} e ${event.receiverId} no caminho: $chatPath');

      List<Map<String, dynamic>> messages = [];

      // Carregar as mensagens de ambos os usuários no caminho único
      DatabaseEvent databaseEvent = await chatRef.once();
      DataSnapshot snapshot = databaseEvent.snapshot;
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          messages.add({
            'sender': value['sender'],
            'message': value['message'],
            'timestamp': value['timestamp'],
          });
        });
      }

      // Ordenar as mensagens por timestamp
      messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

      if (messages.isNotEmpty) {
        print('Mensagens carregadas: $messages');
        emit(ChatLoaded(messages));
      } else {
        print('Nenhuma mensagem encontrada');
        emit(ChatLoaded([])); // Nenhuma mensagem ainda
      }
    } catch (e) {
      print('Erro ao carregar mensagens: $e');
      emit(ChatError("Erro ao carregar mensagens: $e"));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      String chatPath = _getChatPath(event.senderId, event.receiverId);
      DatabaseReference chatRef = _database.child(chatPath);

      print('Enviando mensagem de ${event.senderId} para ${event.receiverId} no caminho: $chatPath');

      // Enviar mensagem
      await chatRef.push().set({
        'sender': event.senderId,
        'message': event.message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      print('Mensagem enviada com sucesso');
      emit(ChatMessageSent()); // Estado de sucesso no envio
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
      emit(ChatError("Erro ao enviar mensagem: $e"));
    }
  }
}

