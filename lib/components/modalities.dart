import 'package:flutter/material.dart';
import 'package:perfil_professor/components/colors.dart';

class Modalities extends StatefulWidget {
  final List<String> selectedModalities;
  final Function(List<String>) onModalitiesSelected;

  Modalities({
    Key? key,
    required this.selectedModalities,
    required this.onModalitiesSelected,
  }) : super(key: key);

  @override
  _ModalitiesState createState() => _ModalitiesState();
}

class _ModalitiesState extends State<Modalities> {
  List<String> _modalities = [
    'Musculação',
    'Funcional',
    'Pilates',
    'Corrida',
    'Dança',
    'Luta',
    'Natação',
  ];

  late List<String> _selectedModalities;

  @override
  void initState() {
    super.initState();
    _selectedModalities = List.from(widget.selectedModalities);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _modalities.map((modality) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: personalColor,
                    title: Text(
                      modality,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    value: _selectedModalities.contains(modality),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!_selectedModalities.contains(modality)) {
                            _selectedModalities.add(modality);
                          }
                        } else {
                          _selectedModalities.remove(modality);
                        }
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
                  widget.onModalitiesSelected(_selectedModalities);
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
  }
}
