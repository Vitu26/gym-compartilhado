import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/treino/treino_event.dart';
import 'package:sprylife/bloc/treino/treino_state.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart'; // Supondo que você tenha um utilitário para obter o token

class TreinoBloc extends Bloc<TreinoEvent, TreinoState> {
  TreinoBloc() : super(TreinoInitial()) {
    on<GetAllTreinos>(_onGetAllTreinos);
    on<CreateTreino>(_onCreateTreino);
    on<GetTreino>(_onGetTreino);
    on<UpdateTreino>(_onUpdateTreino);
    on<DeleteTreino>(_onDeleteTreino);
    on<AssociateTreinoToRoutine>(_onAssociateTreinoToRoutine);
  }

  Future<void> _onAssociateTreinoToRoutine(
      AssociateTreinoToRoutine event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/rotina-has-treinos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.associarData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(TreinoSuccess('Treino associado à rotina com sucesso'));
      } else {
        emit(TreinoFailure(
            'Erro ao associar treino à rotina. Status: ${response.statusCode}'));
      }
    } catch (e) {
      emit(TreinoFailure(e.toString()));
    }
  }

  Future<void> _onGetAllTreinos(
      GetAllTreinos event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/treino'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Acessa a lista de treinos dentro do mapa
        final treinos = data['data'] as List<dynamic>;

        emit(TreinoLoaded(treinos));
        print('Treinos carregados com sucesso'); // Log de sucesso
      } else {
        emit(TreinoFailure('Failed to load treinos'));
        print(
            'Falha ao carregar treinos: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TreinoFailure(e.toString()));
      print('Erro ao carregar treinos: $e'); // Log de exceção
    }
  }

  // Future<void> _onCreateTreino(
  //     CreateTreino event, Emitter<TreinoState> emit) async {
  //   emit(TreinoLoading());
  //   try {
  //     final token = await getToken(); // Obtém o token de autorização
  //     print('Token obtido: $token'); // Log do token

  //     final treinoDataJson = jsonEncode(event.treinoData);
  //     print(
  //         'Dados do treino sendo enviados: $treinoDataJson'); // Log dos dados do treino

  //     final response = await http.post(
  //       Uri.parse('https://developerxpb.com.br/api/treino'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: treinoDataJson,
  //     );

  //     print('Status da resposta (criação de treino): ${response.statusCode}');
  //     print(
  //         'Corpo da resposta (criação de treino): ${response.body}'); // Log do corpo da resposta

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final treinoData = jsonDecode(response.body)['data'];
  //       final treinoId = treinoData['id'];

  //       print('Treino criado com sucesso. Treino ID: $treinoId');

  //       // Agora cria a associação na tabela rotina-has-treino
  //       final rotinaHasTreinoData = {
  //         'rotina-de-treino_id': event.rotinaDeTreinoId,
  //         'treino_id': treinoId
  //       };

  //       print('Dados enviados para rotina-has-treino: $rotinaHasTreinoData');

  //       final rotinaHasTreinoResponse = await http.post(
  //         Uri.parse('https://developerxpb.com.br/api/rotina-has-treinos'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //         body: jsonEncode(rotinaHasTreinoData),
  //       );

  //       print('Treino ID para associação: $treinoId');
  //       ;
  //       print('Dados enviados para rotina-has-treino: $rotinaHasTreinoData');

  //       print(
  //           'Status da resposta (associação treino e rotina): ${rotinaHasTreinoResponse.statusCode}');
  //       print(
  //           'Corpo da resposta (associação treino e rotina): ${rotinaHasTreinoResponse.body}'); // Log do corpo da resposta

  //       if (rotinaHasTreinoResponse.statusCode == 200 ||
  //           rotinaHasTreinoResponse.statusCode == 201) {
  //         emit(TreinoSuccess('Treino criado e associado à rotina com sucesso'));
  //         print('Associação entre treino e rotina criada com sucesso');
  //       } else {
  //         emit(TreinoFailure(
  //             'Erro ao associar treino à rotina. Status: ${rotinaHasTreinoResponse.statusCode}'));
  //         print(
  //             'Erro ao associar treino à rotina. Status: ${rotinaHasTreinoResponse.statusCode}');
  //         print('Corpo da resposta (erro): ${rotinaHasTreinoResponse.body}');
  //       }
  //     } else {
  //       emit(TreinoFailure(
  //           'Falha ao criar treino. Status: ${response.statusCode}'));
  //       print('Falha ao criar treino: ${response.statusCode}');
  //       print('Corpo da resposta (erro): ${response.body}');
  //     }
  //   } catch (e) {
  //     emit(TreinoFailure(e.toString()));
  //     print('Erro ao criar treino: $e');
  //   }
  // }

  // treino_bloc.dart
  Future<void> _onCreateTreino(
      CreateTreino event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      // Envia os dados do treino para criação
      final treinoDataJson = jsonEncode(event.treinoData);
      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/treino'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: treinoDataJson,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sucesso na criação do treino, vamos associar à rotina
        final treinoData = jsonDecode(response.body)['data'];
        final treinoId = treinoData['id']; // ID do treino criado
        print('Treino criado com sucesso. Treino ID: $treinoId');

        // Criar a associação entre o treino e a rotina
        final rotinaHasTreinoData = {
          'rotina-de-treino_id': event.rotinaDeTreinoId,
          'treino_id': treinoId
        };

        // Faz a requisição para associar o treino à rotina
        final associarResponse = await http.post(
          Uri.parse('https://developerxpb.com.br/api/rotina-has-treinos'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(rotinaHasTreinoData),
        );

        if (associarResponse.statusCode == 200 ||
            associarResponse.statusCode == 201) {
          // Sucesso na associação
          emit(TreinoSuccess('Treino criado e associado à rotina com sucesso'));
          print('Associação entre treino e rotina criada com sucesso');
        } else {
          emit(TreinoFailure(
              'Erro ao associar treino à rotina. Status: ${associarResponse.statusCode}'));
          print(
              'Erro ao associar treino à rotina. Status: ${associarResponse.statusCode}');
        }
      } else {
        emit(TreinoFailure(
            'Falha ao criar treino. Status: ${response.statusCode}'));
        print('Falha ao criar treino: ${response.statusCode}');
      }
    } catch (e) {
      emit(TreinoFailure(e.toString()));
      print('Erro ao criar treino: $e');
    }
  }

  Future<void> _onGetTreino(GetTreino event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(TreinoDetailLoaded(data));
        print('Detalhes do treino carregados com sucesso'); // Log de sucesso
      } else {
        emit(TreinoFailure('Failed to load treino'));
        print(
            'Falha ao carregar treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TreinoFailure(e.toString()));
      print('Erro ao carregar detalhes do treino: $e'); // Log de exceção
    }
  }

  Future<void> _onUpdateTreino(
      UpdateTreino event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final treinoDataJson = jsonEncode(event.treinoData);
      print(
          'Dados do treino sendo enviados: $treinoDataJson'); // Log dos dados do treino

      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/treino/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: treinoDataJson,
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(TreinoSuccess('Treino atualizado com sucesso'));
        print('Treino atualizado com sucesso'); // Log de sucesso
      } else {
        emit(TreinoFailure('Failed to update treino'));
        print(
            'Falha ao atualizar treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TreinoFailure(e.toString()));
      print('Erro ao atualizar treino: $e'); // Log de exceção
    }
  }

  Future<void> _onDeleteTreino(
      DeleteTreino event, Emitter<TreinoState> emit) async {
    emit(TreinoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/treino/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(TreinoSuccess('Treino deletado com sucesso'));
        print('Treino deletado com sucesso'); // Log de sucesso
      } else {
        emit(TreinoFailure('Failed to delete treino'));
        print(
            'Falha ao deletar treino: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(TreinoFailure(e.toString()));
      print('Erro ao deletar treino: $e'); // Log de exceção
    }
  }
}
