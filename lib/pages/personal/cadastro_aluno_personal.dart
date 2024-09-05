import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/informa%C3%A7%C3%B5es_comum/informacoes_comum_bloc.dart';
import 'package:sprylife/bloc/informa%C3%A7%C3%B5es_comum/informacoes_comum_event.dart';
import 'package:sprylife/bloc/informa%C3%A7%C3%B5es_comum/informacoes_comum_state.dart'; // Import do InformacoesComunsBloc
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/textfield.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sprylife/widgets/textfield_login.dart';

class CadastroAlunoPersonalScreen extends StatefulWidget {
  @override
  _CadastroAlunoPersonalScreenState createState() =>
      _CadastroAlunoPersonalScreenState();
}

class _CadastroAlunoPersonalScreenState
    extends State<CadastroAlunoPersonalScreen> {
  // Controladores de texto
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController nomeSocialController = TextEditingController(); // Adicionando nome social
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
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
    nomeSocialController.dispose(); // Dispose do nome social
    emailController.dispose();
    dataNascimentoController.dispose();
    whatsappController.dispose();
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomTextField(
                label: 'Nome',
                controller: nomeController,
              ),
              _buildCustomTextField(
                label: 'Nome Social', // Campo para nome social
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
              _buildCustomTextField(
                label: 'WhatsApp',
                controller: whatsappController,
                keyboardType: TextInputType.phone,
                inputFormatters: [maskFormatterTelefone],
              ),
              _buildDropdownField(
                label: 'Gênero',
                items: {
                  'Masculino': 'Masculino',
                  'Feminino': 'Feminino',
                  'Não Informar': 'Não Informar'
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
                  '1': 'Redução de gordura e aumento da massa muscular',
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
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width -
                32), // Ajuste a largura do dropdown
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

void _cadastrarAluno(BuildContext context) {
  final informacoesComunsData = {
    'sexo': genero,
    'data-de-nascimento': DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(dataNascimentoController.text),
    ),
    'objetivo_id': objetivoId,
    'nivel-atividade_id': nivelAtividadeId,
    'modalidade-aluno_id': modalidadeAlunoId,
    'numero_telefone': telefoneController.text.replaceAll(RegExp(r'\D'), ''),
  };



    // Disparando evento para criar as informações comuns
    context.read<InformacoesComunsBloc>().add(CreateInformacoesComuns(informacoesComunsData));

    // Escutando o estado do InformacoesComunsBloc
    BlocListener<InformacoesComunsBloc, InformacoesComunsState>(
      listener: (context, state) {
        if (state is InformacoesComunsCreated) {
          // Se as informações comuns foram criadas com sucesso, agora criamos o aluno
          final alunoData = {
            'nome': nomeController.text,
            'nome_social': nomeSocialController.text,
            'email': emailController.text,
            'password': senhaController.text,
            'informacoes-comuns_id': state.id,  // Usar o ID retornado
          };

          context.read<AlunoBloc>().add(AlunoCadastro(alunoData));
        } else if (state is InformacoesComunsError) {
          // Exibir erro de criação das informações comuns
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar as informações comuns: ${state.error}')),
          );
        }
      },
    );
  }
}
