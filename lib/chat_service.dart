import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprylife/models/message_model.dart';
  // Crie um modelo de mensagem para manipulação de dados

class ChatService {
  final String baseUrl = "http://seu-backend.com/api";  // Substitua pelo seu endpoint Laravel

  // Obter todas as mensagens de um chat
  Future<List<Message>> getMessages(String chatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/messages/$chatId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Message> messages = body.map((dynamic item) => Message.fromJson(item)).toList();
      return messages;
    } else {
      throw "Erro ao carregar mensagens";
    }
  }

  // Enviar uma nova mensagem
  Future<void> sendMessage(String chatId, String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({"chat_id": chatId, "message": text}),
    );

    if (response.statusCode != 201) {
      throw "Erro ao enviar mensagem";
    }
  }
}
