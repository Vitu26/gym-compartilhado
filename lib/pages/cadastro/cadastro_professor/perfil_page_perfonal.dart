import 'package:flutter/material.dart';
import 'package:perfil_professor/components/button.dart';
import 'package:perfil_professor/components/custom_container.dart';
import 'package:perfil_professor/components/gender_option.dart';
import 'package:perfil_professor/components/gender_selections.dart';
import 'package:perfil_professor/components/modalities.dart';
import 'package:perfil_professor/components/progress_bar.dart';
import 'package:perfil_professor/pages/perfil_page.dart';
import 'package:perfil_professor/components/colors.dart';

class ProfessorPage extends StatefulWidget {
  const ProfessorPage({super.key});

  @override
  State<ProfessorPage> createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  int? selectedIndex;
  String? selectedGender;
  List<String> selectedModalities = [];
  String? genderSelected;

  List<String> modalities = [
    'Modalidade 1',
    'Modalidade 2',
    'Modalidade 3',
    'Modalidade 4',
    'Modalidade 5',
    'Modalidade 6',
    'Modalidade 7',
  ];

  void onSelectionChanged(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        // Nutricionista selected, hide modality options
        selectedModalities.clear();
      }
      selectedGender = null; // Clear gender selection when switching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomAppBar(),
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        title: const ProgressBar(currentStep: 1, totalSteps: 4),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Preencha seu Perfil na SpryLife',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              'Primeiro nos Informe sua Formação Acadêmica',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomContainer(
                    text: 'Profissional de Educação Física',
                    borderColor: personalColor,
                    imagePath: 'assets/images/professor.png',
                    index: 1,
                    isSelected: selectedIndex == 1,
                    onSelectionChanged: onSelectionChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomContainer(
                    text: 'Nutricionista',
                    borderColor: personalColor,
                    imagePath: 'assets/images/nutri.png',
                    index: 0,
                    isSelected: selectedIndex == 0,
                    onSelectionChanged: onSelectionChanged,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Para oferecer uma experiência melhor, precisamos saber seu gênero.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildGenderOptions(),
            if (selectedIndex != 0) ...[
              const Text(
                'Quais modalidades você atende?',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: openModalities,
                child: Stack(
                  children: [
                    InputDecorator(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Selecione",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        selectedModalities.isEmpty
                            ? 'Selecione'
                            : selectedModalities.join(', '),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    const Positioned(
                      bottom: 7,
                      right: 10,
                      child: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.black,
                        size: 35,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            const Text(
              'Tem Preferência de gênero de alunos?',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: openGenderOptions,
              child: Stack(
                children: [
                  InputDecorator(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      genderSelected ?? 'Selecione',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const Positioned(
                    bottom: 7,
                    right: 10,
                    child: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.black,
                      size: 35,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  void openModalities() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Modalities(
        selectedModalities: selectedModalities,
        onModalitiesSelected: (newModalities) {
          setState(() {
            selectedModalities = newModalities;
          });
        },
      ),
    );
  }

  void openGenderOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => GenderSelection(
        currentGender: genderSelected,
        onGenderSelected: (newGender) {
          setState(() {
            genderSelected = newGender;
          });
        },
      ),
    );
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
        const SizedBox(height: 4),
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

  Widget buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.057,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [personalColor, secondaryColor],
              ),
            ),
            child: Button(
              text: 'Próximo',
              onPressed: () {
                // Navegar para a próxima página
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilPage(), // Próxima página
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
