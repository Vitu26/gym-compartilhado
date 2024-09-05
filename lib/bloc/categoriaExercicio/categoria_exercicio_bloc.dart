import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/categoriaExercicio/categoria_exercicio_event.dart';
import 'package:sprylife/bloc/categoriaExercicio/categoria_exercicio_state.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart'; // Supondo que você tenha um utilitário para obter o token

class CategoriaExercicioBloc
    extends Bloc<CategoriaExercicioEvent, CategoriaExercicioState> {
  CategoriaExercicioBloc() : super(CategoriaExercicioInitial()) {
    on<GetAllCategoriasExercicio>(_onGetAllCategoriasExercicio);
    on<CreateCategoriaExercicio>(_onCreateCategoriaExercicio);
    on<GetCategoriaExercicio>(_onGetCategoriaExercicio);
    on<UpdateCategoriaExercicio>(_onUpdateCategoriaExercicio);
    on<DeleteCategoriaExercicio>(_onDeleteCategoriaExercicio);
  }

  Future<void> _onGetAllCategoriasExercicio(GetAllCategoriasExercicio event,
      Emitter<CategoriaExercicioState> emit) async {
    emit(CategoriaExercicioLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/categoria-exercicios'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verifica se o campo 'data' contém a lista das categorias
        final categorias =
            data['data']; // Acessa a lista de categorias dentro do campo 'data'

        emit(CategoriaExercicioLoaded(categorias));
        print(
            'Categorias carregadas com sucesso: $categorias'); // Log de sucesso
      } else {
        emit(CategoriaExercicioFailure('Failed to load categorias'));
        print(
            'Falha ao carregar categorias: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(CategoriaExercicioFailure(e.toString()));
      print('Erro ao carregar categorias: $e'); // Log de exceção
    }
  }

  Future<void> _onCreateCategoriaExercicio(CreateCategoriaExercicio event,
      Emitter<CategoriaExercicioState> emit) async {
    emit(CategoriaExercicioLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final categoriaDataJson = jsonEncode(event.categoriaData);
      print(
          'Dados da categoria sendo enviados: $categoriaDataJson'); // Log dos dados da categoria

      final response = await http.post(
        Uri.parse(
            'https://developerxpb.com.br/api/categoria-exercicios'), // Endpoint correto
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: categoriaDataJson,
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 201) {
        emit(CategoriaExercicioSuccess(
            'Categoria de Exercicio criada com sucesso'));
        print('Categoria criada com sucesso'); // Log de sucesso
      } else {
        emit(CategoriaExercicioFailure(
            'Falha ao criar categoria: ${response.statusCode}'));
        print(
            'Falha ao criar categoria: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(CategoriaExercicioFailure(e.toString()));
      print('Erro ao criar categoria: $e'); // Log de exceção
    }
  }

  Future<void> _onGetCategoriaExercicio(GetCategoriaExercicio event,
      Emitter<CategoriaExercicioState> emit) async {
    emit(CategoriaExercicioLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.get(
        Uri.parse(
            'https://developerxpb.com.br/api/categoria-exercicios/${event.id}'), // Endpoint correto
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(CategoriaExercicioDetailLoaded(data));
        print('Categoria carregada com sucesso'); // Log de sucesso
      } else {
        emit(CategoriaExercicioFailure(
            'Falha ao carregar categoria: ${response.statusCode}'));
        print(
            'Falha ao carregar categoria: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(CategoriaExercicioFailure(e.toString()));
      print('Erro ao carregar categoria: $e'); // Log de exceção
    }
  }

  Future<void> _onUpdateCategoriaExercicio(UpdateCategoriaExercicio event,
      Emitter<CategoriaExercicioState> emit) async {
    emit(CategoriaExercicioLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final categoriaDataJson = jsonEncode(event.categoriaData);
      print(
          'Dados da categoria sendo enviados: $categoriaDataJson'); // Log dos dados da categoria

      final response = await http.put(
        Uri.parse(
            'https://developerxpb.com.br/api/categoria-exercicios'), // Endpoint correto
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: categoriaDataJson,
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(CategoriaExercicioSuccess(
            'Categoria de Exercicio atualizada com sucesso'));
        print('Categoria atualizada com sucesso'); // Log de sucesso
      } else {
        emit(CategoriaExercicioFailure(
            'Falha ao atualizar categoria: ${response.statusCode}'));
        print(
            'Falha ao atualizar categoria: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(CategoriaExercicioFailure(e.toString()));
      print('Erro ao atualizar categoria: $e'); // Log de exceção
    }
  }

  Future<void> _onDeleteCategoriaExercicio(DeleteCategoriaExercicio event,
      Emitter<CategoriaExercicioState> emit) async {
    emit(CategoriaExercicioLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      print('Token obtido: $token'); // Log do token

      final response = await http.delete(
        Uri.parse(
            'https://developerxpb.com.br/api/categoria-exercicios/${event.id}'), // Endpoint correto
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta: ${response.statusCode}'); // Log do status da resposta
      print('Corpo da resposta: ${response.body}'); // Log do corpo da resposta

      if (response.statusCode == 200) {
        emit(CategoriaExercicioSuccess(
            'Categoria de Exercicio deletada com sucesso'));
        print('Categoria deletada com sucesso'); // Log de sucesso
      } else {
        emit(CategoriaExercicioFailure(
            'Falha ao deletar categoria: ${response.statusCode}'));
        print(
            'Falha ao deletar categoria: ${response.statusCode}'); // Log de falha
      }
    } catch (e) {
      emit(CategoriaExercicioFailure(e.toString()));
      print('Erro ao deletar categoria: $e'); // Log de exceção
    }
  }
}
