import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprylife/bloc/agenda/agenda_bloc.dart';
import 'package:sprylife/bloc/agenda/agenda_event.dart';
import 'package:sprylife/bloc/agenda/agenda_state.dart';
import 'package:sprylife/components/colors.dart';
import 'package:sprylife/models/model_tudo.dart';
import 'package:sprylife/pages/personal/agenda/calendario_page.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/custom_button_borda.dart';

class AgendaPage extends StatefulWidget {
  DateTime selectedDay;
  final Map<String, dynamic>? personalData;
  final Map<String, dynamic>? alunoData;

  AgendaPage({
    required this.selectedDay,
    this.personalData,
    this.alunoData,
  });

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  void initState() {
    super.initState();
    // Carrega as agendas para o dia selecionado ao iniciar
    context.read<AgendaBloc>().add(GetAllAgendasForDay(widget.selectedDay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCalendar(), // Calendário Semanal
          Expanded(
            child: BlocBuilder<AgendaBloc, AgendaState>(
              builder: (context, state) {
                if (state is AgendaLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is AgendaLoaded) {
                  return _buildAgendaList(state.agendas.cast<AgendaModel>());
                } else if (state is AgendaError) {
                  return Center(child: Text(state.error));
                } else {
                  return Center(child: Text('Nenhuma agenda disponível'));
                }
              },
            ),
          ),
          _buildFooterButtons(),
        ],
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    return picked;
  }

  Future<TimeOfDay?> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    return picked;
  }

  TimeOfDay parseTime(String time) {
    final format = DateFormat.Hm(); // Formato de 24 horas
    try {
      DateTime parsedTime = format.parse(time);
      return TimeOfDay.fromDateTime(parsedTime); // Converte para TimeOfDay
    } catch (e) {
      print('Erro ao converter o horário: $e');
      return TimeOfDay(hour: 0, minute: 0); // Retorna 00:00 em caso de erro
    }
  }

