import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/pages/aluno/home_screen_aluno.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/complete_cadastro_aluno.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/gender.dart';
import 'package:sprylife/widgets/gradiente_button.dart';
import 'package:sprylife/widgets/progress_widget.dart';

class CadastroGeneroObjNivel extends StatefulWidget {
  final String email;
  final String phone;
  final String password;

  CadastroGeneroObjNivel({
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  _CadastroGeneroObjNivelState createState() => _CadastroGeneroObjNivelState();
}

class _CadastroGeneroObjNivelState extends State<CadastroGeneroObjNivel> {
  String? selectedGender;
  String? selectedObjective;
  String? selectedActivityLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: ProgressBar(currentStep: 3, totalSteps: 4, color: alunoCor),
      ),
      body: BlocListener<AlunoBloc, AlunoState>(
        listener: (context, state) {
          if (state is AlunoSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeAlunoScreen(
                        alunoData: state.data,
                        notifications: [],
                      )),
            );
          } else if (state is AlunoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Fale-nos sobre você!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                "Para oferecer uma experiência melhor, precisamos saber seu gênero.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildGenderOptions(),
              const SizedBox(height: 32),
              const Text(
                "Quais os seus Objetivos?",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              _buildObjectiveDropdown(),
              const SizedBox(height: 32),
              const Text(
                "Qual o seu nível de atividade física?",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              _buildActivityLevelDropdown(),
              const SizedBox(height: 32),
              GradientButton(
                text: "Próximo",
                onPressed: _canProceed()
                    ? () {
                        _navigateToNextScreen(context);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    return selectedGender != null &&
        selectedObjective != null &&
        selectedActivityLevel != null;
  }

  Widget _buildGenderOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenderOption(
              icon: Icons.male,
              label: "Masculino",
              isSelected: selectedGender == 'Masculino',
              onTap: () {
                setState(() {
                  selectedGender = 'Masculino';
                });
              },
            ),
            const SizedBox(width: 16),
            GenderOption(
              icon: Icons.female,
              label: "Feminino",
              isSelected: selectedGender == 'Feminino',
              onTap: () {
                setState(() {
                  selectedGender = 'Feminino';
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              selectedGender = 'Prefiro não informar';
            });
          },
          child: const Text(
            "Prefiro não informar",
            style: TextStyle(
                color: Colors.grey, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Widget _buildObjectiveDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedObjective,
      decoration: InputDecoration(
        labelText: "Objetivo",
        border: OutlineInputBorder(),
      ),
      items: [
        'Redução gordura/aumento massa muscular',
        'Condicionamento físico ou performance',
        'Aumento de massa muscular',
        'Redução de gordura',
        'Qualidade de vida',
        'Definição muscular',
      ].map((String objective) {
        return DropdownMenuItem<String>(
          value: objective,
          child: Text(objective),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedObjective = newValue;
        });
      },
    );
  }

  Widget _buildActivityLevelDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedActivityLevel,
      decoration: InputDecoration(
        labelText: "Nível de Atividade",
        border: OutlineInputBorder(),
      ),
      items: [
        "Iniciante",
        "Intermediário",
        "Avançado",
        "Atleta",
      ].map((String level) {
        return DropdownMenuItem<String>(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedActivityLevel = newValue;
        });
      },
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CompleteProfileScreen(
          selectedGender: selectedGender!,
          selectedObjective: selectedObjective!,
          selectedActivityLevel: selectedActivityLevel!,
          email: widget.email,
          phone: widget.phone,
          password: widget.password,
        ),
      ),
    );
  }
}
