import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprylife/pages/aluno/chat/chat_interface.dart';
import 'package:sprylife/pages/aluno/chat/chat_list.dart';
import 'package:sprylife/pages/aluno/favoritos/favoritos_screen.dart';
import 'package:sprylife/pages/aluno/home_screen_aluno.dart';
import 'package:sprylife/pages/aluno/perfil/perfil_page_aluno.dart';
import 'package:sprylife/pages/aluno/pesquisarPersonal/pesquisar_personal.dart';
import 'package:sprylife/pages/personal/alunoperfil/aluno_perfil_personal.dart';
import 'package:sprylife/pages/personal/chatpage/chatpage.dart';
import 'package:sprylife/pages/personal/groupes/groupes_page.dart';
import 'package:sprylife/pages/personal/home_page_parsonal.dart';
import 'package:sprylife/pages/personal/perfilpages/perfil_page.dart';
import 'package:sprylife/pages/personal/whatsapp/whatsapp_page.dart';
import 'package:sprylife/pages/pesquisar/filter_screen.dart';
import 'package:sprylife/widgets/custom_navbar_item.dart';
import 'package:sprylife/widgets/custom_navbar_item_aluno.dart';

class NavBarAluno extends StatefulWidget {
  final Map<String, dynamic> alunoData; // Adicionando o parâmetro ao construtor

  const NavBarAluno({Key? key, required this.alunoData})
      : super(key: key); // Definindo o construtor

  @override
  State<NavBarAluno> createState() => _NavBarStateAluno();
}

class _NavBarStateAluno extends State<NavBarAluno> {
  int _selectedIndex = 2; // Default to the Home screen in the middle

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

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          switch (index) {
            case 0:
              return MaterialPageRoute(
                  builder: (context) => PesquisarPersonal());
            case 1:
              return MaterialPageRoute(
                builder: (context) => FavoritosScreen(),
              );

            case 2:
              return MaterialPageRoute(
                  builder: (context) => HomeAlunoScreen(
                      alunoData: widget.alunoData)); // Usando o personalData
            case 3:
              return MaterialPageRoute(builder: (context) => ChatListScreen());
            case 4:
              return MaterialPageRoute(
                  builder: (context) => PerfilPageAluno(
                        alunoData: widget.alunoData,
                        navigatorKey: _navigatorKeys[4],
                      )); // Usando o personalData
            default:
              return MaterialPageRoute(
                  builder: (context) => HomeAlunoScreen(
                      alunoData: widget.alunoData)); // Usando o personalData
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey[200],
            body: Stack(
              children:
                  List.generate(5, (index) => _buildOffstageNavigator(index)),
            ),
            bottomNavigationBar: Container(
              height: 70,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomNavBarItemAluno(
                    icon: FontAwesomeIcons.searchengin,
                    label: 'Pesquisar',
                    isSelected: _selectedIndex == 0,
                    onTap: () {
                      _onItemTapped(0);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  CustomNavBarItemAluno(
                    icon: FontAwesomeIcons.users,
                    label: 'Favoritos',
                    isSelected: _selectedIndex == 1,
                    onTap: () {
                      _onItemTapped(1);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  CustomNavBarItemAluno(
                    icon: FontAwesomeIcons.home,
                    label: 'Home',
                    isSelected: _selectedIndex == 2,
                    onTap: () {
                      _onItemTapped(2);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  CustomNavBarItemAluno(
                    icon: FontAwesomeIcons.commentAlt,
                    label: 'Chat',
                    isSelected: _selectedIndex == 3,
                    onTap: () {
                      _onItemTapped(3);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  CustomNavBarItemAluno(
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
        ],
      ),
    );
  }
}
