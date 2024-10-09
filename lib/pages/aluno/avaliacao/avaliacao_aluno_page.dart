import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/avaliacao/avaliacao_bloc.dart';
import 'package:sprylife/bloc/avaliacao/avaliacao_event.dart';
import 'package:sprylife/bloc/avaliacao/avaliacao_state.dart';
import 'package:sprylife/models/model_tudo.dart';

class AvaliacaoAlunoPage extends StatelessWidget {
  static const String routeName = '/avaliacaoPage';
  final Map<String, dynamic> personalData;

  const AvaliacaoAlunoPage({super.key, required this.personalData});

  @override
  Widget build(BuildContext context) {
    // Garantir que `personalData` não seja nulo antes de continuar
    if (personalData.isEmpty) {
      return const Center(
        child: Text('Erro: Dados do personal estão ausentes.'),
      );
    }

    final personal = Personal.fromJson(personalData);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trainer Profile Workouts",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(personal),
            _buildTabs(context, personal),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Personal personal) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  personal.foto ?? 'https://via.placeholder.com/150'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 160,
          left: 16,
          child: Text(
            personal.nome,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: 16,
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.orange),
              const Text("4.7", style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundImage: NetworkImage("https://via.placeholder.com/50"),
                radius: 15,
              ),
              const SizedBox(width: 8),
              const Text("Você e 29 seguidores",
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        Positioned(
          top: 160,
          right: 16,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Seguir"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, Personal personal) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Sobre'),
              Tab(text: 'Treinos'),
              Tab(text: 'Reviews'),
            ],
          ),
          Container(
            height: 400,
            child: TabBarView(
              children: [
                _buildSobreTab(personal),
                _buildTreinosTab(personal),
                _buildReviewsTab(context, personal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSobreTab(Personal personal) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(personal.tipoAtendimento),
    );
  }

  Widget _buildTreinosTab(Personal personal) {
    final List<Map<String, dynamic>> treinos = personal.treinos
        .map((treino) => treino.toJson())
        .toList(); // Acessa a lista de treinos a partir do personalData

    if (treinos.isEmpty) {
      return const Center(child: Text("Nenhum treino disponível"));
    }

    return ListView.builder(
      itemCount: treinos.length,
      itemBuilder: (context, index) {
        final treino = treinos[index];
        return ListTile(
          leading: Image.network(
              treino['imagem'] ?? 'https://via.placeholder.com/50'),
          title: Text(treino['titulo']),
          subtitle: Text('${treino['nivel']} • ${treino['duracao']} min'),
        );
      },
    );
  }

  Widget _buildReviewsTab(BuildContext context, Personal personal) {
    return BlocProvider(
      create: (_) =>
          AvaliacaoBloc()..add(FetchAvaliacoes(personalId: personal.id)),
      child: BlocBuilder<AvaliacaoBloc, AvaliacaoState>(
        builder: (context, state) {
          if (state is AvaliacaoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AvaliacaoLoaded) {
            if (state.avaliacoes.isEmpty) {
              return const Center(child: Text("Nenhuma avaliação disponível"));
            }

            return ListView.builder(
              itemCount: state.avaliacoes.length,
              itemBuilder: (context, index) {
                final comentario = state.avaliacoes[index];
                return ListTile(
                  title: Text(comentario.autor),
                  subtitle: Text(comentario.comentario),
                  trailing: Text(comentario.nota.toString()),
                );
              },
            );
          } else {
            return const Center(child: Text('Erro ao carregar avaliações'));
          }
        },
      ),
    );
  }
}
