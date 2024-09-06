// chat_event.dart
abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String senderId;
  final String receiverId;

  LoadMessages({required this.senderId, required this.receiverId});
}

class SendMessage extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;

  SendMessage({required this.senderId, required this.receiverId, required this.message});
}

class MessageReceived extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;

  MessageReceived({required this.senderId, required this.receiverId, required this.message});
}
