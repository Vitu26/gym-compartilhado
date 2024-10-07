import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_bloc.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_event.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_event.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_state.dart';
import 'package:sprylife/pages/personal/criartreino/rotinas_treino_personal.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/utils/token_storege.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/textfield.dart';
import 'package:http/http.dart' as http;

class CriarTreinoPersonal extends StatefulWidget {
  final String personalsId;
  final String alunoId;

  CriarTreinoPersonal({required this.personalsId, required this.alunoId});

  @override
  _CriarTreinoPersonalState createState() => _CriarTreinoPersonalState();
}

class _CriarTreinoPersonalState extends State<CriarTreinoPersonal> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();
  List<String> _selectedObjectives = [];
  String? _selectedDifficulty;
  DateTime? _startDate;
  DateTime? _endDate;
  int _selectedTipoIndex = 0;
  bool _permitirDownload = false;

  final Map<String, int> _difficultyMap = {
    'Adaptação': 1,
    'Iniciante': 2,
    'Intermediário': 3,
    'Avançado': 4,
  };

  @override
  void dispose() {
    _nomeController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  Future<String?> getSavedPersonalId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('personal_id');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
          ),
          title: const Text(
            'CRIAR ROTINA DE TREINO',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nome do treino:', style: TextStyle(fontSize: 20)),
              _buildTextField('', _nomeController),
              const SizedBox(height: 20),
              const Text('Tipo de treino:', style: TextStyle(fontSize: 20)),
              _buildTipoTreino(),
              const SizedBox(height: 20),
              const Text('Início - Fim', style: TextStyle(fontSize: 20)),
              _buildDatePickers(),
              const SizedBox(height: 20),
              const Text('Objetivos:', style: TextStyle(fontSize: 20)),
              _buildObjetivoChips(),
              const SizedBox(height: 20),
              const Text('Dificuldade', style: TextStyle(fontSize: 20)),
              _buildDificuldadeChips(),
              const SizedBox(height: 20),
              const Text('Observações:', style: TextStyle(fontSize: 20)),
              _buildObservacoes(),
              const SizedBox(height: 20),
              _buildPermissaoTreino(),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Salvar',
                backgroundColor: personalColor,
                onPressed: () {
                  _createTreinoAndAssociate(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFieldLC(
      controller: controller,
      obscureText: false,
      maxLines: 1,
    );
  }

  Widget _buildTipoTreino() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTipoTreinoButton('Semanal', 0),
            const SizedBox(width: 8),
            _buildTipoTreinoButton('Numérico', 1),
          ],
        ),
      ],
    );
  }

  Widget _buildTipoTreinoButton(String label, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTipoIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor:
            _selectedTipoIndex == index ? Colors.white : Colors.black,
        backgroundColor:
            _selectedTipoIndex == index ? personalColor : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(120, 40),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildDatePickers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDatePicker('Início', _startDate, (date) {
          setState(() {
            _startDate = date;
          });
        }),
        _buildDatePicker('Fim', _endDate, (date) {
          setState(() {
            _endDate = date;
          });
        }),
      ],
    );
  }

  Widget _buildDatePicker(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) onDateSelected(picked);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: personalColor,
            backgroundColor: Colors.white,
            side: const BorderSide(color: personalColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            selectedDate == null
                ? 'Selecionar data'
                : DateFormat('dd/MM/yyyy').format(selectedDate),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildObjetivoChips() {
    List<String> objetivos = [
      'Redução de gordura/ganho de massa',
      'Redução de gordura',
      'Aumento de massa muscular',
      'Condicionamento físico ou performance',
      'Saúde',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: objetivos.map((String objetivo) {
            return FilterChip(
              label: Text(objetivo),
              selected: _selectedObjectives.contains(objetivo),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedObjectives.add(objetivo);
                  } else {
                    _selectedObjectives.remove(objetivo);
                  }
                });
              },
              selectedColor: personalColor,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                fontSize: 18,
                color: _selectedObjectives.contains(objetivo)
                    ? Colors.white
                    : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDificuldadeChips() {
    List<String> dificuldades = [
      'Adaptação',
      'Iniciante',
      'Intermediário',
      'Avançado',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: dificuldades.map((String dificuldade) {
            return ChoiceChip(
              label: Text(dificuldade),
              selected: _selectedDifficulty == dificuldade,
              onSelected: (bool selected) {
                setState(() {
                  _selectedDifficulty = selected ? dificuldade : null;
                });
              },
              selectedColor: personalColor,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                fontSize: 18,
                color: _selectedDifficulty == dificuldade
                    ? Colors.white
                    : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildObservacoes() {
    return TextFieldLC(
      controller: _obsController,
      obscureText: false,
    );
  }

  Widget _buildPermissaoTreino() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Permitir que o aluno faça o treino em casa?'),
        Switch(
          value: _permitirDownload,
          onChanged: (bool value) {
            setState(() {
              _permitirDownload = value;
            });
          },
        ),
      ],
    );
  }

  void _createTreinoAndAssociate(BuildContext context) async {
    final nome = _nomeController.text;

    // Verificação dos campos obrigatórios
    if (nome.isNotEmpty &&
        _selectedDifficulty != null &&
        _startDate != null &&
        _endDate != null) {
      final personalId = await getSavedPersonalId();
      if (personalId == null) {
        debugPrint('Erro: ID do personal não encontrado.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: ID do personal não encontrado.')),
        );
        return;
      }

      final dificuldadeId = _difficultyMap[_selectedDifficulty];

      if (dificuldadeId == null) {
        debugPrint('Erro: Dificuldade inválida selecionada.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro: Dificuldade inválida selecionada.')),
        );
        return;
      }

      // Verificação do valor do Switch (baixar-treino)
      String baixarTreinoValue = _permitirDownload
          ? "1"
          : "0"; // Garantindo que sempre tenha um valor válido

      // Verificar se o valor de baixar-treino está correto
      debugPrint('Valor de baixar-treino: $baixarTreinoValue');

      // Dados da rotina de treino
      final rotinaData = {
        "data-fim": DateFormat('yyyy-MM-dd').format(_endDate!),
        "data-inicio": DateFormat('yyyy-MM-dd').format(_startDate!),
        "observacoes": _obsController.text,
        "baixar-treino":
            baixarTreinoValue, // Aqui garantimos que o valor não seja null
        "tipo-treino_id": _selectedTipoIndex == 0 ? "1" : "2",
        "objetivo_id": "1",
        "personal_id": personalId,
        "nivel-atividade_id": dificuldadeId.toString(),
      };

      final rotinaBloc = context.read<RotinaDeTreinoBloc>();
      rotinaBloc.add(CreateRotinaDeTreino(rotinaData));

      rotinaBloc.stream.listen((state) async {
        if (state is RotinaDeTreinoSuccess && state.rotinaDeTreinoId != null) {
          final rotinaDeTreinoId = state.rotinaDeTreinoId!;
          debugPrint(
              'Rotina de treino criada com sucesso. ID: $rotinaDeTreinoId');

          // Associando a rotina ao aluno
          await _associateRoutineToStudent(rotinaDeTreinoId);

          // *** Adicionando um delay para garantir que a API processe a associação ***
          await Future.delayed(const Duration(seconds: 2));

          // Verificar rotinas após a associação
          try {
            final rotinas =
                await fetchAlunoHasRotinas(int.parse(widget.alunoId));
            if (rotinas.isEmpty) {
              debugPrint(
                  'Nenhuma rotina associada encontrada após a associação.');
            } else {
              debugPrint('Rotinas associadas encontradas: $rotinas');
            }

            // Após criar e associar a rotina, redireciona para a tela de rotinas
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RotinasScreen(
                  personalId: personalId,
                  onRotinaSelected: (rotinaId) {},
                  alunoData: {'id': widget.alunoId},
                ),
              ),
            );
          } catch (e) {
            debugPrint('Erro ao verificar rotinas associadas: $e');
          }
        } else if (state is RotinaDeTreinoFailure) {
          debugPrint('Erro ao criar rotina de treino: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Erro ao criar rotina de treino: ${state.error}')),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, preencha todos os campos obrigatórios')),
      );
    }
  }

