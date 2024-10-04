import 'package:flutter/material.dart';
import 'package:sprylife/components/colors.dart';


class GenderSelection extends StatefulWidget {
  final String? currentGender;
  final Function(String) onGenderSelected;

  const GenderSelection({
    Key? key,
    this.currentGender,
    required this.onGenderSelected,
  }) : super(key: key);

  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  @override
  Widget build(BuildContext context) {
    final List<String> genderOptions = ['Todos', 'Masculino', 'Feminino'];
    String? selectedGender = widget.currentGender;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: 250, // Ajuste o tamanho conforme necessário
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50)
            ),
            child: Column(
              children: [
               
                Expanded(
                  child: ListView(
                    children: genderOptions.map((gender) {
                      return RadioListTile<String>(
                        activeColor: personalColor,
                        title: Text(gender,style: TextStyle(fontSize: 18,color: Colors.black),),
                        value: gender,
                        groupValue: selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.057,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [
                        personalColor,
                        secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (selectedGender != null) {
                        widget.onGenderSelected(selectedGender!);
                      }
                      Navigator.pop(context);
                    },
                    foregroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    child: Text(
                      'Salvar',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
