import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/models/model_tudo.dart';
import 'package:sprylife/utils/token_storege.dart';
import 'dart:convert';

import 'turma_event.dart';
import 'turma_state.dart';

class TurmaBloc extends Bloc<TurmaEvent, TurmaState> {
  TurmaBloc() : super(TurmaInitial()) {
    on<LoadTurmas>(_onLoadTurmas);
    on<AddTurma>(_onAddTurma);
    on<UpdateTurma>(_onUpdateTurma);
    on<DeleteTurma>(_onDeleteTurma);
    on<GetTurmaDetails>(_onGetTurmaDetails);
  }

  Future<void> _onLoadTurmas(LoadTurmas event, Emitter<TurmaState> emit) async {
    emit(TurmaLoading());
    try {
      final token = await getToken();
      print('Token obtido: $token'); // Log do token para garantir que foi obtido corretamente

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/turma'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        print('Chaves do objeto resposta: ${responseData.keys}'); // Verificar as chaves do JSON

        // Supondo que 'data' seja a chave que contém a lista de turmas
        if (responseData.containsKey('data')) {
          final List<dynamic> turmaListJson = responseData['data'];
          print('Número de turmas carregadas: ${turmaListJson.length}'); // Log do número de turmas

          final List<Turma> turmas = turmaListJson
              .map((json) => Turma.fromJson(json))
              .toList();

          emit(TurmaLoaded(turmas: turmas));
        } else {
          print("Erro: A chave 'data' não foi encontrada no JSON.");
          emit(TurmaFailure(error: 'A chave "data" não foi encontrada no JSON.'));
        }
      } else {
        print('Erro: Falha ao carregar as turmas. Status: ${response.statusCode}');
        emit(TurmaFailure(error: 'Falha ao carregar as turmas.'));
      }
    } catch (e) {
      print('Exceção capturada: $e');
      emit(TurmaFailure(error: e.toString()));
    }
  }

  Future<void> _onAddTurma(AddTurma event, Emitter<TurmaState> emit) async {
    emit(TurmaLoading());
    try {
      final token = await getToken();
      print('Token obtido: $token'); // Log do token

      print('Dados da turma que será adicionada: ${event.turma.toJson()}'); // Log dos dados da turma

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/turma'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.turma.toJson()),
      );

      print('Status da resposta ao adicionar turma: ${response.statusCode}');
      print('Corpo da resposta ao adicionar turma: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 201) {
        print('Turma adicionada com sucesso.');
        emit(TurmaSuccess(message: 'Turma adicionada com sucesso.'));
        add(LoadTurmas());
      } else {
        print('Falha ao adicionar a turma. Status: ${response.statusCode}');
        emit(TurmaFailure(error: 'Falha ao adicionar a turma.'));
      }
    } catch (e) {
      print('Exceção capturada ao adicionar turma: $e');
      emit(TurmaFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateTurma(UpdateTurma event, Emitter<TurmaState> emit) async {
    emit(TurmaLoading());
    try {
      final token = await getToken();
      print('Token obtido: $token'); // Log do token

      print('Dados da turma que será atualizada: ${event.turma.toJson()}'); // Log dos dados da turma

      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/turma/${event.turma.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.turma.toJson()),
      );

      print('Status da resposta ao atualizar turma: ${response.statusCode}');
      print('Corpo da resposta ao atualizar turma: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        print('Turma atualizada com sucesso.');
        emit(TurmaSuccess(message: 'Turma atualizada com sucesso.'));
        add(LoadTurmas());
      } else {
        print('Falha ao atualizar a turma. Status: ${response.statusCode}');
        emit(TurmaFailure(error: 'Falha ao atualizar a turma.'));
      }
    } catch (e) {
      print('Exceção capturada ao atualizar turma: $e');
      emit(TurmaFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteTurma(DeleteTurma event, Emitter<TurmaState> emit) async {
    emit(TurmaLoading());
    try {
      final token = await getToken();
      print('Token obtido: $token'); // Log do token

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/turma/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta ao excluir turma: ${response.statusCode}');
      print('Corpo da resposta ao excluir turma: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        print('Turma excluída com sucesso.');
        emit(TurmaSuccess(message: 'Turma excluída com sucesso.'));
        add(LoadTurmas());
      } else {
        print('Falha ao excluir a turma. Status: ${response.statusCode}');
        emit(TurmaFailure(error: 'Falha ao excluir a turma.'));
      }
    } catch (e) {
      print('Exceção capturada ao excluir turma: $e');
      emit(TurmaFailure(error: e.toString()));
    }
  }

  Future<void> _onGetTurmaDetails(GetTurmaDetails event, Emitter<TurmaState> emit) async {
    emit(TurmaLoading());
    try {
      final token = await getToken();
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/turma/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta ao obter detalhes da turma: ${response.statusCode}');
      print('Corpo da resposta ao obter detalhes da turma: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final Map<String, dynamic> turmaJson = jsonDecode(response.body);
        final Turma turma = Turma.fromJson(turmaJson);

        print('Detalhes da turma carregados com sucesso.');
        emit(TurmaDetailsLoaded(turma: turma));
      } else {
        print('Falha ao carregar os detalhes da turma. Status: ${response.statusCode}');
        emit(TurmaFailure(error: 'Falha ao carregar os detalhes da turma.'));
      }
    } catch (e) {
      print('Exceção capturada ao obter detalhes da turma: $e');
      emit(TurmaFailure(error: e.toString()));
    }
  }
}
