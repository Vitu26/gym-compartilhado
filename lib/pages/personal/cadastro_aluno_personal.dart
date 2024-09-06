import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/informa%C3%A7%C3%B5es_comum/informacoes_comum_bloc.dart';
import 'package:sprylife/bloc/informa%C3%A7%C3%B5es_comum/informacoes_comum_event.dart';
import 'package:sprylife/bloc/informa%C3%A7%C3%B5es_comum/informacoes_comum_state.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/bloc/turmas/tumas_bloc.dart';
import 'package:sprylife/bloc/turmas/turma_event.dart';
import 'package:sprylife/bloc/turmas/turma_state.dart';
import 'package:sprylife/models/model_tudo.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/utils/token_storege.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/textfield.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sprylife/widgets/textfield_login.dart';
import 'package:http/http.dart' as http;

class CadastroAlunoPersonalScreen extends StatefulWidget {
  @override
  _CadastroAlunoPersonalScreenState createState() =>
      _CadastroAlunoPersonalScreenState();
}

class _CadastroAlunoPersonalScreenState
    extends State<CadastroAlunoPersonalScreen> {
  // Controladores de texto
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController nomeSocialController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  String? genero;
  int? objetivoId;
  int? nivelAtividadeId;
  int? modalidadeAlunoId;
  String? tipoTelefone = 'celular';

  // Máscaras de entrada de dados
  final maskFormatterTelefone = MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});
  final maskFormatterDataNascimento = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {
    nomeController.dispose();
    nomeSocialController.dispose();
    emailController.dispose();
    dataNascimentoController.dispose();
    senhaController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Cadastrar Aluno',
        ),
        body: BlocConsumer<InformacoesComunsBloc, InformacoesComunsState>(
          listener: (context, state) {
            if (state is InformacoesComunsCreated) {
              final alunoData = {
                'nome': nomeController.text,
                'nome_social': nomeSocialController.text,
                'email': emailController.text,
                'password': senhaController.text,
                'informacoes-comuns_id': state.id,
              };
              // Disparando o evento de cadastro de aluno
              context.read<AlunoBloc>().add(AlunoCadastro(alunoData));
            } else if (state is InformacoesComunsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Erro ao criar as informações comuns: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is InformacoesComunsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomTextField(
                    label: 'Nome',
                    controller: nomeController,
                  ),
                  _buildCustomTextField(
                    label: 'Nome Social',
                    controller: nomeSocialController,
                  ),
                  _buildCustomTextField(
                    label: 'E-mail',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildCustomTextField(
                    label: 'Senha',
                    controller: senhaController,
                    obscureText: true,
                  ),
                  _buildCustomTextField(
                    label: 'Data de nascimento',
                    controller: dataNascimentoController,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [maskFormatterDataNascimento],
                  ),
                  _buildDropdownField(
                    label: 'Gênero',
                    items: {
                      'Masculino': 'Masculino',
                      'Feminino': 'Feminino',
                      'Não Informar': 'Não Informar',
                    },
                    onChanged: (value) {
                      setState(() {
                        genero = value;
                      });
                    },
                  ),
                  _buildDropdownField(
                    label: 'Objetivo',
                    items: {
                      '1': 'Redução gordura/aumento massa muscular',
                      '2': 'Condicionamento físico ou performance',
                      '3': 'Aumento da massa muscular',
                      '4': 'Redução de gordura',
                      '5': 'Qualidade de vida & saúde',
                      '6': 'Definição muscular',
                    },
                    onChanged: (value) {
                      setState(() {
                        objetivoId = int.tryParse(value!);
                      });
                    },
                  ),
                  _buildDropdownField(
                    label: 'Nível de Atividade',
                    items: {
                      '1': 'Iniciante',
                      '2': 'Intermediário',
                      '3': 'Avançado',
                      '4': 'Altamente Treinado',
                      '5': 'Atleta',
                    },
                    onChanged: (value) {
                      setState(() {
                        nivelAtividadeId = int.tryParse(value!);
                      });
                    },
                  ),
                  _buildDropdownField(
                    label: 'Modalidade',
                    items: {
                      '1': 'Musculação',
                      '2': 'Funcional',
                      '3': 'Pilates',
                      '4': 'Corrida',
                      '5': 'Luta',
                      '6': 'Dança',
                      '7': 'Natação',
                    },
                    onChanged: (value) {
                      setState(() {
                        modalidadeAlunoId = int.tryParse(value!);
                      });
                    },
                  ),
                  _buildCustomTextField(
                    label: 'Telefone',
                    controller: telefoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [maskFormatterTelefone],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      text: 'Salvar',
                      backgroundColor: personalColor,
                      onPressed: () => _cadastrarAluno(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFieldLogin(
        controller: controller,
        obscureText: obscureText,
        hintText: label,
        keyboardType: keyboardType,
        fillColor: const Color(0xFFF4F6F9),
      ),
    );
  }

  _buildDropdownField({
    required String label,
    required Map<String, String> items,
    required Function(String?) onChanged,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF4F6F9),
          ),
          items: items.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value,
                  style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFFF4F6F9),
          iconEnabledColor: Colors.grey,
        ),
      ),
    );
  }

  void _checkOrCreateAtivosGroup(BuildContext context, int alunoId) {
    // Check if the "Ativos" turma exists
    context.read<TurmaBloc>().add(CheckTurmaExists('Ativos'));

    BlocListener<TurmaBloc, TurmaState>(
      listener: (context, state) {
        if (state is TurmaFound) {
          // If the "Ativos" turma exists, add the student to it
          context.read<TurmaBloc>().add(AddStudentToTurma(state.turma.id, alunoId));
        } else if (state is TurmaNotFound) {
          // If the "Ativos" turma does not exist, create it
          final personalState = context.read<PersonalBloc>().state;
          if (personalState is PersonalSuccess) {
            final personalId = personalState.data['id']; // Personal ID fetched from bloc
            final turmaData = {
              'nome': 'Ativos',
              'personal_id': personalId.toString(),
            };
            context.read<TurmaBloc>().add(CreateTurma(turmaData));
          } else {
            print('Personal data is not available.');
          }
        } else if (state is TurmaCreated) {
          // Once the turma is created, add the student to it
          context.read<TurmaBloc>().add(AddStudentToTurma(state.turma.id, alunoId));
        }
      },
    );
  }

  void _cadastrarAluno(BuildContext context) {
    final informacoesComunsData = {
      'sexo': genero,
      'data-de-nascimento': DateFormat('yyyy-MM-dd').format(
        DateFormat('dd/MM/yyyy').parse(dataNascimentoController.text),
      ),
      'objetivo_id': objetivoId,
      'nivel-atividade_id': nivelAtividadeId,
      'modalidade-aluno_id': modalidadeAlunoId,
      'table': 'alunos',
      'reference_id': '',
      'telefone': {
        'numero': telefoneController.text.replaceAll(RegExp(r'\D'), ''),
        'tipo': tipoTelefone ?? 'celular',
      }
    };

    // Create the common information
    context
        .read<InformacoesComunsBloc>()
        .add(CreateInformacoesComuns(informacoesComunsData));

    BlocListener<InformacoesComunsBloc, InformacoesComunsState>(
      listener: (context, state) {
        if (state is InformacoesComunsCreated) {
          // Once common information is created, register the student
          final alunoData = {
            'nome': nomeController.text,
            'nome_social': nomeSocialController.text,
            'email': emailController.text,
            'password': senhaController.text,
            'informacoes-comuns_id': state.id,
          };

          // Dispatch the student registration event
          context.read<AlunoBloc>().add(AlunoCadastro(alunoData));

          // Check if "Ativos" group exists, and add student to it
          _checkOrCreateAtivosGroup(context, state.id);
        }
      },
    );
  }
}
