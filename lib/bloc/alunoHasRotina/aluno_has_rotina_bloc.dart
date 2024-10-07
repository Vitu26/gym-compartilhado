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
            'https://developerxpb.com.br/api/alunos-has-rotinas/${event.alunoId}'),
        headers: {
          'Authorization': 'Bearer $token', // Corrige o formato do token
          'Content-Type': 'application/json',
        },
      );
      print('Aluno ID: ${event.alunoId}');

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
      print(
          'Tentando associar rotina ${event.associacaoData['rotina-de-treino_id']} ao aluno ${event.associacaoData['aluno_id']}');

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/alunos-has-rotinas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.associacaoData),
      );

      // Verifique o código de status correto para identificar sucesso ou erro
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Associação da rotina ao aluno realizada com sucesso!');
        emit(AlunoHasRotinaSuccess('Associação criada com sucesso!'));
      } else {
        // Tratar outras respostas com status diferente de 201 ou 200 como erro
        print('Erro ao criar associação: ${response.body}');
        emit(AlunoHasRotinaFailure(
            'Erro ao criar associação: ${response.body}'));
      }
    } catch (e) {
      print('Erro ao criar associação: $e');
      emit(AlunoHasRotinaFailure('Erro ao criar associação: $e'));
    }
  }
}
