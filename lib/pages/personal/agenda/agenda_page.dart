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
                  // Constrói a lista de agendas com os eventos carregados
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

  // Método para converter horário no formato 24 horas (HH:mm)
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

  // Lista de agendas
  Widget _buildAgendaList(List<AgendaModel> agendas) {
    List<String> hours = List.generate(24, (index) {
      return '${index.toString().padLeft(2, '0')}:00'; // Horas no formato 24 horas
    });

    // Mapeia os eventos para o horário correspondente
    Map<String, List<AgendaModel>> eventsByHour = {};

    for (var hour in hours) {
      eventsByHour[hour] = [];
    }

    for (var agenda in agendas) {
      // Converte o horário de 24 horas (HH:MM)
      TimeOfDay startTime = parseTime(agenda.horarioInicio);
      String startHour = startTime.format(context); // Formato 24 horas

      if (eventsByHour.containsKey(startHour)) {
        eventsByHour[startHour]!.add(agenda);
      }
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: hours.length,
      itemBuilder: (context, index) {
        String currentHour = hours[index];
        List<AgendaModel> eventsAtThisHour = eventsByHour[currentHour]!;

        return Row(
          children: [
            Container(
              width: 60,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 8),
              child: Text(
                currentHour,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: eventsAtThisHour.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: eventsAtThisHour.map((agenda) {
                        TimeOfDay startTime = parseTime(agenda.horarioInicio);
                        TimeOfDay endTime = parseTime(agenda.horarioFim);
                        final duration = (endTime.hour + endTime.minute / 60) -
                            (startTime.hour + startTime.minute / 60);

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 60.0 * duration, // Define a altura do evento
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                agenda.nomeEvento,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Local: ${agenda.rua}, ${agenda.bairro}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Status: ${agenda.descricao ?? 'Aguardando confirmação'}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  : Container(
                      height: 60, // Cada hora tem 60 de altura
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  // Função para construir o calendário semanal na parte superior
  Widget _buildCalendar() {
    DateTime now = DateTime.now(); // Data atual
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
                widget.selectedDay = day; // Atualiza o dia selecionado
              });
              context
                  .read<AgendaBloc>()
                  .add(GetAllAgendasForDay(day)); // Carrega as agendas do dia
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

  // Função para criar os botões "Calendário" e "Agendar" na parte inferior
  Widget _buildFooterButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomButton(
              text: 'Calendário',
              backgroundColor: personalColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CalendarioPage(
                        personalId: widget.personalData?['id'] ??
                            widget.alunoData?[
                                'id']))); // Navega para o calendário
              }),
          SizedBox(height: 16),
          CustomButtonBorda(
              text: 'Agendar',
              backgroundColor: Colors.white,
              onPressed: () {
                _showCreateAgendaDialog();
              }),
        ],
      ),
    );
  }

  void _showCreateAgendaDialog() {
    final nomeController = TextEditingController();
    final ruaController = TextEditingController();
    final bairroController = TextEditingController();
    final descricaoController = TextEditingController();
    final horarioInicioController = TextEditingController();
    final horarioFimController = TextEditingController();

    TimeOfDay? selectedInicioTime;
    TimeOfDay? selectedFimTime;
    DateTime? selectedDate;

    Future<void> _selectTime(
        BuildContext context, TextEditingController controller,
        {bool isStart = true}) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: isStart
            ? (selectedInicioTime ?? TimeOfDay.now())
            : (selectedFimTime ?? TimeOfDay.now()),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          if (isStart) {
            selectedInicioTime = picked;
          } else {
            selectedFimTime = picked;
          }
          controller.text = picked.format(context); // Formatando o horário
        });
      }
    }

    Future<void> _selectDate(BuildContext context) async {
      if (Platform.isAndroid) {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
          });
        }
      } else if (Platform.isIOS) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                initialDateTime: selectedDate ?? DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
              ),
            );
          },
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Agendar'),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botão para escolher a data
                    GestureDetector(
                      onTap: () => _selectDate(context),
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

                    // Nome do Evento
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(labelText: 'Nome do Evento'),
                    ),
                    SizedBox(height: 12),

                    // Horário Início e Fim
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: horarioInicioController,
                            decoration: InputDecoration(
                              labelText: 'Horário Início',
                            ),
                            onTap: () => _selectTime(
                                context, horarioInicioController,
                                isStart: true),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: horarioFimController,
                            decoration: InputDecoration(
                              labelText: 'Horário Fim',
                            ),
                            onTap: () => _selectTime(
                                context, horarioFimController,
                                isStart: false),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Rua Field
                    TextField(
                      controller: ruaController,
                      decoration: InputDecoration(labelText: 'Rua'),
                    ),
                    SizedBox(height: 12),

                    // Bairro Field
                    TextField(
                      controller: bairroController,
                      decoration: InputDecoration(labelText: 'Bairro'),
                    ),
                    SizedBox(height: 12),

                    // Descrição Field
                    TextField(
                      controller: descricaoController,
                      decoration: InputDecoration(labelText: 'Descrição'),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final newAgenda = {
                          'data': selectedDate != null
                              ? selectedDate!.toIso8601String()
                              : 'N/A',
                          'nome-do-evento': nomeController.text,
                          'horario-inicio': horarioInicioController.text,
                          'horario-fim': horarioFimController.text,
                          'rua': ruaController.text,
                          'bairro': bairroController.text,
                          'descricao': descricaoController.text,
                          if (widget.personalData != null)
                            'personal_id': widget.personalData!['id']
                          else if (widget.alunoData != null)
                            'aluno_id': widget.alunoData!['id'],
                        };
                        context.read<AgendaBloc>().add(CreateAgenda(newAgenda));
                        Navigator.pop(context);
                      },
                      child: Text('Adicionar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
