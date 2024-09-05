import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:sprylife/bloc/faturas/fatruas_event.dart';
import 'package:sprylife/bloc/faturas/faturas_state.dart';
import 'dart:convert';

import 'package:sprylife/utils/token_storege.dart'; // Supondo que você tenha um utilitário para obter o token

class FaturaBloc extends Bloc<FaturaEvent, FaturaState> {
  FaturaBloc() : super(FaturaInitial()) {
    on<GetAllFaturas>(_onGetAllFaturas);
    on<CreateFatura>(_onCreateFatura);
    on<GetFatura>(_onGetFatura);
    on<UpdateFatura>(_onUpdateFatura);
    on<DeleteFatura>(_onDeleteFatura);
  }

  Future<void> _onGetAllFaturas(
      GetAllFaturas event, Emitter<FaturaState> emit) async {
    emit(FaturaLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/faturas'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(FaturaLoaded(data));
      } else {
        emit(FaturaFailure('Failed to load faturas'));
      }
    } catch (e) {
      emit(FaturaFailure(e.toString()));
    }
  }

  Future<void> _onCreateFatura(
      CreateFatura event, Emitter<FaturaState> emit) async {
    emit(FaturaLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/faturas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.faturaData),
      );

      if (response.statusCode == 201) {
        emit(FaturaSuccess('Fatura criada com sucesso'));
      } else {
        emit(FaturaFailure('Failed to create fatura'));
      }
    } catch (e) {
      emit(FaturaFailure(e.toString()));
    }
  }

  Future<void> _onGetFatura(GetFatura event, Emitter<FaturaState> emit) async {
    emit(FaturaLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/faturas/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(FaturaDetailLoaded(data));
      } else {
        emit(FaturaFailure('Failed to load fatura'));
      }
    } catch (e) {
      emit(FaturaFailure(e.toString()));
    }
  }

  Future<void> _onUpdateFatura(
      UpdateFatura event, Emitter<FaturaState> emit) async {
    emit(FaturaLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/faturas/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.faturaData),
      );

      if (response.statusCode == 200) {
        emit(FaturaSuccess('Fatura atualizada com sucesso'));
      } else {
        emit(FaturaFailure('Failed to update fatura'));
      }
    } catch (e) {
      emit(FaturaFailure(e.toString()));
    }
  }

  Future<void> _onDeleteFatura(
      DeleteFatura event, Emitter<FaturaState> emit) async {
    emit(FaturaLoading());
    try {
      final token = await getToken(); // Obtém o token de autorização

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/faturas/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(FaturaSuccess('Fatura deletada com sucesso'));
      } else {
        emit(FaturaFailure('Failed to delete fatura'));
      }
    } catch (e) {
      emit(FaturaFailure(e.toString()));
    }
  }
}
