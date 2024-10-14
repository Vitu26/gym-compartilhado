import 'package:flutter/material.dart';
import 'package:sprylife/bloc/agenda/agenda_event.dart';
import 'package:sprylife/bloc/agenda/agenda_state.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/agenda/agenda_bloc.dart';
import 'package:sprylife/models/model_tudo.dart';

class CalendarioPage extends StatefulWidget {
  final int personalId;

  CalendarioPage({required this.personalId});

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late Map<DateTime, List<AgendaModel>> _eventos;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _eventos = {};
    // Buscar todos os eventos ao carregar a página
    context.read<AgendaBloc>().add(GetAllAgendasForDay(_focusedDay));
  }

  // Lógica para recuperar os eventos por dia
  List<AgendaModel> _getEventsForDay(DateTime day) {
    return _eventos[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calendário Mensal',
        centerTitle: true,
      ),
      body: BlocBuilder<AgendaBloc, AgendaState>(
        builder: (context, state) {
          if (state is AgendaLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AgendaLoaded) {
            // Transformar os eventos carregados em um map baseado na data
            _eventos = _groupEventsByDay(state.agendas.cast<AgendaModel>());

            return Column(
              children: [
                TableCalendar<AgendaModel>(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    // Se houver algum evento no dia, retorna uma lista com um marcador.
                    if (_getEventsForDay(day).isNotEmpty) {
                      return [
                        AgendaModel(
                            id: 1,
                            data: day,
                            nomeEvento: '',
                            horarioInicio: '',
                            horarioFim: '',
                            rua: '',
                            bairro: '',
                            descricao: '',
                            personalId: 0)
                      ];
                    } else {
                      return [];
                    }
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    // Carregar eventos para o mês exibido
                    context
                        .read<AgendaBloc>()
                        .add(GetAllAgendasForDay(focusedDay));
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildEventList(),
              ],
            );
          } else if (state is AgendaError) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: Text('Nenhuma agenda disponível'));
          }
        },
      ),
    );
  }

  // Função para agrupar os eventos por dia
  Map<DateTime, List<AgendaModel>> _groupEventsByDay(
      List<AgendaModel> agendas) {
    Map<DateTime, List<AgendaModel>> eventos = {};
    for (var agenda in agendas) {
      DateTime eventDate =
          DateTime(agenda.data.year, agenda.data.month, agenda.data.day);
      if (eventos[eventDate] == null) {
        eventos[eventDate] = [];
      }
      eventos[eventDate]!.add(agenda);
    }
    return eventos;
  }

  // Lista de eventos para o dia selecionado
  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final agenda = events[index];
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(agenda.nomeEvento),
              subtitle: Text(
                'Horário: ${agenda.horarioInicio} às ${agenda.horarioFim}',
              ),
            ),
          );
        },
      ),
    );
  }
}
