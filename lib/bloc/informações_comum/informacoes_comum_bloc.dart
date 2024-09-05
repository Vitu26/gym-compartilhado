import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart'; // Importe o token storage

import 'informacoes_comum_event.dart';
import 'informacoes_comum_state.dart';

class InformacoesComunsBloc
    extends Bloc<InformacoesComunsEvent, InformacoesComunsState> {
  final String apiUrl = 'https://developerxpb.com.br/api/informacoes-comuns';

  InformacoesComunsBloc() : super(InformacoesComunsLoading()) {
    on<FetchInformacoesComuns>(_mapFetchInformacoesComunsToState);
    on<CreateInformacoesComuns>(_mapCreateInformacoesComunsToState);
    on<UpdateInformacoesComuns>(_mapUpdateInformacoesComunsToState);
    on<DeleteInformacoesComuns>(_mapDeleteInformacoesComunsToState);
  }

  Future<void> _mapFetchInformacoesComunsToState(
      FetchInformacoesComuns event, Emitter<InformacoesComunsState> emit) async {
    try {
      emit(InformacoesComunsLoading());
      final token = await _getToken(); // Obtenha o token

      final response = await http.get(
        Uri.parse('$apiUrl/${event.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(InformacoesComunsLoaded(data));
      } else {
        emit(InformacoesComunsError('Falha ao buscar as informações comuns.'));
      }
    } catch (e) {
      emit(InformacoesComunsError('Erro: $e'));
    }
  }

  Future<void> _mapCreateInformacoesComunsToState(
      CreateInformacoesComuns event, Emitter<InformacoesComunsState> emit) async {
    try {
      emit(InformacoesComunsLoading());
      final token = await _getToken();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(event.informacoesComunsData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final int informacoesComunsId = data['id']; // Extraindo o id da resposta

        emit(InformacoesComunsCreated(informacoesComunsId)); // Passando o id criado
      } else {
        emit(InformacoesComunsError('Falha ao criar as informações comuns.'));
      }
    } catch (e) {
      emit(InformacoesComunsError('Erro: $e'));
    }
  }

  Future<void> _mapUpdateInformacoesComunsToState(
      UpdateInformacoesComuns event, Emitter<InformacoesComunsState> emit) async {
    try {
      emit(InformacoesComunsLoading());
      final token = await _getToken(); // Obtenha o token

      final response = await http.put(
        Uri.parse('$apiUrl/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(event.informacoesComunsData),
      );

      if (response.statusCode == 200) {
        emit(InformacoesComunsUpdated());
      } else {
        emit(InformacoesComunsError('Falha ao atualizar as informações comuns.'));
      }
    } catch (e) {
      emit(InformacoesComunsError('Erro: $e'));
    }
  }

  Future<void> _mapDeleteInformacoesComunsToState(
      DeleteInformacoesComuns event, Emitter<InformacoesComunsState> emit) async {
    try {
      emit(InformacoesComunsLoading());
      final token = await _getToken(); // Obtenha o token

      final response = await http.delete(
        Uri.parse('$apiUrl/${event.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        emit(InformacoesComunsDeleted());
      } else {
        emit(InformacoesComunsError('Falha ao deletar as informações comuns.'));
      }
    } catch (e) {
      emit(InformacoesComunsError('Erro: $e'));
    }
  }

  Future<String?> _getToken() async {
    return await getToken(); // Usando a função de obter o token
  }
}
