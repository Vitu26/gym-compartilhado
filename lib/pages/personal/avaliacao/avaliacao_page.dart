import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/avaliacao/avaliacao_bloc.dart';
import 'package:sprylife/bloc/avaliacao/avaliacao_event.dart';
import 'package:sprylife/bloc/avaliacao/avaliacao_state.dart';
import 'package:sprylife/models/model_tudo.dart';
import 'package:sprylife/widgets/custom_appbar.dart';

class AvaliacaoPage extends StatelessWidget {
  static const String routeName = '/avaliacaoPage';
  final Map<String, dynamic> personalData;

  const AvaliacaoPage({super.key, required this.personalData});

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
      appBar: CustomAppBar(
        centerTitle: true,
        title: "Avaliações",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(personal),
            const SizedBox(height: 20),
            _buildReviewsTab(context, personal),
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
        if (personal.seguidores > 0) // Exibe os seguidores somente se > 0
          Positioned(
            top: 200,
            left: 16,
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const Text("4.7", style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                const CircleAvatar(
                  backgroundImage:
                      NetworkImage("https://via.placeholder.com/50"),
                  radius: 15,
                ),
                const SizedBox(width: 8),
                Text(
                  "Você e ${personal.seguidores} seguidores",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
      ],
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
              return const Center(
                  child: Text("Você ainda não tem avaliações."));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.avaliacoes.length,
              itemBuilder: (context, index) {
                final comentario = state.avaliacoes[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    comentario.autor,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStars(comentario.nota),
                      const SizedBox(height: 8),
                      Text(comentario.comentario),
                    ],
                  ),
                );
              },
            );
          } else if (state is AvaliacaoError) {
            return Center(child: Text('Erro: ${state.message}'));
          } else {
            return const Center(child: Text('Erro ao carregar avaliações'));
          }
        },
      ),
    );
  }

  // Função para exibir as estrelas de avaliação
  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.orange,
        );
      }),
    );
  }
}
