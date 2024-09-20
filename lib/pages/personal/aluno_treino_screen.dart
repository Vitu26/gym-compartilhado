import 'package:flutter/material.dart';
import 'package:sprylife/pages/personal/criartreino/criar_treino.dart';
import 'package:sprylife/pages/personal/criartreino/rotinas_treino_personal.dart';
import 'package:sprylife/utils/colors.dart';

class AlunoTreinosScreen extends StatelessWidget {
  final Map<String, dynamic> alunoData;
  final List<Map<String, String>> treinos;

  AlunoTreinosScreen({
    required this.alunoData,
    required this.treinos,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Detalhes do Aluno/Treino'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            _buildHeader(),
            Divider(height: 1),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTreinoContent(),
                  _buildAerobicoContent(),
                ],
              ),
            ),
            _buildAddTreinoButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: Text(
              alunoData['nome']?[0] ?? '?', // Corrigido para garantir que a inicial do nome seja exibida
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alunoData['nome'] ?? 'Nome Indisponível', // Corrigido para exibir corretamente o nome
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                alunoData['status'] ?? 'Status Indisponível',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              Text(
                alunoData['location'] ?? 'Localização Indisponível',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: personalColor,
        tabs: [
          Tab(text: 'Rotina de treinos'),
          Tab(text: 'Aeróbico'),
        ],
      ),
    );
  }

  Widget _buildTreinoContent() {
    if (treinos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Você ainda não adicionou uma rotina de treino para este aluno!',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: treinos.length,
        itemBuilder: (context, index) {
          final treino = treinos[index];
          return ListTile(
            leading: Icon(Icons.fitness_center, color: personalColor, size: 30),
            title: Text(treino['nome'] ?? 'Treino'),
            subtitle: Text(treino['descricao'] ?? 'Descrição do treino'),
          );
        },
      );
    }
  }

  Widget _buildAerobicoContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Nenhuma rotina aeróbica cadastrada.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAddTreinoButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RotinasScreen(
                  personalId: alunoData['id'].toString(),
                  onRotinaSelected: (String rotinaDeTreinoId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CriarTreinoPersonal(
                          personalsId: alunoData['id'].toString(),
                          alunoId: alunoData['id'],
                          // rotinaDeTreinoId: int.parse(rotinaDeTreinoId),
                        ),
                      ),
                    );
                  }, alunoData: alunoData,
                ),
              ),
            );
          },
          child: Text('Adicionar rotina de treino',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: personalColor,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}