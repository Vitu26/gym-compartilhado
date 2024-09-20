import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_event.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_state.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart'; // Utilitário para obter o token

class RotinaDeTreinoBloc extends Bloc<RotinaDeTreinoEvent, RotinaDeTreinoState> {
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
      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/rotina-de-treino'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data')) {
          final rotinas = responseData['data'];
          if (rotinas is List) {
            emit(RotinaDeTreinoLoaded(rotinas));
          } else {
            emit(RotinaDeTreinoFailure('Data field is not a list'));
          }
        } else {
          emit(RotinaDeTreinoFailure('Data field not found in response'));
        }
      } else {
        emit(RotinaDeTreinoFailure('Failed to load rotinas de treino'));
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
    }
  }

  Future<void> _onCreateRotinaDeTreino(
      CreateRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
    emit(RotinaDeTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      final rotinaDataJson = jsonEncode(event.rotinaData);
      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/rotina-de-treino'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: rotinaDataJson,
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final rotinaDeTreinoId = responseData['data']['id']; // Capture o ID da resposta

        emit(RotinaDeTreinoSuccess(
          'Rotina de treino criada com sucesso',
          rotinaDeTreinoId: rotinaDeTreinoId, // Passe o ID aqui
        ));
      } else {
        emit(RotinaDeTreinoFailure('Falha ao criar rotina de treino'));
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
    }
  }

  Future<void> _onGetRotinaDeTreino(
      GetRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
    emit(RotinaDeTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/rotina-de-treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(RotinaDeTreinoDetailLoaded(data));
      } else {
        emit(RotinaDeTreinoFailure('Failed to load rotina de treino'));
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
    }
  }

  Future<void> _onUpdateRotinaDeTreino(
      UpdateRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
    emit(RotinaDeTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      final rotinaDataJson = jsonEncode(event.rotinaData);
      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/rotina-de-treino/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: rotinaDataJson,
      );

      if (response.statusCode == 200) {
        emit(RotinaDeTreinoSuccess('Rotina de treino atualizada com sucesso'));
      } else {
        emit(RotinaDeTreinoFailure('Failed to update rotina de treino'));
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
    }
  }

  Future<void> _onDeleteRotinaDeTreino(
      DeleteRotinaDeTreino event, Emitter<RotinaDeTreinoState> emit) async {
    emit(RotinaDeTreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/rotina-de-treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(RotinaDeTreinoSuccess('Rotina de treino deletada com sucesso'));
      } else {
        emit(RotinaDeTreinoFailure('Failed to delete rotina de treino'));
      }
    } catch (e) {
      emit(RotinaDeTreinoFailure(e.toString()));
    }
  }
}