// Função para associar a rotina ao aluno
  Future<void> _associateRoutineToStudent(int rotinaDeTreinoId) async {
    final associacaoData = {
      "aluno_id": int.parse(widget.alunoId), // Convertendo para int aqui
      "rotina-de-treino_id": rotinaDeTreinoId,
    };

    print(
        'Associando rotina de treino ID: $rotinaDeTreinoId com aluno ID: ${widget.alunoId}');

    if (mounted) {
      context
          .read<AlunoHasRotinaBloc>()
          .add(CreateAlunoHasRotina(associacaoData));
    }
  }

  Future<List<dynamic>> fetchAlunoHasRotinas(int alunoId) async {
    final token = await getToken(); // Pega o token de autenticação
    final response = await http.get(
      Uri.parse('https://developerxpb.com.br/api/alunos-has-rotinas/$alunoId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('Rotinas de treino recebidas: $data');

      // Verificar se o campo 'data' é null e retornar uma lista vazia caso seja
      if (data['data'] == null) {
        debugPrint('Nenhuma rotina de treino encontrada.');
        return []; // Retorna uma lista vazia
      } else {
        return data['data']; // Retorna as rotinas se houver dados
      }
    } else {
      debugPrint('Erro ao carregar rotinas: ${response.statusCode}');
      throw Exception('Erro ao carregar rotinas de treino');
    }
  }
}
