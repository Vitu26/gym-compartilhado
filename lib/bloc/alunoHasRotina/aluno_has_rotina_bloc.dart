import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_event.dart';
import 'package:sprylife/bloc/alunoHasRotina/aluno_has_rotina_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sprylife/utils/token_storege.dart';

class AlunoHasRotinaBloc
    extends Bloc<AlunoHasRotinaEvent, AlunoHasRotinaState> {
  AlunoHasRotinaBloc() : super(AlunoHasRotinaInitial()) {
    on<FetchAlunoHasRotina>(_onFetchAlunoHasRotina);
    on<CreateAlunoHasRotina>(_onCreateAlunoHasRotina);
  }

  Future<void> _onFetchAlunoHasRotina(
    FetchAlunoHasRotina event,
    Emitter<AlunoHasRotinaState> emit,
  ) async {
    emit(AlunoHasRotinaLoading());
    try {
      final token = await getToken(); // Obtém o token JWT
      final response = await http.get(
        Uri.parse(
            'https://developerxpb.com.br/api/aluno-has-rotinas/${event.alunoId}'),
        headers: {
          'Authorization': 'Bearer $token', // Corrige o formato do token
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(AlunoHasRotinaLoaded(data['data']));
      } else {
        emit(AlunoHasRotinaFailure(
            'Falha ao carregar rotinas: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AlunoHasRotinaFailure('Erro ao carregar rotinas: $e'));
    }
  }


  Future<void> _onCreateAlunoHasRotina(
    CreateAlunoHasRotina event,
    Emitter<AlunoHasRotinaState> emit,
  ) async {
    emit(AlunoHasRotinaLoading());
    try {
      final token = await getToken(); // Obtém o token JWT
      final response = await http.post(
        Uri.parse('https://endereco_api/api/aluno-has-rotinas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.associacaoData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        emit(AlunoHasRotinaSuccess('Associação criada com sucesso!'));
      } else {
        emit(AlunoHasRotinaFailure('Erro ao criar associação: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AlunoHasRotinaFailure('Erro ao criar associação: $e'));
    }
  }
}

