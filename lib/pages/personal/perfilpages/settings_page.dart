import 'package:flutter/material.dart';
import 'package:sprylife/pages/personal/perfilpages/notifications_page.dart';
import 'package:sprylife/pages/personal/perfilpages/senhas_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          iconSize: 24,
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Configurações de Notificações'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotificationSettingsPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Gerenciador de Senhas'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Excluir Conta'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to delete account page
            },
          ),
        ],
      ),
    );
  }
}
