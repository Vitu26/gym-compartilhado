import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications;

  NotificationScreen({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Notificações',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  '${notifications.where((notification) => notification['status'] == 'new').length} NOVAS',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'HOJE',
            style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          ...notifications
              .where((notification) => notification['day'] == 'today')
              .map((notification) => _buildNotificationTile(notification))
              .toList(),
          const SizedBox(height: 16),
          const Text(
            'ONTEM',
            style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          ...notifications
              .where((notification) => notification['day'] == 'yesterday')
              .map((notification) => _buildNotificationTile(notification))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, String> notification) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(notification['title']!),
      subtitle: Text(notification['subtitle']!),
      trailing: Text(notification['time']!, style: TextStyle(color: Colors.grey)),
      onTap: () {
        // Marcar como lida ou realizar outra ação
      },
    );
  }
}
