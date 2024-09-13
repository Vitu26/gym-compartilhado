import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

      print(
          'Carregando mensagens entre ${event.senderId} e ${event.receiverId} no caminho: $chatPath');

      // Escutando mudanças em tempo real no nó do chat
      await chatRef.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        List<Map<String, dynamic>> messages = [];

        if (data != null) {
          data.forEach((key, value) {
            messages.add({
              'sender': value['sender'],
              'message': value['message'],
              'timestamp': value['timestamp'],
              'file_url': value['file_url'], // Verifique se há arquivos
              'file_name':
                  value['file_name'], // Verifique se há nome de arquivo
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
      }).asFuture(); // Garantir que seja aguardado
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

      print(
          'Enviando mensagem de ${event.senderId} para ${event.receiverId} no caminho: $chatPath');

      String? fileUrl;

      // Se um arquivo foi selecionado, faça upload no Firebase Storage
      if (event.file != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('chat_files')
            .child(
                '${DateTime.now().millisecondsSinceEpoch}_${event.fileName}');
        await storageRef.putFile(event.file!);
        fileUrl = await storageRef.getDownloadURL();
      }

      // Enviar mensagem com ou sem arquivo
      await chatRef.push().set({
        'sender': event.senderId,
        'message': event.message.isNotEmpty ? event.message : null, // Mensagem
        'file_url': fileUrl, // URL do arquivo (pode ser null)
        'file_name': event.fileName, // Nome do arquivo (pode ser null)
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

