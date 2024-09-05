import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarWidget extends StatefulWidget {
  final Color todayBackgroundColor;
  final Color selectedDayBorderColor;
  final Color defaultDayTextColor;
  final Color selectedDayTextColor;
  final Color todayTextColor;
  final Color weekDayTextColor;

  const CalendarWidget({
    Key? key,
    this.todayBackgroundColor = const Color(0xFF134C74),
    this.selectedDayBorderColor = const Color(0xFF134C74),
    this.defaultDayTextColor = Colors.black,
    this.selectedDayTextColor = const Color(0xFF134C74),
    this.todayTextColor = Colors.white,
    this.weekDayTextColor = Colors.grey,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDay = DateTime.now();  // Dia atualmente selecionado

  void _showAgendaForDay(BuildContext context, DateTime day) async {
    setState(() {
      selectedDay = day;  // Atualiza o dia selecionado
    });

    final String apiUrl = "https://api.exemplo.com/compromissos?data=${day.toIso8601String()}";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List appointments = json.decode(response.body);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compromissos para ${day.day}/${day.month}/${day.year}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (appointments.isEmpty)
                  const Text('Nenhum compromisso para este dia.'),
                ...appointments.map((appointment) => ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(appointment['title']),
                  subtitle: Text(appointment['time']),
                )),
              ],
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar compromissos.')),
      );
    }
  }

  Widget _buildCalendar() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        bool isSelectedDay = day.day == selectedDay.day && day.month == selectedDay.month && day.year == selectedDay.year;
        bool isToday = day.day == now.day && day.month == now.month && day.year == now.year;

        return GestureDetector(
          onTap: () => _showAgendaForDay(context, day),
          child: Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
              color: isToday
                  ? widget.todayBackgroundColor  // Cor do dia atual
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),  // Arredondar apenas os cantos inferiores
                bottomRight: Radius.circular(50),
              ),
              border: isSelectedDay && !isToday
                  ? Border.all(color: widget.selectedDayBorderColor, width: 2)  // Borda para o dia selecionado
                  : Border.all(color: Colors.transparent, width: 2),  // Sem borda para outros dias
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][index],
                  style: TextStyle(
                    color: isToday
                        ? widget.todayTextColor  // Cor do texto para o dia atual
                        : isSelectedDay
                            ? widget.selectedDayTextColor  // Cor do texto para o dia selecionado
                            : widget.weekDayTextColor,  // Cor padrão para os dias da semana
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isToday
                        ? widget.todayTextColor
                        : isSelectedDay
                            ? widget.selectedDayTextColor
                            : widget.defaultDayTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCalendar();
  }
}
