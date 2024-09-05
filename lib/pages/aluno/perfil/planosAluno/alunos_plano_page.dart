import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/alunosHasPlanos/aluno_has_plano_bloc.dart';
import 'package:sprylife/bloc/alunosHasPlanos/aluno_has_plano_event.dart';
import 'package:sprylife/bloc/alunosHasPlanos/aluno_has_plano_state.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/bloc/planos/planos_state.dart';
import 'package:sprylife/widgets/custom_appbar.dart';

class AlunoPlanosPage extends StatelessWidget {
  final String alunoId;

  AlunoPlanosPage({required this.alunoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Meus Planos',
      ),
      body: BlocProvider(
        create: (context) =>
            AlunoHasPlanoBloc()..add(FetchAlunosHasPlano(alunoId)),
        child: BlocBuilder<AlunoHasPlanoBloc, AlunoHasPlanoState>(
          builder: (context, alunoHasPlanoState) {
            print('Estado atual: $alunoHasPlanoState'); // Log do estado atual

            if (alunoHasPlanoState is AlunoHasPlanoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (alunoHasPlanoState is AlunoHasPlanoSuccess) {
              final planos = alunoHasPlanoState.data['data'];

              // Verifica se a lista de planos está vazia
              if (planos == null || planos.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum plano encontrado para o aluno. Fale com seu personal para cadastrar um plano.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // Para cada plano associado ao aluno
              return ListView.builder(
                itemCount: planos.length,
                itemBuilder: (context, index) {
                  final planoAssoc = planos[index];

                  if (planoAssoc == null || planoAssoc['plano_id'] == null) {
                    print('Plano não encontrado ou inválido');
                    return ListTile(
                      title: Text('Plano não encontrado'),
                    );
                  }

                  // Chamar o BLoC do plano para obter os detalhes com o `plano_id`
                  return BlocProvider(
                    create: (context) => PlanoBloc()
                      ..add(GetPlano(planoAssoc['plano_id'].toString())),
                    child: BlocBuilder<PlanoBloc, PlanoState>(
                      builder: (context, planoState) {
                        if (planoState is PlanoLoading) {
                          return ListTile(
                            title: Text('Carregando plano...'),
                          );
                        } else if (planoState is PlanoDetailLoaded) {
                          final planoData = planoState.data;
                          return ListTile(
                            title: Text(planoData['nome']), // Nome do plano
                            subtitle: Text(
                              'Criado em: ${planoData['created_at']}',
                            ), // Data de criação do plano
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalhesPlanoPage(
                                    planoData: planoData,
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (planoState is PlanoFailure) {
                          return ListTile(
                            title: Text('Erro ao carregar o plano'),
                          );
                        } else {
                          return ListTile(
                            title: Text('Plano não encontrado'),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            } else if (alunoHasPlanoState is AlunoHasPlanoFailure) {
              return Center(
                child: Text('Erro: ${alunoHasPlanoState.error}'),
              );
            } else {
              return Center(child: Text('Nenhum plano encontrado.'));
            }
          },
        ),
      ),
    );
  }
}

class DetalhesPlanoPage extends StatelessWidget {
  final Map<String, dynamic> planoData;

  DetalhesPlanoPage({required this.planoData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Plano'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${planoData['nome'] ?? 'Nome não disponível'}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
                'Descrição: ${planoData['descricao'] ?? 'Descrição não disponível'}'),
            SizedBox(height: 20),
            Text(
                'Data de Criação: ${planoData['created_at'] ?? 'Data não disponível'}'),
            SizedBox(height: 20),
            // Adicionar mais campos do plano, conforme necessário
          ],
        ),
      ),
    );
  }
}
