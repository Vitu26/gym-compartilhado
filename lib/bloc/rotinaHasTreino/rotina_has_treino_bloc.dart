import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'rotina_has_treino_event.dart';
import 'rotina_has_treino_state.dart';
import 'package:sprylife/utils/token_storege.dart'; // Supondo que você tenha um utilitário para obter o token

class RotinaHasTreinoBloc
    extends Bloc<RotinaHasTreinoEvent, RotinaHasTreinoState> {
  RotinaHasTreinoBloc() : super(RotinaHasTreinoInitial()) {
    on<GetAllRotinasHasTreinos>(_onGetAllRotinasHasTreinos);
    on<CreateRotinaHasTreino>(_onCreateRotinaHasTreino);
    on<GetRotinaHasTreino>(_onGetRotinaHasTreino);
    on<UpdateRotinaHasTreino>(_onUpdateRotinaHasTreino);
    on<DeleteRotinaHasTreino>(_onDeleteRotinaHasTreino);
  }

Future<void> _onGetAllRotinasHasTreinos(
  GetAllRotinasHasTreinos event, Emitter<RotinaHasTreinoState> emit) async {
  emit(RotinaHasTreinoLoading());
  try {
    final token = await getToken(); // Obtém o token de autorização
    print('Token obtido: $token'); // Log do token

    // Faz a chamada para buscar a relação entre treinos e rotinas
    final response = await http.get(
      Uri.parse(
          'https://developerxpb.com.br/api/rotina-has-treinos?rotinaId=${event.rotinaId}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> treinosRelacionados = data['data'];

      if (treinosRelacionados.isEmpty) {
        emit(RotinaHasTreinoLoaded([])); // Se não houver treinos, retorna lista vazia
      } else {
        emit(RotinaHasTreinoLoaded(treinosRelacionados));
      }
    } else {
      emit(RotinaHasTreinoFailure('Falha ao carregar a relação rotina-treino'));
    }
  } catch (e) {
    emit(RotinaHasTreinoFailure(e.toString()));
  }
}



Future<void> _onCreateRotinaHasTreino(
    CreateRotinaHasTreino event, Emitter<RotinaHasTreinoState> emit) async {
  emit(RotinaHasTreinoLoading());
  try {
    final token = await getToken(); // Obtém o token de autorização
    print('Token obtido: $token'); // Log do token

    final rotinaHasTreinoDataJson = jsonEncode(event.rotinaHasTreinoData);
    print(
        'Dados da rotina com treino sendo enviados: $rotinaHasTreinoDataJson'); // Log dos dados da rotina com treino

    final response = await http.post(
      Uri.parse('https://developerxpb.com.br/api/rotina-has-treinos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: rotinaHasTreinoDataJson,
    );

    print(
        'Status da resposta: ${response.statusCode}'); // Log do status da resposta
    print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

    if (response.statusCode == 201) {
      emit(RotinaHasTreinoSuccess('Rotina com treino criada com sucesso'));
      print('Rotina com treino criada com sucesso'); // Log de sucesso
    } else {
      emit(RotinaHasTreinoFailure('Failed to create rotina com treino'));
      print(
          'Falha ao criar rotina com treino: ${response.statusCode}'); // Log de falha
    }
  } catch (e) {
    emit(RotinaHasTreinoFailure(e.toString()));
    print('Erro ao criar rotina com treino: $e'); // Log de exceção
  }
}

Future<void> _onGetRotinaHasTreino(
    GetRotinaHasTreino event, Emitter<RotinaHasTreinoState> emit) async {
  emit(RotinaHasTreinoLoading());
  try {
    final token = await getToken(); // Obtém o token de autorização
    print('Token obtido: $token'); // Log do token

    final response = await http.get(
      Uri.parse(
          'https://developerxpb.com.br/api/rotina-has-treinos/${event.id}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(
        'Status da resposta: ${response.statusCode}'); // Log do status da resposta
    print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      emit(RotinaHasTreinoDetailLoaded(data));
      print(
          'Detalhes da rotina com treino carregados com sucesso'); // Log de sucesso
    } else {
      emit(RotinaHasTreinoFailure('Failed to load rotina com treino'));
      print(
          'Falha ao carregar rotina com treino: ${response.statusCode}'); // Log de falha
    }
  } catch (e) {
    emit(RotinaHasTreinoFailure(e.toString()));
    print(
        'Erro ao carregar detalhes da rotina com treino: $e'); // Log de exceção
  }
}

Future<void> _onUpdateRotinaHasTreino(
    UpdateRotinaHasTreino event, Emitter<RotinaHasTreinoState> emit) async {
  emit(RotinaHasTreinoLoading());
  try {
    final token = await getToken(); // Obtém o token de autorização
    print('Token obtido: $token'); // Log do token

    final rotinaHasTreinoDataJson = jsonEncode(event.rotinaHasTreinoData);
    print(
        'Dados da rotina com treino sendo enviados: $rotinaHasTreinoDataJson'); // Log dos dados da rotina com treino

    final response = await http.put(
      Uri.parse(
          'https://developerxpb.com.br/api/rotina-has-treinos/${event.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: rotinaHasTreinoDataJson,
    );

    print(
        'Status da resposta: ${response.statusCode}'); // Log do status da resposta
    print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

    if (response.statusCode == 200) {
      emit(RotinaHasTreinoSuccess('Rotina com treino atualizada com sucesso'));
      print('Rotina com treino atualizada com sucesso'); // Log de sucesso
    } else {
      emit(RotinaHasTreinoFailure('Failed to update rotina com treino'));
      print(
          'Falha ao atualizar rotina com treino: ${response.statusCode}'); // Log de falha
    }
  } catch (e) {
    emit(RotinaHasTreinoFailure(e.toString()));
    print('Erro ao atualizar rotina com treino: $e'); // Log de exceção
  }
}

Future<void> _onDeleteRotinaHasTreino(
    DeleteRotinaHasTreino event, Emitter<RotinaHasTreinoState> emit) async {
  emit(RotinaHasTreinoLoading());
  try {
    final token = await getToken(); // Obtém o token de autorização
    print('Token obtido: $token'); // Log do token

    final response = await http.delete(
      Uri.parse(
          'https://developerxpb.com.br/api/rotina-has-treinos/${event.id}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(
        'Status da resposta: ${response.statusCode}'); // Log do status da resposta
    print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

    if (response.statusCode == 200) {
      emit(RotinaHasTreinoSuccess('Rotina com treino deletada com sucesso'));
      print('Rotina com treino deletada com sucesso'); // Log de sucesso
    } else {
      emit(RotinaHasTreinoFailure('Failed to delete rotina com treino'));
      print(
          'Falha ao deletar rotina com treino: ${response.statusCode}'); // Log de falha
    }
  } catch (e) {
    emit(RotinaHasTreinoFailure(e.toString()));
    print('Erro ao deletar rotina com treino: $e'); // Log de exceção
  }
}
    }