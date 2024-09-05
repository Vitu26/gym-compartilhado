import 'package:flutter/material.dart';
import 'package:sprylife/utils/colors.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool smsNotifications = true;
  bool whatsappNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Config de notificação'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildNotificationTile(
            context,
            icon: Icons.notifications,
            title: 'Notificações',
            value: notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          _buildNotificationTile(
            context,
            icon: Icons.email,
            title: 'Notificação via e-mail',
            value: emailNotifications,
            onChanged: (bool value) {
              setState(() {
                emailNotifications = value;
              });
            },
          ),
          _buildNotificationTile(
            context,
            icon: Icons.sms,
            title: 'Notificação via sms',
            value: smsNotifications,
            onChanged: (bool value) {
              setState(() {
                smsNotifications = value;
              });
            },
          ),
          _buildNotificationTile(
            context,
            icon: Icons.whatshot,
            title: 'Notificação via WhatsApp',
            value: whatsappNotifications,
            onChanged: (bool value) {
              setState(() {
                whatsappNotifications = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context,
      {required IconData icon,
      required String title,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: personalColor), // Use `secondary` instead of `leading`
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: personalColor,
    );
  }
}
