import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/models/model_tudo.dart';
import 'agenda_event.dart';
import 'agenda_state.dart';
import 'package:sprylife/utils/token_storege.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final String apiUrl = 'https://developerxpb.com.br/api/agenda';

  AgendaBloc() : super(AgendaLoading()) {
    on<GetAllAgendas>(_onGetAllAgendas);
    on<CreateAgenda>(_onCreateAgenda);
    on<UpdateAgenda>(_onUpdateAgenda);
    on<DeleteAgenda>(_onDeleteAgenda);
    on<GetAllAgendasForDay>(_onGetAllAgendasForDay);
  }

// Lógica para buscar todos os agendamentos
  Future<void> _onGetAllAgendas(
      GetAllAgendas event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final agendas = data.map((item) => AgendaModel.fromJson(item)).toList();
        emit(AgendaLoaded(agendas));
      } else {
        emit(AgendaError('Falha ao carregar agendas'));
      }
    } catch (e) {
      emit(AgendaError(e.toString()));
    }
  }

  // Lógica para buscar agendamentos de um dia específico
  Future<void> _onGetAllAgendasForDay(
      GetAllAgendasForDay event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading()); // Emite um estado de carregamento
    try {
      final token = await getToken(); // Obtém o token de autenticação
      final response = await http.get(
        Uri.parse(
            '$apiUrl?data=${event.day.toIso8601String()}'), // Filtra pela data
        headers: {'Authorization': 'Bearer $token'}, // Passa o token
      );
      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body)['data']; // Decodifica a resposta JSON
        final agendas = data
            .map((item) => AgendaModel.fromJson(item))
            .toList(); // Mapeia os dados para uma lista de objetos AgendaModel
        emit(AgendaLoaded(
            agendas)); // Envia a lista de objetos AgendaModel no estado carregado
      } else {
        emit(AgendaError(
            'Falha ao carregar agendas para o dia')); // Caso haja um erro na resposta
      }
    } catch (e) {
      emit(AgendaError(e.toString())); // Emite um erro caso ocorra uma exceção
    }
  }

  Future<void> _onCreateAgenda(
      CreateAgenda event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(event.agendaData),
      );

      // Aceitar tanto 200 quanto 201 como sucesso
      if (response.statusCode == 201 || response.statusCode == 200) {
        emit(AgendaSuccess('Agenda criada com sucesso!'));
        add(GetAllAgendas()); // Atualiza as agendas após criação
      } else {
        // Exibir mensagem de erro detalhada com o conteúdo da resposta
        final errorMessage = jsonDecode(response.body);
        emit(AgendaError('Falha ao criar agenda: ${errorMessage['message']}'));
      }
    } catch (e) {
      emit(AgendaError('Erro ao criar agenda: $e'));
    }
  }

  Future<void> _onUpdateAgenda(
      UpdateAgenda event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final token = await getToken();
      final response = await http.put(
        Uri.parse('$apiUrl/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(event.agendaData),
      );
      if (response.statusCode == 200) {
        emit(AgendaSuccess('Agenda atualizada com sucesso!'));
        add(GetAllAgendas()); // Atualiza as agendas após atualização
      } else {
        emit(AgendaError('Falha ao atualizar agenda'));
      }
    } catch (e) {
      emit(AgendaError(e.toString()));
    }
  }

  Future<void> _onDeleteAgenda(
      DeleteAgenda event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final token = await getToken();
      final response = await http.delete(
        Uri.parse('$apiUrl/${event.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        emit(AgendaSuccess('Agenda excluída com sucesso!'));
        add(GetAllAgendas()); // Atualiza as agendas após exclusão
      } else {
        emit(AgendaError('Falha ao excluir agenda'));
      }
    } catch (e) {
      emit(AgendaError(e.toString()));
    }
  }
}
