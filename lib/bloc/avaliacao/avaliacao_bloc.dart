import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/models/model_tudo.dart';
import 'package:sprylife/utils/token_storege.dart';
import 'avaliacao_event.dart';
import 'avaliacao_state.dart';

class AvaliacaoBloc extends Bloc<AvaliacaoEvent, AvaliacaoState> {
  final String apiUrl = 'https://developerxpb.com.br/api/avaliacoes';

  AvaliacaoBloc() : super(AvaliacaoInitial()) {
    on<GetAllAvaliacoes>(_onGetAllAvaliacoes);
    on<CreateAvaliacao>(_onCreateAvaliacao);
    on<GetAvaliacao>(_onGetAvaliacao);
    on<UpdateAvaliacao>(_onUpdateAvaliacao);
    on<DeleteAvaliacao>(_onDeleteAvaliacao);
    on<FetchAvaliacoes>(_onFetchAvaliacoes);
    // on<AddAvaliacao>(_onAddAvaliacao);
  }

  Future<void> _onGetAllAvaliacoes(
      GetAllAvaliacoes event, Emitter<AvaliacaoState> emit) async {
    emit(AvaliacaoLoading());
    try {
      final token = await getToken(); // Obtém o token dinamicamente
      if (token != null) {
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: _buildHeaders(token),
        );
        print(response.body);
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          emit(AvaliacaoLoaded(avaliacoes: data));
        } else {
          emit(AvaliacaoFailure('Falha ao carregar avaliações'));
        }
      } else {
        emit(AvaliacaoFailure('Token não encontrado'));
      }
    } catch (e) {
      emit(AvaliacaoFailure(e.toString()));
    }
  }

  Future<void> _onCreateAvaliacao(
      CreateAvaliacao event, Emitter<AvaliacaoState> emit) async {
    emit(AvaliacaoLoading());
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: _buildHeaders(token),
          body: jsonEncode({
            'nota': event.nota.toString(),
            'comentario': event.comentario,
            'personal_id': event.personalId.toString(),
          }),
        );
        if (response.statusCode == 201) {
          emit(AvaliacaoSuccess('Avaliação criada com sucesso!'));
        } else {
          emit(AvaliacaoFailure('Falha ao criar avaliação'));
        }
      } else {
        emit(AvaliacaoFailure('Token não encontrado'));
      }
    } catch (e) {
      emit(AvaliacaoFailure(e.toString()));
    }
  }

  Future<void> _onGetAvaliacao(
      GetAvaliacao event, Emitter<AvaliacaoState> emit) async {
    emit(AvaliacaoLoading());
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$apiUrl/${event.id}'),
          headers: _buildHeaders(token),
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          emit(AvaliacaoDetailLoaded(avaliacao: data));
        } else {
          emit(AvaliacaoFailure('Falha ao carregar avaliação'));
        }
      } else {
        emit(AvaliacaoFailure('Token não encontrado'));
      }
    } catch (e) {
      emit(AvaliacaoFailure(e.toString()));
    }
  }

  Future<void> _onUpdateAvaliacao(
      UpdateAvaliacao event, Emitter<AvaliacaoState> emit) async {
    emit(AvaliacaoLoading());
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.put(
          Uri.parse('$apiUrl/${event.id}'),
          headers: _buildHeaders(token),
          body: jsonEncode({
            'id': event.id.toString(),
            'nota': event.nota.toString(),
            'comentario': event.comentario,
            'personal_id': event.personalId.toString(),
          }),
        );
        if (response.statusCode == 200) {
          emit(AvaliacaoSuccess('Avaliação atualizada com sucesso!'));
        } else {
          emit(AvaliacaoFailure('Falha ao atualizar avaliação'));
        }
      } else {
        emit(AvaliacaoFailure('Token não encontrado'));
      }
    } catch (e) {
      emit(AvaliacaoFailure(e.toString()));
    }
  }

  Future<void> _onDeleteAvaliacao(
      DeleteAvaliacao event, Emitter<AvaliacaoState> emit) async {
    emit(AvaliacaoLoading());
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.delete(
          Uri.parse('$apiUrl/${event.id}'),
          headers: _buildHeaders(token),
        );
        if (response.statusCode == 200) {
          emit(AvaliacaoSuccess('Avaliação excluída com sucesso!'));
        } else {
          emit(AvaliacaoFailure('Falha ao excluir avaliação'));
        }
      } else {
        emit(AvaliacaoFailure('Token não encontrado'));
      }
    } catch (e) {
      emit(AvaliacaoFailure(e.toString()));
    }
  }

  Future<void> _onFetchAvaliacoes(
      FetchAvaliacoes event, Emitter<AvaliacaoState> emit) async {
    emit(AvaliacaoLoading());
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$apiUrl/${event.personalId}'),
          headers: _buildHeaders(token),
        );
        print(response.body); // Debug da resposta da API

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);

          // Verifica se o campo 'data' é nulo ou vazio
          if (json['data'] == null || (json['data'] as List).isEmpty) {
            emit(AvaliacaoLoaded(avaliacoes: [])); // Lista vazia
          } else {
            final List<dynamic> data = json['data'];
            final avaliacoes =
                data.map((item) => Comentario.fromJson(item)).toList();
            emit(AvaliacaoLoaded(avaliacoes: avaliacoes));
          }
        } else {
          emit(AvaliacaoError(message: 'Falha ao carregar avaliações'));
        }
      } else {
        emit(AvaliacaoError(message: 'Token não encontrado'));
      }
    } catch (e) {
      emit(AvaliacaoError(message: e.toString()));
    }
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
