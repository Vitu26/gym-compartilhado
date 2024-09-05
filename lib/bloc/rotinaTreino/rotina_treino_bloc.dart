import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_event.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_state.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart'; // Supondo que você tenha um utilitário para obter o token

class RotinaDeTreinoBloc
    extends Bloc<RotinaDeTreinoEvent, RotinaDeTreinoState> {
  RotinaDeTreinoBloc() : super(RotinaDeTreinoInitial()) {
    on<GetAllRotinasDeTreino>(_onGetAllRotinasDeTreino);
    on<CreateRotinaDeTreino>(_onCreateRotinaDeTreino);
    on<GetRotinaDeTreino>(_onGetRotinaDeTreino);
    on<UpdateRotinaDeTreino>(_onUpdateRotinaDeTreino);
    on<DeleteRotinaDeTreino>(_onDeleteRotinaDeTreino);
  }

Future<void> _onGetAllRotinasDeTreino(
    GetAllRotinasDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
  emit(RotinaDeTreinoLoading());
  try {
    final token = await getToken(); // Obtém o token de autorização
    print('Token obtido: $token'); // Log do token

    final response = await http.get(
      Uri.parse('https://developerxpb.com.br/api/rotina-de-treino'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Status da resposta: ${response.statusCode}'); // Log do status da resposta
    print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Verifica se o campo "data" existe e é uma lista
      if (responseData.containsKey('data')) {
        final rotinas = responseData['data'];
        if (rotinas is List) {
          emit(RotinaDeTreinoLoaded(rotinas));
          print('Rotinas de treino carregadas com sucesso: $rotinas'); // Log de sucesso com os dados
        } else {
          emit(RotinaDeTreinoFailure('Data field is not a list'));
          print('O campo data não é uma lista como esperado.'); // Log de falha
        }
      } else {
        emit(RotinaDeTreinoFailure('Data field not found in response'));
        print('Campo "data" não encontrado na resposta: ${response.body}'); // Log de falha
      }
    } else {
      emit(RotinaDeTreinoFailure('Failed to load rotinas de treino'));
      print('Falha ao carregar rotinas de treino: ${response.statusCode}'); // Log de falha
    }
  } catch (e) {
    emit(RotinaDeTreinoFailure(e.toString()));
    print('Erro ao carregar rotinas de treino: $e'); // Log de exceção
  }
}


Future<void> _onCreateRotinaDeTreino(
  CreateRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
  emit(RotinaDeTreinoLoading());
  try {
    final token = await getToken(); // Obtém o token de autorização
    print('Token obtido: $token'); // Log do token

    final rotinaDataJson = jsonEncode(event.rotinaData);
    print('Dados da rotina de treino sendo enviados: $rotinaDataJson'); // Log dos dados da rotina de treino

    final response = await http.post(
      Uri.parse('https://developerxpb.com.br/api/rotina-de-treino'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: rotinaDataJson,
    );

    print('Status da resposta: ${response.statusCode}'); // Log do status da resposta
    print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

    if (response.statusCode == 200 || response.statusCode == 201) {
      emit(RotinaDeTreinoSuccess('Rotina de treino criada com sucesso'));
      print('Rotina de treino criada com sucesso'); // Log de sucesso
    } else {
      emit(RotinaDeTreinoFailure('Falha ao criar rotina de treino'));
      print('Falha ao criar rotina de treino: ${response.statusCode}'); // Log de falha
    }
  } catch (e) {
    emit(RotinaDeTreinoFailure(e.toString()));
    print('Erro ao criar rotina de treino: $e'); // Log de exceção
  }
}


  Future<void> _onGetRotinaDeTreino(
      GetRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
    emit(RotinaDeTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse(
            'https://developerxpb.com.br/api/rotina-de-treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(RotinaDeTreinoDetailLoaded(data));
        print(
            'Detalhes da rotina de treino carregados com sucesso'); // Log de sucesso
      } else {
        emit(RotinaDeTreinoFailure('Failed to load rotina de treino'));
        print(
            'Falha ao carregar rotina de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
      print(
          'Erro ao carregar detalhes da rotina de treino: $e'); // Log de exceção
    }
  }

  Future<void> _onUpdateRotinaDeTreino(
      UpdateRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
    emit(RotinaDeTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final rotinaDataJson = jsonEncode(event.rotinaData);
      print(
          'Dados da rotina de treino sendo enviados: $rotinaDataJson'); // Log dos dados da rotina de treino

      final response = await http.put(
        Uri.parse(
            'https://developerxpb.com.br/api/rotina-de-treino/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: rotinaDataJson,
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(RotinaDeTreinoSuccess('Rotina de treino atualizada com sucesso'));
        print('Rotina de treino atualizada com sucesso'); // Log de sucesso
      } else {
        emit(RotinaDeTreinoFailure('Failed to update rotina de treino'));
        print(
            'Falha ao atualizar rotina de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
      print('Erro ao atualizar rotina de treino: $e'); // Log de exceção
    }
  }

  Future<void> _onDeleteRotinaDeTreino(
      DeleteRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
    emit(RotinaDeTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.delete(
        Uri.parse(
            'https://developerxpb.com.br/api/rotina-de-treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(RotinaDeTreinoSuccess('Rotina de treino deletada com sucesso'));
        print('Rotina de treino deletada com sucesso'); // Log de sucesso
      } else {
        emit(RotinaDeTreinoFailure('Failed to delete rotina de treino'));
        print(
            'Falha ao deletar rotina de treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
      print('Erro ao deletar rotina de treino: $e'); // Log de exceção
    }
  }
}
