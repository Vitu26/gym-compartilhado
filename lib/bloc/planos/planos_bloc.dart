import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprylife/bloc/planos/planos_event.dart';
import 'package:sprylife/bloc/planos/planos_state.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart'; // Supondo que você tenha um utilitário para obter o token

class PlanoBloc extends Bloc<PlanoEvent, PlanoState> {
  PlanoBloc() : super(PlanoInitial()) {
    on<GetAllPlanos>(_onGetAllPlanos);
    on<CreatePlano>(_onCreatePlano);
    on<GetPlano>(_onGetPlano);
    on<UpdatePlano>(_onUpdatePlano);
    on<DeletePlano>(_onDeletePlano);
  }

  Future<void> _onGetAllPlanos(
      GetAllPlanos event, Emitter<PlanoState> emit) async {
    emit(PlanoLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token');

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/planos'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        print('Dados decodificados: $decodedData');

        if (decodedData['data'] is List) {
          final List<dynamic> planos = decodedData['data'];

          // Verificar tipo de dados do campo específico
          for (var plano in planos) {
            print('Plano ID: ${plano['id']}, Tipo: ${plano['id'].runtimeType}');
            print(
                'Nome do Plano: ${plano['nome-do-plano']}, Tipo: ${plano['nome-do-plano'].runtimeType}');
          }

          emit(PlanoLoaded(planos));
          print('Planos carregados com sucesso: $planos');
        } else {
          emit(PlanoFailure('Expected a list but received a map'));
          print(
              'Erro ao carregar os planos: Expected a list but received a map');
        }
      } else {
        emit(PlanoFailure('Failed to load planos'));
        print('Falha ao carregar planos: ${response.statusCode}');
      }
    } catch (e) {
      emit(PlanoFailure(e.toString()));
      print('Erro ao carregar os planos: $e');
    }
  }

Future<void> _onCreatePlano(CreatePlano event, Emitter<PlanoState> emit) async {
  emit(PlanoLoading());
  print("Iniciando criação de plano com os dados: ${event.planoData}");

  try {
    // Busca o personal logado
    final personalData = await getPersonalLogado();
    final String personalId = personalData['id'];

    if (personalId.isEmpty) {
      emit(PlanoFailure('ID do personal não encontrado. Certifique-se de que o personal está logado.'));
      return;
    }

    final token = await getToken(); // Obtém o token de autorização

    print('Dados que serão enviados: ${jsonEncode(event.planoData)}');

    final response = await http.post(
      Uri.parse('https://developerxpb.com.br/api/planos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(event.planoData..['personal_id'] = personalId), // Adiciona o personal_id aos dados do plano
    );

    print('Status da resposta: ${response.statusCode}');
    print('Corpo da resposta: ${response.body}');

    if (response.statusCode == 201) {
      emit(PlanoSuccess('Plano criado com sucesso'));
      print("Plano criado com sucesso.");
    } else {
      emit(PlanoFailure('Failed to create plano'));
      print("Erro ao criar o plano: ${response.body}");
    }
  } catch (e) {
    emit(PlanoFailure(e.toString()));
    print("Erro ao criar o plano: $e");
  }
}


  Future<void> _onGetPlano(GetPlano event, Emitter<PlanoState> emit) async {
    emit(PlanoLoading());
    print("Iniciando carregamento do plano com ID: ${event.id}");
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/planos/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Plano carregado com sucesso: $data");
        emit(PlanoDetailLoaded(data));
      } else {
        print(
            "Falha ao carregar o plano. Código de status: ${response.statusCode}");
        emit(PlanoFailure('Failed to load plano'));
      }
    } catch (e) {
      print("Erro ao carregar o plano: $e");
      emit(PlanoFailure(e.toString()));
    }
  }

  Future<void> _onUpdatePlano(
      UpdatePlano event, Emitter<PlanoState> emit) async {
    emit(PlanoLoading());
    print(
        "Iniciando atualização do plano com ID: ${event.id} e dados: ${event.planoData}");
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/planos/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.planoData),
      );

      if (response.statusCode == 200) {
        print("Plano atualizado com sucesso.");
        emit(PlanoSuccess('Plano atualizado com sucesso'));
      } else if (response.statusCode == 422) {
        print("Erro de validação ao atualizar plano: ${response.body}");
        emit(PlanoFailure(
            'Erro de validação ao atualizar plano: ${response.body}'));
      } else {
        print(
            "Falha ao atualizar o plano. Código de status: ${response.statusCode}");
        emit(PlanoFailure('Failed to update plano'));
      }
    } catch (e) {
      print("Erro ao atualizar o plano: $e");
      emit(PlanoFailure(e.toString()));
    }
  }

  Future<void> _onDeletePlano(
      DeletePlano event, Emitter<PlanoState> emit) async {
    emit(PlanoLoading());
    print("Iniciando exclusão do plano com ID: ${event.id}");
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/planos/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Plano deletado com sucesso.");
        emit(PlanoSuccess('Plano deletado com sucesso'));
      } else {
        print(
            "Falha ao deletar o plano. Código de status: ${response.statusCode}");
        emit(PlanoFailure('Failed to delete plano'));
      }
    } catch (e) {
      print("Erro ao deletar o plano: $e");
      emit(PlanoFailure(e.toString()));
    }
  }


Future<Map<String, dynamic>> getPersonalLogado() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? personalId = prefs.getString('personal_id');
  final String? personalNome = prefs.getString('personal_nome');

  if (personalId != null && personalNome != null) {
    return {
      'id': personalId,
      'nome': personalNome,
    };
  } else {
    throw Exception('Nenhum personal logado encontrado');
  }
}
}