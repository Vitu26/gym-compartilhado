import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sprylife/bloc/alunosHasPlanos/aluno_has_plano_event.dart';
import 'package:sprylife/bloc/alunosHasPlanos/aluno_has_plano_state.dart';
import 'package:sprylife/utils/token_storege.dart';

class AlunoHasPlanoBloc extends Bloc<AlunoHasPlanoEvent, AlunoHasPlanoState> {
  AlunoHasPlanoBloc() : super(AlunoHasPlanoInitial()) {
    on<FetchAlunosHasPlano>(_onFetchAlunosHasPlano);
    on<CreateAlunoHasPlano>(_onCreateAlunoHasPlano);
    on<GetAlunoHasPlano>(_onGetAlunoHasPlano);
    on<UpdateAlunoHasPlano>(_onUpdateAlunoHasPlano);
    on<DeleteAlunoHasPlano>(_onDeleteAlunoHasPlano);
  }

  Future<void> _onFetchAlunosHasPlano(
      FetchAlunosHasPlano event, Emitter<AlunoHasPlanoState> emit) async {
    emit(AlunoHasPlanoLoading());
    print('FetchAlunosHasPlano iniciado para o aluno ${event.alunoId}');
    
    try {
      final token = await getToken();
      print('Token obtido: $token');

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/aluno-has-plano'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta HTTP: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(AlunoHasPlanoSuccess(data));
        print('Planos carregados com sucesso: $data');
      } else {
        emit(AlunoHasPlanoFailure('Failed to fetch alunos com planos'));
        print('Erro ao buscar os planos: ${response.body}');
      }
    } catch (e) {
      emit(AlunoHasPlanoFailure(e.toString()));
      print('Exceção durante FetchAlunosHasPlano: $e');
    }
  }

  Future<void> _onCreateAlunoHasPlano(
      CreateAlunoHasPlano event, Emitter<AlunoHasPlanoState> emit) async {
    emit(AlunoHasPlanoLoading());
    print('Criando um novo AlunoHasPlano para o aluno ${event.alunoId} e plano ${event.planoId}');
    
    try {
      final token = await getToken();
      print('Token obtido: $token');

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/aluno-has-plano'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'plano_id': event.planoId,
          'aluno_id': event.alunoId,
        }),
      );

      print('Status da resposta HTTP: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(AlunoHasPlanoSuccess(data));
        print('AlunoHasPlano criado com sucesso: $data');
      } else {
        emit(AlunoHasPlanoFailure('Failed to create aluno com plano'));
        print('Erro ao criar AlunoHasPlano: ${response.body}');
      }
    } catch (e) {
      emit(AlunoHasPlanoFailure(e.toString()));
      print('Exceção ao criar AlunoHasPlano: $e');
    }
  }

  Future<void> _onGetAlunoHasPlano(
      GetAlunoHasPlano event, Emitter<AlunoHasPlanoState> emit) async {
    emit(AlunoHasPlanoLoading());
    print('Buscando AlunoHasPlano com ID: ${event.id}');
    
    try {
      final token = await getToken();
      print('Token obtido: $token');

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/aluno-has-plano/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta HTTP: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(AlunoHasPlanoSuccess(data));
        print('AlunoHasPlano carregado com sucesso: $data');
      } else {
        emit(AlunoHasPlanoFailure('Failed to fetch aluno com plano'));
        print('Erro ao buscar AlunoHasPlano: ${response.body}');
      }
    } catch (e) {
      emit(AlunoHasPlanoFailure(e.toString()));
      print('Exceção ao buscar AlunoHasPlano: $e');
    }
  }

  Future<void> _onUpdateAlunoHasPlano(
      UpdateAlunoHasPlano event, Emitter<AlunoHasPlanoState> emit) async {
    emit(AlunoHasPlanoLoading());
    print('Atualizando AlunoHasPlano com ID: ${event.id}');
    
    try {
      final token = await getToken();
      print('Token obtido: $token');

      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/aluno-has-plano/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': event.id,
          'plano_id': event.planoId,
          'aluno_id': event.alunoId,
        }),
      );

      print('Status da resposta HTTP: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(AlunoHasPlanoSuccess(data));
        print('AlunoHasPlano atualizado com sucesso: $data');
      } else {
        emit(AlunoHasPlanoFailure('Failed to update aluno com plano'));
        print('Erro ao atualizar AlunoHasPlano: ${response.body}');
      }
    } catch (e) {
      emit(AlunoHasPlanoFailure(e.toString()));
      print('Exceção ao atualizar AlunoHasPlano: $e');
    }
  }

  Future<void> _onDeleteAlunoHasPlano(
      DeleteAlunoHasPlano event, Emitter<AlunoHasPlanoState> emit) async {
    emit(AlunoHasPlanoLoading());
    print('Deletando AlunoHasPlano com ID: ${event.id}');
    
    try {
      final token = await getToken();
      print('Token obtido: $token');

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/aluno-has-plano/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta HTTP: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        emit(AlunoHasPlanoSuccess('Aluno com plano deleted'));
        print('AlunoHasPlano deletado com sucesso');
      } else {
        emit(AlunoHasPlanoFailure('Failed to delete aluno com plano'));
        print('Erro ao deletar AlunoHasPlano: ${response.body}');
      }
    } catch (e) {
      emit(AlunoHasPlanoFailure(e.toString()));
      print('Exceção ao deletar AlunoHasPlano: $e');
    }
  }
}
