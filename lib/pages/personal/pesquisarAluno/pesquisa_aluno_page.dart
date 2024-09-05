import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/pages/personal/alunoperfil/aluno_perfil_personal.dart';
import 'package:sprylife/utils/colors.dart';


class PesquisaAlunoPage extends StatefulWidget {
  @override
  _PesquisaAlunoPageState createState() => _PesquisaAlunoPageState();
}

class _PesquisaAlunoPageState extends State<PesquisaAlunoPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    context.read<AlunoBloc>().add(GetAllAlunos());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
              // Adiciona um círculo ao redor do ícone
              padding:
                  const EdgeInsets.all(0), // Remove o padding para centralizar o ícone
              constraints:
                  const BoxConstraints(), // Remove as restrições padrão para customização
              iconSize: 24, // Tamanho do ícone
            ),
            title: const Text(
              'Pesquisar Aluno',
              style: TextStyle(
                color: Colors.black, // Cor do texto
                fontSize: 16, // Tamanho da fonte
                fontWeight: FontWeight.w500, // Espessura da fonte
              ),
            ),
            actions: [],
            centerTitle: true,
          ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 16),
              _buildFilterButtons(),
              SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<AlunoBloc, AlunoState>(
                  builder: (context, state) {
                    if (state is AlunoLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is AlunoFailure) {
                      return Center(child: Text('Erro ao carregar alunos: ${state.error}'));
                    } else if (state is AlunoSuccess) {
                      final alunos = state.data;
      
                      // Aplica o filtro aos alunos
                      final filteredAlunos = alunos.where((aluno) {
                        if (_selectedFilter == 'Todos') return true;
                        return aluno['status'] == _selectedFilter;
                      }).toList();
      
                      if (filteredAlunos.isEmpty) {
                        return Center(child: Text('Nenhum aluno encontrado.'));
                      }
      
                      return ListView.builder(
                        itemCount: filteredAlunos.length,
                        itemBuilder: (context, index) {
                          final aluno = filteredAlunos[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(aluno['foto']),
                            ),
                            title: Text(aluno['nome'] ?? 'Nome não disponivel'),
                            subtitle: Text(aluno['informacoes_comuns']?['objetivo'] ?? 'Objetivo não disponível'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AlunoPerfilScreen(alunoData: aluno)));
                            },
                          );
                        },
                      );
                    }
      
                    return Center(child: Text('Algo deu errado.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Pesquisar por nome',
        prefixIcon: Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.red,),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    context.read<AlunoBloc>().add(GetAllAlunos()); // Recarrega os alunos ao limpar a pesquisa
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: (value) {
        // Recarrega os alunos com base na pesquisa
        context.read<AlunoBloc>().add(GetAllAlunos(searchQuery: value));
      },
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFilterButton('Todos'),
        const SizedBox(width: 15,),
        _buildFilterButton('Ativos'),
        const SizedBox(width: 15,),
        _buildFilterButton('Inativos'),
      ],
    );
  }

  Widget _buildFilterButton(String label) {
    final bool isSelected = _selectedFilter == label;

    return Container(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedFilter = label;
          });
          context.read<AlunoBloc>().add(GetAllAlunos()); // Atualiza a lista com o filtro selecionado
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black, backgroundColor: isSelected ? personalColor : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label, style: TextStyle(fontSize: 16),),
      ),
    );
  }
}
