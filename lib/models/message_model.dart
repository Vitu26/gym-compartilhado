class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final String senderId;

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['message'],
      timestamp: DateTime.parse(json['created_at']),
      senderId: json['user_id'],
    );
  }
}