  Widget _buildAgendaList(List<AgendaModel> agendas) {
    if (agendas.isEmpty) {
      return Center(
        child: Text(
          'Nenhum evento disponível',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: agendas.length,
      itemBuilder: (context, index) {
        final agenda = agendas[index];

        TimeOfDay startTime = parseTime(agenda.horarioInicio);
        TimeOfDay endTime = parseTime(agenda.horarioFim);

        final duration = (endTime.hour + endTime.minute / 60) -
            (startTime.hour + startTime.minute / 60);

        final positiveDuration =
            duration > 0 ? duration : 1; // Evitar valores negativos

        return GestureDetector(
          onTap: () => _showEventDetails(agenda),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 60.0 * positiveDuration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agenda.nomeEvento,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                SizedBox(height: 4),
                Text(
                  'Horário: ${agenda.horarioInicio} às ${agenda.horarioFim}',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = widget.selectedDay
        .subtract(Duration(days: widget.selectedDay.weekday - 1));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          DateTime day = startOfWeek.add(Duration(days: index));
          bool isSelectedDay = day.day == widget.selectedDay.day &&
              day.month == widget.selectedDay.month &&
              day.year == widget.selectedDay.year;
          bool isToday = day.day == now.day &&
              day.month == now.month &&
              day.year == now.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedDay = day;
              });
              context.read<AgendaBloc>().add(GetAllAgendasForDay(day));
            },
            child: Container(
              width: 50,
              height: 80,
              decoration: BoxDecoration(
                color: isToday ? personalColor : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                border: isSelectedDay && !isToday
                    ? Border.all(
                        color: personalColor,
                        width: 2,
                      )
                    : Border.all(
                        color: Colors.transparent,
                        width: 2,
                      ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][index],
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : isSelectedDay
                              ? personalColor
                              : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : isSelectedDay
                              ? personalColor
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomButton(
            isThin: true,
            text: 'Calendário',
            backgroundColor: personalColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CalendarioPage(
                      personalId: widget.personalData?['id'] ??
                          widget.alunoData?['id'])));
            },
          ),
          SizedBox(height: 10),
          CustomButtonBorda(
            isThin: true,
            text: 'Agendar',
            backgroundColor: Colors.white,
            onPressed: () {
              _showCreateAgendaDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showCreateAgendaDialog({AgendaModel? agenda}) {
    final nomeController =
        TextEditingController(text: agenda?.nomeEvento ?? '');
    final ruaController = TextEditingController(text: agenda?.rua ?? '');
    final bairroController = TextEditingController(text: agenda?.bairro ?? '');
    final descricaoController =
        TextEditingController(text: agenda?.descricao ?? '');
    final horarioInicioController =
        TextEditingController(text: agenda?.horarioInicio ?? '');
    final horarioFimController =
        TextEditingController(text: agenda?.horarioFim ?? '');
    DateTime? selectedDate = agenda?.data;

    TimeOfDay? selectedInicioTime =
        agenda != null ? parseTime(agenda.horarioInicio) : null;
    TimeOfDay? selectedFimTime =
        agenda != null ? parseTime(agenda.horarioFim) : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(agenda != null ? 'Editar Evento' : 'Agendar'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? pickedDate = await _selectDate(context);
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Data',
                          ),
                          controller: TextEditingController(
                            text: selectedDate != null
                                ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                                : 'Selecione a data',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(labelText: 'Nome do Evento'),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: horarioInicioController,
                            decoration:
                                InputDecoration(labelText: 'Horário Início'),
                            onTap: () async {
                              final TimeOfDay? pickedTime =
                                  await _selectTime(context, true);
                              if (pickedTime != null) {
                                setState(() {
                                  selectedInicioTime = pickedTime;
                                  horarioInicioController.text =
                                      pickedTime.format(context);
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: horarioFimController,
                            decoration:
                                InputDecoration(labelText: 'Horário Fim'),
                            onTap: () async {
                              final TimeOfDay? pickedTime =
                                  await _selectTime(context, false);
                              if (pickedTime != null) {
                                setState(() {
                                  selectedFimTime = pickedTime;
                                  horarioFimController.text =
                                      pickedTime.format(context);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: ruaController,
                      decoration: InputDecoration(labelText: 'Rua'),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: bairroController,
                      decoration: InputDecoration(labelText: 'Bairro'),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: descricaoController,
                      decoration: InputDecoration(labelText: 'Descrição'),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedDate == null) return;

                    final newAgenda = {
                      'data': selectedDate!.toIso8601String(),
                      'nome-do-evento': nomeController.text,
                      'horario-inicio': horarioInicioController.text,
                      'horario-fim': horarioFimController.text,
                      'rua': ruaController.text,
                      'bairro': bairroController.text,
                      'descricao': descricaoController.text,
                      if (widget.personalData != null)
                        'personal_id': widget.personalData!['id'],
                      if (agenda != null)
                        'id': agenda.id // Adiciona o ID em caso de edição
                    };

                    if (agenda == null) {
                      context.read<AgendaBloc>().add(CreateAgenda(newAgenda));
                    } else {
                      context
                          .read<AgendaBloc>()
                          .add(UpdateAgenda(agenda.id.toString(), newAgenda));
                    }

                    Navigator.pop(context);
                  },
                  child: Text(agenda != null ? 'Salvar' : 'Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEventDetails(AgendaModel agenda) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(agenda.nomeEvento),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Horário: ${agenda.horarioInicio} às ${agenda.horarioFim}'),
              SizedBox(height: 8),
              Text('Rua: ${agenda.rua}'),
              Text('Bairro: ${agenda.bairro}'),
              SizedBox(height: 8),
              Text('Descrição: ${agenda.descricao ?? 'opcional'}'),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: CustomButton(
                  text: 'Editar',
                  backgroundColor: personalColor,
                  isThin: true,
                  onPressed: () {
                    Navigator.pop(context);
                    _showCreateAgendaDialog(agenda: agenda);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: CustomButtonBorda(
                  text: 'Excluir',
                  backgroundColor: Colors.white,
                  isThin: true,
                  onPressed: () {
                    print('Excluindo evento com id: ${agenda.id}');
                    _deleteEvent(agenda);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _deleteEvent(AgendaModel agenda) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Tem certeza que deseja excluir este evento?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<AgendaBloc>().add(DeleteAgenda(agenda.id
                    .toString())); // Certifique-se que o ID está correto aqui
                Navigator.pop(context); // Fechar o diálogo de confirmação
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
