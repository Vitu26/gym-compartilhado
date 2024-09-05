import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/exercicios/exercicios_event.dart';
import 'package:sprylife/bloc/exercicios/exercicios_state.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart';

class ExercicioBloc extends Bloc<ExercicioEvent, ExercicioState> {
  ExercicioBloc() : super(ExercicioInitial()) {
    on<GetAllExercicios>(_onGetAllExercicios);
    on<CreateExercicio>(_onCreateExercicio);
    on<GetExercicio>(_onGetExercicio);
    on<UpdateExercicio>(_onUpdateExercicio);
    on<DeleteExercicio>(_onDeleteExercicio);
    on<GetAllExerciciosForTreino>(_onGetAllExerciciosForTreino);
    on<GetAllExerciciosByCategory>(_onGetAllExerciciosByCategory);
    on<AddExerciseToTreino>(_onAddExerciseToTreino);
    on<RemoveExerciseFromTreino>(_onRemoveExerciseFromTreino);
  }

  // Implementação para obter todos os exercícios
  Future<void> _onGetAllExercicios(
      GetAllExercicios event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/exercicios'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final exercicios = data['data'];
        emit(ExercicioLoaded(exercicios));
      } else {
        emit(ExercicioFailure('Erro ao carregar exercícios.'));
      }
    } catch (e) {
      emit(ExercicioFailure(e.toString()));
    }
  }

  // Implementação para criar um novo exercício
  Future<void> _onCreateExercicio(
      CreateExercicio event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken();
      final exercicioDataJson = jsonEncode(event.exercicioData);

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/exercicios'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: exercicioDataJson,
      );

      if (response.statusCode == 201) {
        emit(ExercicioSuccess('Exercício criado com sucesso.'));
      } else {
        emit(ExercicioFailure('Erro ao criar exercício.'));
      }
    } catch (e) {
      emit(ExercicioFailure(e.toString()));
    }
  }

  // Implementação para obter um exercício específico
  Future<void> _onGetExercicio(
      GetExercicio event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/exercicios/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(ExercicioDetailLoaded(data));
      } else {
        emit(ExercicioFailure('Erro ao carregar exercício.'));
      }
    } catch (e) {
      emit(ExercicioFailure(e.toString()));
    }
  }

  // Implementação para atualizar um exercício
  Future<void> _onUpdateExercicio(
      UpdateExercicio event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken();
      final exercicioDataJson = jsonEncode(event.exercicioData);

      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/exercicios/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: exercicioDataJson,
      );

      if (response.statusCode == 200) {
        emit(ExercicioSuccess('Exercício atualizado com sucesso.'));
      } else {
        emit(ExercicioFailure('Erro ao atualizar exercício.'));
      }
    } catch (e) {
      emit(ExercicioFailure(e.toString()));
    }
  }

  // Implementação para deletar um exercício
  Future<void> _onDeleteExercicio(
      DeleteExercicio event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/exercicios/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(ExercicioSuccess('Exercício deletado com sucesso.'));
      } else {
        emit(ExercicioFailure('Erro ao deletar exercício.'));
      }
    } catch (e) {
      emit(ExercicioFailure(e.toString()));
    }
  }

  // Implementação para obter todos os exercícios de um treino
  Future<void> _onGetAllExerciciosForTreino(
      GetAllExerciciosForTreino event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse(
            'https://developerxpb.com.br/api/exercicios?treino=${event.treinoId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final exercicios = data['data'];
        emit(ExercicioLoaded(exercicios));
      } else {
        emit(ExercicioFailure('Erro ao carregar exercícios do treino.'));
      }
    } catch (e) {
      emit(ExercicioFailure(e.toString()));
    }
  }

  // Implementação para obter exercícios por categoria
  Future<void> _onGetAllExerciciosByCategory(
      GetAllExerciciosByCategory event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading()); // Exibe o estado de carregamento
    try {
      final token = await getToken(); // Obtém o token de autorização

      // Faz a requisição para buscar os exercícios da categoria
      final response = await http.get(
        Uri.parse(
            'https://developerxpb.com.br/api/exercicios?categoria=${event.categoryId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final exercicios = data['data'] ?? [];
        emit(ExercicioLoaded(exercicios)); // Emite os exercícios carregados
      } else {
        emit(ExercicioFailure('Erro ao carregar exercícios para a categoria.'));
      }
    } catch (e) {
      emit(ExercicioFailure('Erro ao carregar exercícios: $e'));
    }
  }

  // Implementação para adicionar um exercício a um treino
  Future<void> _onAddExerciseToTreino(
      AddExerciseToTreino event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização
      final body = jsonEncode({
        'treino_id': event.treinoId,
        'exercicio_id': event.exerciseId,
      });

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/treinos/add-exercicio'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        emit(ExercicioSuccess('Exercício adicionado com sucesso ao treino.'));
      } else {
        emit(ExercicioFailure('Erro ao adicionar exercício ao treino.'));
      }
    } catch (e) {
      emit(ExercicioFailure('Erro ao adicionar exercício ao treino: $e'));
    }
  }
  

  // Implementação para remover um exercício de um treino
  Future<void> _onRemoveExerciseFromTreino(
      RemoveExerciseFromTreino event, Emitter<ExercicioState> emit) async {
    emit(ExercicioLoading());
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse(
            'https://developerxpb.com.br/api/treinos/${event.treinoId}/exercicios/${event.exerciseId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(ExercicioSuccess('Exercício removido do treino com sucesso.'));
      } else {
        emit(ExercicioFailure('Erro ao remover exercício do treino.'));
      }
    } catch (e) {
      emit(ExercicioFailure(e.toString()));
    }
  }
}
