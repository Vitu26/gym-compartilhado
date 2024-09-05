import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:sprylife/bloc/chat/chat_event.dart';
import 'package:sprylife/bloc/chat/chat_state.dart';
import 'package:sprylife/chat_service.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;
  late PusherClient pusher;
  late Channel channel;

  ChatBloc(this.chatService) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    _initializePusher();
  }


  void _initializePusher() {
    pusher = PusherClient(
      "YOUR_PUSHER_APP_KEY",
      PusherOptions(cluster: "YOUR_CLUSTER"),
      enableLogging: true,
    );

    channel = pusher.subscribe('chat');
    channel.bind('MessageSent', (event) {
      add(LoadMessages(event.chatId));
    });

    pusher.connect();
  }

  @override
  Future<void> close() {
    pusher.unsubscribe("chat");
    pusher.disconnect();
    return super.close();
  }


  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await chatService.getMessages(event.chatId);
      emit(ChatLoaded(messages));
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await chatService.sendMessage(event.chatId, event.message);
      emit(MessageSentSuccess());
      add(LoadMessages(event.chatId));  // Recarregar as mensagens após enviar
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }
}
