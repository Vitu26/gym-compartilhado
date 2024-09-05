import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/tipoTreino/tipo_treino_event.dart';
import 'package:sprylife/bloc/tipoTreino/tipo_treino_state.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart'; // Supondo que você tenha um utilitário para obter o token

class TipoTreinoBloc extends Bloc<TipoTreinoEvent, TipoTreinoState> {
  TipoTreinoBloc() : super(TipoTreinoInitial()) {
    on<GetAllTiposDeTreino>(_onGetAllTiposDeTreino);
    on<CreateTipoDeTreino>(_onCreateTipoDeTreino);
    on<GetTipoDeTreino>(_onGetTipoDeTreino);
    on<UpdateTipoDeTreino>(_onUpdateTipoDeTreino);
    on<DeleteTipoDeTreino>(_onDeleteTipoDeTreino);
  }

  Future<void> _onGetAllTiposDeTreino(
      GetAllTiposDeTreino event, Emitter<TipoTreinoState> emit) async {
    emit(TipoTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/tipo-treino'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(TipoTreinoLoaded(data));
        print('Tipos de treino carregados com sucesso'); // Log de sucesso
      } else {
        emit(TipoTreinoFailure('Failed to load tipos de treino'));
        print('Falha ao carregar tipos de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TipoTreinoFailure(e.toString()));
      print('Erro ao carregar tipos de treino: $e'); // Log de exceção
    }
  }

  Future<void> _onCreateTipoDeTreino(
      CreateTipoDeTreino event, Emitter<TipoTreinoState> emit) async {
    emit(TipoTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final tipoTreinoDataJson = jsonEncode(event.tipoTreinoData);
      print('Dados do tipo de treino sendo enviados: $tipoTreinoDataJson'); // Log dos dados do tipo de treino

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/tipo-treino'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: tipoTreinoDataJson,
      );

      print('Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 201) {
        emit(TipoTreinoSuccess('Tipo de treino criado com sucesso'));
        print('Tipo de treino criado com sucesso'); // Log de sucesso
      } else {
        emit(TipoTreinoFailure('Failed to create tipo de treino'));
        print('Falha ao criar tipo de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TipoTreinoFailure(e.toString()));
      print('Erro ao criar tipo de treino: $e'); // Log de exceção
    }
  }

  Future<void> _onGetTipoDeTreino(
      GetTipoDeTreino event, Emitter<TipoTreinoState> emit) async {
    emit(TipoTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/tipo-treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(TipoTreinoDetailLoaded(data));
        print('Detalhes do tipo de treino carregados com sucesso'); // Log de sucesso
      } else {
        emit(TipoTreinoFailure('Failed to load tipo de treino'));
        print('Falha ao carregar tipo de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TipoTreinoFailure(e.toString()));
      print('Erro ao carregar detalhes do tipo de treino: $e'); // Log de exceção
    }
  }

  Future<void> _onUpdateTipoDeTreino(
      UpdateTipoDeTreino event, Emitter<TipoTreinoState> emit) async {
    emit(TipoTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final tipoTreinoDataJson = jsonEncode(event.tipoTreinoData);
      print('Dados do tipo de treino sendo enviados: $tipoTreinoDataJson'); // Log dos dados do tipo de treino

      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/tipo-treino/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: tipoTreinoDataJson,
      );

      print('Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(TipoTreinoSuccess('Tipo de treino atualizado com sucesso'));
        print('Tipo de treino atualizado com sucesso'); // Log de sucesso
      } else {
        emit(TipoTreinoFailure('Failed to update tipo de treino'));
        print('Falha ao atualizar tipo de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TipoTreinoFailure(e.toString()));
      print('Erro ao atualizar tipo de treino: $e'); // Log de exceção
    }
  }

  Future<void> _onDeleteTipoDeTreino(
      DeleteTipoDeTreino event, Emitter<TipoTreinoState> emit) async {
    emit(TipoTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/tipo-treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(TipoTreinoSuccess('Tipo de treino deletado com sucesso'));
        print('Tipo de treino deletado com sucesso'); // Log de sucesso
      } else {
        emit(TipoTreinoFailure('Failed to delete tipo de treino'));
        print('Falha ao deletar tipo de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TipoTreinoFailure(e.toString()));
      print('Erro ao deletar tipo de treino: $e'); // Log de exceção
    }
  }
}
