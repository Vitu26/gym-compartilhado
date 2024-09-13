import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/widgets/bottom_navigator_aluno.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String email;
  final String phone;
  final String password;
  final String selectedGender;
  final String selectedObjective;
  final String selectedActivityLevel;

  const CompleteProfileScreen({
    required this.email,
    required this.phone,
    required this.password,
    required this.selectedGender,
    required this.selectedObjective,
    required this.selectedActivityLevel,
  });

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController socialNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocListener<AlunoBloc, AlunoState>(
        listener: (context, state) {
          if (state is AlunoSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavBarAluno(alunoData: state.data),
              ),
            );
          } else if (state is AlunoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Complete seu Perfil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Por favor, complete as informações abaixo para finalizar o cadastro.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: socialNameController,
                decoration: InputDecoration(
                  labelText: 'Nome Social',
                  border: OutlineInputBorder(),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: dobController,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  ),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dobController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} 00:00:00";
                      });
                    }
                  }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child:
                    const Text('Salvar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    final String nome = nameController.text;
    final String nomeSocial = socialNameController.text;
    final String dataNascimento = dobController.text;

    if (nome.isEmpty || nomeSocial.isEmpty || dataNascimento.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    final Map<String, dynamic> alunoData = {
      'nome': nome,
      'email': widget.email,
      'password': widget.password,
      'nome_social': nomeSocial,
      'informacoes-comuns': {
        'sexo': _mapSexoToString(widget.selectedGender),
        'data-de-nascimento': _formatarData(
            dobController.text),
        'objetivo_id': _mapObjetivoToId(
            widget.selectedObjective),
        'nivel-atividade_id': _mapNivelAtividadeToId(
            widget.selectedActivityLevel),
        'modalidade-aluno_id': "1",
        'numero_telefone':
            widget.phone
      },
    };
    context.read<AlunoBloc>().add(AlunoCadastro(alunoData));
  }

  String _mapSexoToString(String genero) {
    switch (genero) {
      case 'Masculino':
        return 'masculino';
      case 'Feminino':
        return 'feminino';
      default:
        return 'outro';
    }
  }

  String _mapObjetivoToId(String objetivo) {
    switch (objetivo) {
      case 'Redução de gordura e aumento da massa muscular':
        return '1';
      case 'Condicionamento físico ou performance':
        return '2';
      case 'Aumento de massa Musicar':
        return '3';
      case 'Redução de gordura':
        return '4';
      case 'Qualidade de vida':
        return '5';
      case 'Definição muscular':
        return '6';
      default:
        return '0';
    }
  }

  String _formatarData(String dataOriginal) {
    final DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(dataOriginal);
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(parsedDate);
  }

  String _mapNivelAtividadeToId(String nivelAtividade) {
    switch (nivelAtividade) {
      case 'Iniciante':
        return '1';
      case 'Intermediário':
        return '2';
      case 'Avançado':
        return '3';
      case 'Atleta':
        return '4';
      default:
        return '0';
    }
  }
}
