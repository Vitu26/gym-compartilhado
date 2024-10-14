// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sprylife/bloc/agenda/agenda_bloc.dart';
// import 'package:sprylife/bloc/agenda/agenda_event.dart';
// import 'package:sprylife/bloc/agenda/agenda_state.dart';
// import 'package:sprylife/models/model_tudo.dart';

// class CalendarWidget extends StatefulWidget {
//   final Color todayBackgroundColor;
//   final Color selectedDayBorderColor;
//   final Color defaultDayTextColor;
//   final Color selectedDayTextColor;
//   final Color todayTextColor;
//   final Color weekDayTextColor;

//   const CalendarWidget({
//     Key? key,
//     this.todayBackgroundColor = const Color(0xFF134C74),
//     this.selectedDayBorderColor = const Color(0xFF134C74),
//     this.defaultDayTextColor = Colors.black,
//     this.selectedDayTextColor = const Color(0xFF134C74),
//     this.todayTextColor = Colors.white,
//     this.weekDayTextColor = Colors.grey,
//   }) : super(key: key);

//   @override
//   _CalendarWidgetState createState() => _CalendarWidgetState();
// }

// class _CalendarWidgetState extends State<CalendarWidget> {
//   DateTime selectedDay = DateTime.now(); // Dia atualmente selecionado

//   // Dispara o evento para obter os compromissos do dia
//   void _onDaySelected(BuildContext context, DateTime day) {
//     setState(() {
//       selectedDay = day; // Atualiza o dia selecionado
//     });

//     // Dispara evento para buscar compromissos do dia selecionado
//     context.read<AgendaBloc>().add(GetAllAgendasForDay(day)); // Usa o novo evento
//   }

//   Widget _buildCalendar() {
//     DateTime now = DateTime.now();
//     DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: List.generate(7, (index) {
//         DateTime day = startOfWeek.add(Duration(days: index));
//         bool isSelectedDay = day.day == selectedDay.day && day.month == selectedDay.month && day.year == selectedDay.year;
//         bool isToday = day.day == now.day && day.month == now.month && day.year == now.year;

//         return GestureDetector(
//           onTap: () => _onDaySelected(context, day), // Dispara o evento ao selecionar um dia
//           child: Container(
//             width: 50,
//             height: 80,
//             decoration: BoxDecoration(
//               color: isToday
//                   ? widget.todayBackgroundColor // Cor do dia atual
//                   : Colors.transparent,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(50), // Arredondar apenas os cantos inferiores
//                 bottomRight: Radius.circular(50),
//               ),
//               border: isSelectedDay && !isToday
//                   ? Border.all(color: widget.selectedDayBorderColor, width: 2) // Borda para o dia selecionado
//                   : Border.all(color: Colors.transparent, width: 2), // Sem borda para outros dias
//             ),
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][index],
//                   style: TextStyle(
//                     color: isToday
//                         ? widget.todayTextColor // Cor do texto para o dia atual
//                         : isSelectedDay
//                             ? widget.selectedDayTextColor // Cor do texto para o dia selecionado
//                             : widget.weekDayTextColor, // Cor padrão para os dias da semana
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   '${day.day}',
//                   style: TextStyle(
//                     color: isToday
//                         ? widget.todayTextColor
//                         : isSelectedDay
//                             ? widget.selectedDayTextColor
//                             : widget.defaultDayTextColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AgendaBloc, AgendaState>(
//       listener: (context, state) {
//         if (state is AgendaLoaded) {
//           _showAgendaForDay(context, state.agendas.cast<AgendaModel>());
//         } else if (state is AgendaError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erro ao carregar compromissos.')),
//           );
//         }
//       },
//       child: _buildCalendar(),
//     );
//   }

//   // Exibir compromissos em um modal quando o dia for selecionado
//   Future<void> _showAgendaForDay(BuildContext context, List<AgendaModel> appointments) async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Compromissos para ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (appointments.isEmpty)
//                 const Text('Nenhum compromisso para este dia.'),
//               ...appointments.map((appointment) => ListTile(
//                 leading: const Icon(Icons.schedule),
//                 title: Text(appointment.nomeEvento),
//                 subtitle: Text(
//                     '${appointment.horarioInicio} - ${appointment.horarioFim}\nRua: ${appointment.rua}, Bairro: ${appointment.bairro}'),
//               )),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/agenda/agenda_bloc.dart';
import 'package:sprylife/bloc/agenda/agenda_event.dart';
import 'package:sprylife/pages/personal/agenda/agenda_page.dart';

class CalendarWidget extends StatefulWidget {
  final Color todayBackgroundColor;
  final Color selectedDayBorderColor;
  final Color defaultDayTextColor;
  final Color selectedDayTextColor;
  final Color todayTextColor;
  final Color weekDayTextColor;
  final Map<String, dynamic>? personalData; // Dados opcionais para personal
  final Map<String, dynamic>? alunoData;    // Dados opcionais para aluno

  const CalendarWidget({
    Key? key,
    this.todayBackgroundColor = const Color(0xFF134C74),
    this.selectedDayBorderColor = const Color(0xFF134C74),
    this.defaultDayTextColor = Colors.black,
    this.selectedDayTextColor = const Color(0xFF134C74),
    this.todayTextColor = Colors.white,
    this.weekDayTextColor = Colors.grey,
    this.personalData,  // Passa os dados do personal, se houver
    this.alunoData,     // Passa os dados do aluno, se houver
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDay = DateTime.now(); // Dia atualmente selecionado

  // Dispara o evento para obter os compromissos do dia
  void _onDaySelected(BuildContext context, DateTime day) {
    setState(() {
      selectedDay = day; // Atualiza o dia selecionado
    });

    // Dispara evento para buscar compromissos do dia selecionado
    context.read<AgendaBloc>().add(GetAllAgendasForDay(day));

    // Verifica se estamos na tela do personal ou do aluno e navega apropriadamente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgendaPage(
          selectedDay: day,
          personalData: widget.personalData, // Passa os dados do personal, se houver
          alunoData: widget.alunoData,       // Passa os dados do aluno, se houver
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        bool isSelectedDay = day.day == selectedDay.day &&
            day.month == selectedDay.month &&
            day.year == selectedDay.year;
        bool isToday = day.day == now.day &&
            day.month == now.month &&
            day.year == now.year;

        return GestureDetector(
          onTap: () => _onDaySelected(
              context, day), // Dispara o evento ao selecionar um dia
          child: Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
              color: isToday
                  ? widget.todayBackgroundColor // Cor do dia atual
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(
                    50), // Arredondar apenas os cantos inferiores
                bottomRight: Radius.circular(50),
              ),
              border: isSelectedDay && !isToday
                  ? Border.all(
                      color: widget.selectedDayBorderColor,
                      width: 2) // Borda para o dia selecionado
                  : Border.all(
                      color: Colors.transparent,
                      width: 2), // Sem borda para outros dias
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][index],
                  style: TextStyle(
                    color: isToday
                        ? widget.todayTextColor // Cor do texto para o dia atual
                        : isSelectedDay
                            ? widget
                                .selectedDayTextColor // Cor do texto para o dia selecionado
                            : widget
                                .weekDayTextColor, // Cor padrão para os dias da semana
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
