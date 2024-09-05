import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';

class RealTimeChatScreen extends StatefulWidget {
  final String chatId;

  RealTimeChatScreen({required this.chatId});

  @override
  _RealTimeChatScreenState createState() => _RealTimeChatScreenState();
}

class _RealTimeChatScreenState extends State<RealTimeChatScreen> {
  late PusherClient pusher;
  late Channel channel;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();

    pusher = PusherClient(
      "YOUR_PUSHER_APP_KEY",
      PusherOptions(cluster: "YOUR_PUSHER_CLUSTER"),
      enableLogging: true,
    );

    channel = pusher.subscribe("chat.${widget.chatId}");

    channel.bind('MessageSent', (event) {
      final data = event?.data;
      if (data != null) {
        setState(() {
          messages.add(data);
        });
      }
    });

    pusher.connect();
  }

  @override
  void dispose() {
    pusher.unsubscribe("chat.${widget.chatId}");
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat em Tempo Real'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index]),
          );
        },
      ),
    );
  }
}
