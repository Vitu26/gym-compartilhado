import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprylife/bloc/turmas/tumas_bloc.dart';
import 'package:sprylife/pages/personal/chatpage/chatpage.dart';
import 'package:sprylife/pages/personal/groupes/groupes_page.dart';
import 'package:sprylife/pages/personal/home_page_parsonal.dart';
import 'package:sprylife/pages/personal/perfilpages/perfil_page.dart';
import 'package:sprylife/pages/personal/whatsapp/whatsapp_page.dart';
import 'package:sprylife/widgets/custom_navbar_item.dart';
import 'package:sprylife/models/model_tudo.dart';
import 'package:url_launcher/url_launcher.dart'; // Importando o pacote url_launcher

class NavBarPersonal extends StatefulWidget {
  final Map<String, dynamic> personalData;

  const NavBarPersonal({Key? key, required this.personalData}) : super(key: key);

  @override
  State<NavBarPersonal> createState() => _NavBarStatePersonal();
}

class _NavBarStatePersonal extends State<NavBarPersonal> {
  int _selectedIndex = 2;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Future<void> _openWhatsApp() async {
    final String phoneNumber = "5581999999999"; // Coloque o número de telefone desejado aqui
    final String message = "Olá, gostaria de conversar!"; // Mensagem desejada
    final String url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Certifique-se de que todos os campos obrigatórios estão presentes
    final Personal personal = Personal.fromJson(widget.personalData);

    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) => TurmaBloc(), // Criando o TurmaBloc aqui
        child: Scaffold(
          body: Stack(
            children: List.generate(5, (index) => _buildOffstageNavigator(index)),
          ),
          bottomNavigationBar: Container(
            height: 70,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomNavBarItem(
                  icon: FontAwesomeIcons.whatsapp,
                  label: 'Suporte',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    _openWhatsApp(); // Abre o WhatsApp com o número e mensagem
                    FocusScope.of(context).unfocus();
                  },
                ),
                CustomNavBarItem(
                  icon: FontAwesomeIcons.users,
                  label: 'Alunos',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    _onItemTapped(1);
                    FocusScope.of(context).unfocus();
                  },
                ),
                CustomNavBarItem(
                  icon: FontAwesomeIcons.home,
                  label: 'Home',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    _onItemTapped(2);
                    FocusScope.of(context).unfocus();
                  },
                ),
                CustomNavBarItem(
                  icon: FontAwesomeIcons.commentAlt,
                  label: 'Chat',
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    _onItemTapped(3);
                    FocusScope.of(context).unfocus();
                  },
                ),
                CustomNavBarItem(
                  icon: FontAwesomeIcons.user,
                  label: 'Perfil',
                  isSelected: _selectedIndex == 4,
                  onTap: () {
                    _onItemTapped(4);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    final Personal personal = Personal.fromJson(widget.personalData);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          switch (index) {
            case 0:
              return MaterialPageRoute(
                builder: (context) => WhatsApp(navigatorKey: _navigatorKeys[0]),
              );
            case 1:
              return MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: BlocProvider.of<TurmaBloc>(context),
                  child: TurmaListPage(
                    navigatorKey: _navigatorKeys[1],
                    personal: personal, // Passando o personal logado
                  ),
                ),
              );
            case 2:
              return MaterialPageRoute(
                builder: (context) =>
                    HomePersonalScreen(personalData: widget.personalData),
              );
            case 3:
              return MaterialPageRoute(
                builder: (context) => ChatListScreenPersonal(),
              );
            case 4:
              return MaterialPageRoute(
                builder: (context) => PerfilPage(
                  navigatorKey: _navigatorKeys[4],
                  personalData: widget.personalData,
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => PerfilPage(
                  navigatorKey: _navigatorKeys[4],
                  personalData: {
                    ...widget.personalData,
                    'id': widget.personalData['id'].toString(), // Certifique-se de que o ID está como String
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
