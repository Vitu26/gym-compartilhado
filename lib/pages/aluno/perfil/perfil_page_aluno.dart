import 'package:flutter/material.dart';
import 'package:sprylife/pages/aluno/perfil/edit_user_aluno.dart';
import 'package:sprylife/pages/aluno/perfil/treinosAlunos/alunos_treino_page.dart';
import 'package:sprylife/pages/aluno/perfil/planosAluno/alunos_plano_page.dart';
import 'package:sprylife/pages/personal/perfilpages/central_de_ajuda.dart';
import 'package:sprylife/pages/personal/perfilpages/edit_user.dart';
import 'package:sprylife/pages/personal/perfilpages/meus_planos_page.dart';
import 'package:sprylife/pages/personal/perfilpages/meus_treinos_page.dart';
import 'package:sprylife/pages/personal/perfilpages/policita_de_privacidade_.dart';
import 'package:sprylife/pages/personal/perfilpages/settings_page.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';

class PerfilPageAluno extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, dynamic> alunoData;

  PerfilPageAluno({required this.navigatorKey, required this.alunoData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(title: 'Perfil'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.person,
              label: 'Seu Perfil',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        EditUserAlunoScreen(alunoData: alunoData)));
              },
            ),
            _buildMenuOption(
              icon: Icons.calendar_today,
              label: 'Meus Agendamentos',
              onTap: () {
                // Navegar para a tela de agendamentos
              },
            ),
            _buildMenuOption(
              icon: Icons.fitness_center,
              label: 'Meus Treinos',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AlunoTreinosPage(alunoId: alunoData['id'].toString()),
                  ),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.payment,
              label: 'Métodos de Pagamento',
              onTap: () {
                // Navegar para a tela de métodos de pagamento
              },
            ),
            _buildMenuOption(
              icon: Icons.payment,
              label: 'Meus Planos',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AlunoPlanosPage(
                          alunoId: alunoData['id'].toString(),
                        )));
              },
            ),
            _buildMenuOption(
              icon: Icons.subscriptions,
              label: 'Minhas Assinaturas',
              onTap: () {
                // Navegar para a tela de assinaturas
              },
            ),
            _buildMenuOption(
              icon: Icons.settings,
              label: 'Configurações',
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            _buildMenuOption(
              icon: Icons.help_center,
              label: 'Central de Ajuda',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HelpCenterPage()),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.privacy_tip,
              label: 'Política de Privacidade',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PrivacyPolicyPage()));
              },
            ),
            _buildMenuOption(
              icon: Icons.exit_to_app,
              label: 'Sair',
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(alunoData['foto'] ??
              'https://www.example.com/default-avatar.png'), // URL da foto do aluno
        ),
        const SizedBox(height: 10),
        Text(
          alunoData['nome'] ?? 'Nome não disponível',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          title: const Text('Sair'),
          content: const Text('Tem certeza que deseja sair?', style: TextStyle(fontSize: 16),),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey,fontSize: 14,)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Sim, Sair', style: TextStyle(fontSize: 14, color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: alunoCor,
              ),
              onPressed: () {
                // Executar logout e voltar para a tela de login
                Navigator.of(context).pop(); // Fechar o diálogo
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }
}
