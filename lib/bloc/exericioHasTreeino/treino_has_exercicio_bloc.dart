import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exercicio_state.dart';
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exericio_event.dart';
import 'dart:convert';
import 'package:sprylife/utils/token_storege.dart';

class ExercicioTreinoBloc extends Bloc<ExercicioTreinoEvent, ExercicioTreinoState> {
  ExercicioTreinoBloc() : super(ExercicioTreinoInitial()) {
    on<GetAllTreinosComExercicios>(_onGetAllTreinosComExercicios);
    on<AddExercicioToTreino>(_onAddExercicioToTreino);
    on<GetTreinoComExercicio>(_onGetTreinoComExercicio);
    on<DeleteExercicioFromTreino>(_onDeleteExercicioFromTreino);
  }

  Future<void> _onGetAllTreinosComExercicios(
      GetAllTreinosComExercicios event, Emitter<ExercicioTreinoState> emit) async {
    emit(ExercicioTreinoLoading());
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/treinos_has_exercicios'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        emit(ExercicioTreinoLoaded(data));
      } else {
        emit(ExercicioTreinoFailure('Erro ao carregar treinos com exercícios.'));
      }
    } catch (e) {
      emit(ExercicioTreinoFailure(e.toString()));
    }
  }

  Future<void> _onAddExercicioToTreino(
      AddExercicioToTreino event, Emitter<ExercicioTreinoState> emit) async {
    emit(ExercicioTreinoLoading());
    try {
      final token = await getToken();

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/treinos_has_exercicios'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'treinos_id': event.treinoId,
          'exercicios_id': event.exercicioId,
        }),
      );

      if (response.statusCode == 201) {
        emit(ExercicioTreinoAdded('Exercício adicionado com sucesso.'));
      } else {
        emit(ExercicioTreinoFailure('Erro ao adicionar exercício ao treino.'));
      }
    } catch (e) {
      emit(ExercicioTreinoFailure(e.toString()));
    }
  }

  Future<void> _onGetTreinoComExercicio(
      GetTreinoComExercicio event, Emitter<ExercicioTreinoState> emit) async {
    emit(ExercicioTreinoLoading());
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/treinos_has_exercicios/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(ExercicioTreinoLoaded([data]));
      } else {
        emit(ExercicioTreinoFailure('Erro ao carregar o treino com exercícios.'));
      }
    } catch (e) {
      emit(ExercicioTreinoFailure(e.toString()));
    }
  }

  Future<void> _onDeleteExercicioFromTreino(
      DeleteExercicioFromTreino event, Emitter<ExercicioTreinoState> emit) async {
    emit(ExercicioTreinoLoading());
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/treinos_has_exercicios/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(ExercicioTreinoDeleted('Exercício removido do treino com sucesso.'));
      } else {
        emit(ExercicioTreinoFailure('Erro ao remover exercício do treino.'));
      }
    } catch (e) {
      emit(ExercicioTreinoFailure(e.toString()));
    }
  }
}
