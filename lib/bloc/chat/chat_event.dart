import 'dart:io';

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
  final File? file; // Arquivo opcional
  final String? fileName; // Nome do arquivo opcional

  SendMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.file, // Inicialize como null
    this.fileName, // Inicialize como null
  });

  @override
  List<Object?> get props => [senderId, receiverId, message, file, fileName];
}

class MessageReceived extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;
  final File? file; // Arquivo opcional
  final String? fileName; // Nome do arquivo opcional

  MessageReceived({
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.file, // Inicialize como null
    this.fileName, // Inicialize como null
  });

  @override
  List<Object?> get props => [senderId, receiverId, message, file, fileName];
}
