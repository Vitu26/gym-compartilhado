import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';

class PesquisarPersonal extends StatefulWidget {
  @override
  _PesquisarPersonalState createState() => _PesquisarPersonalState();
}

class _PesquisarPersonalState extends State<PesquisarPersonal> {
  // Variáveis de estado para armazenar as seleções
  String selectedProfessionalType = 'Personal';
  String selectedGender = 'Todos';
  String selectedAttendanceType = 'Todos';
  List<String> selectedModalities = [];
  bool freeTrial = false;
  double selectedDistance = 10.0; // Valor padrão de 10 km
  Position? userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    // Captura a localização atual do usuário
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Tratar o caso de permissão negada
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(
        title: 'Pesquisar Personal',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pesquisar por nome
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.close),
                hintText: 'Pesquisar por nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Localização Slider
            Text('Localização (até ${selectedDistance.toStringAsFixed(0)} km)'),
            Slider(
              value: selectedDistance,
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (value) {
                setState(() {
                  selectedDistance = value;
                });
              },
              activeColor: alunoCor,
              inactiveColor: Colors.grey[300],
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                suffixIcon: Icon(Icons.close),
                hintText: 'Bairro, Cidade',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Tipo de Profissional
            Text('Tipo de Profissional'),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text(
                    'Personal',
                    style: TextStyle(
                      color: selectedProfessionalType == 'Personal'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedProfessionalType == 'Personal',
                  onSelected: (selected) {
                    setState(() {
                      selectedProfessionalType = selected ? 'Personal' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Nutricionista',
                    style: TextStyle(
                      color: selectedProfessionalType == 'Nutricionista'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedProfessionalType == 'Nutricionista',
                  onSelected: (selected) {
                    setState(() {
                      selectedProfessionalType =
                          selected ? 'Nutricionista' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Gênero do Profissional
            Text('Gênero do Profissional'),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text(
                    'Todos',
                    style: TextStyle(
                      color: selectedGender == 'Todos'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedGender == 'Todos',
                  onSelected: (selected) {
                    setState(() {
                      selectedGender = selected ? 'Todos' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Masculino',
                    style: TextStyle(
                      color: selectedGender == 'Masculino'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedGender == 'Masculino',
                  onSelected: (selected) {
                    setState(() {
                      selectedGender = selected ? 'Masculino' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Feminino',
                    style: TextStyle(
                      color: selectedGender == 'Feminino'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedGender == 'Feminino',
                  onSelected: (selected) {
                    setState(() {
                      selectedGender = selected ? 'Feminino' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Tipo de Atendimento
            Text('Tipo de Atendimento'),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text(
                    'Todos',
                    style: TextStyle(
                      color: selectedAttendanceType == 'Todos'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedAttendanceType == 'Todos',
                  onSelected: (selected) {
                    setState(() {
                      selectedAttendanceType = selected ? 'Todos' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Online',
                    style: TextStyle(
                      color: selectedAttendanceType == 'Online'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedAttendanceType == 'Online',
                  onSelected: (selected) {
                    setState(() {
                      selectedAttendanceType = selected ? 'Online' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Presencial',
                    style: TextStyle(
                      color: selectedAttendanceType == 'Presencial'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedAttendanceType == 'Presencial',
                  onSelected: (selected) {
                    setState(() {
                      selectedAttendanceType = selected ? 'Presencial' : '';
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Modalidades
            Text('Modalidades'),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text(
                    'Todos',
                    style: TextStyle(
                      color: selectedModalities.contains('Todos')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Todos'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities = ['Todos'];
                      } else {
                        selectedModalities.remove('Todos');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Musculação',
                    style: TextStyle(
                      color: selectedModalities.contains('Musculação')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Musculação'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities.add('Musculação');
                      } else {
                        selectedModalities.remove('Musculação');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Funcional',
                    style: TextStyle(
                      color: selectedModalities.contains('Funcional')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Funcional'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities.add('Funcional');
                      } else {
                        selectedModalities.remove('Funcional');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Pilates',
                    style: TextStyle(
                      color: selectedModalities.contains('Pilates')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Pilates'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities.add('Pilates');
                      } else {
                        selectedModalities.remove('Pilates');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Corrida',
                    style: TextStyle(
                      color: selectedModalities.contains('Corrida')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Corrida'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities.add('Corrida');
                      } else {
                        selectedModalities.remove('Corrida');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Luta',
                    style: TextStyle(
                      color: selectedModalities.contains('Luta')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Luta'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities.add('Luta');
                      } else {
                        selectedModalities.remove('Luta');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Dança',
                    style: TextStyle(
                      color: selectedModalities.contains('Dança')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Dança'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities.add('Dança');
                      } else {
                        selectedModalities.remove('Dança');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
                ChoiceChip(
                  label: Text(
                    'Natação',
                    style: TextStyle(
                      color: selectedModalities.contains('Natação')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: selectedModalities.contains('Natação'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedModalities.add('Natação');
                      } else {
                        selectedModalities.remove('Natação');
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: alunoCor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Aula Experimental Gratuita
            Row(
              children: [
                Checkbox(
                  value: freeTrial,
                  onChanged: (value) {
                    setState(() {
                      freeTrial = value ?? false;
                    });
                  },
                  activeColor: alunoCor,
                ),
                Text('Aula Experimental Gratuita'),
              ],
            ),

            SizedBox(height: 16),

            // Botões de Resetar Filtro e Aplicar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Resetar filtros
                      setState(() {
                        selectedProfessionalType = 'Personal';
                        selectedGender = 'Todos';
                        selectedAttendanceType = 'Todos';
                        selectedModalities.clear();
                        freeTrial = false;
                      });
                    },
                    child: Text('Resetar Filtro'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: alunoCor,
                      side: BorderSide(color: alunoCor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      BlocProvider.of<PersonalBloc>(context).add(
                        GetAllPersonais(
                          professionalType: selectedProfessionalType,
                          gender: selectedGender,
                          attendanceType: selectedAttendanceType,
                          modalities: selectedModalities,
                          freeTrial: freeTrial,
                        ),
                      );
                      Navigator.pushNamed(context, '/pesquisarPersonalt').then((_) {
                        print('Voltou da página de resultados');
                      });
                    },
                    child: Text(
                      'Aplicar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: alunoCor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
