// chat_state.dart
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatMessageSent extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;

  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);
}
