import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';
import 'package:sprylife/utils/token_storege.dart';

class PersonalBloc extends Bloc<PersonalEvent, PersonalState> {
  PersonalBloc() : super(PersonalInitial()) {
    on<PersonalLogin>(_onPersonalLogin);
    on<PersonalCadastro>(_onPersonalCadastro);
    on<GetAllPersonais>(_onGetAllPersonais);
    on<GetPersonal>(_onGetPersonal);
    on<UpdatePersonal>(_onUpdatePersonal);
    on<DeletePersonal>(_onDeletePersonal);
    on<GetPersonalPassword>(_onGetPersonalPassword);
    on<UpdatePersonalPassword>(_onUpdatePersonalPassword);
    on<UpdatePersonalProfile>(_onUpdatePersonalProfile);
  }

  // Login do Personal
  Future<void> _onPersonalLogin(
      PersonalLogin event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading()); // Emitindo estado de carregamento
    try {
      print('Iniciando processo de login...');
      final token = await getToken(); // Obtendo o token
      print('Token obtido: $token');

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/autentication/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': event.email,
          'password': event.password,
        }),
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print('Chaves do objeto data: ${decodedResponse.keys}');

        final String? table = decodedResponse['table'] as String?;
        final Map<String, dynamic>? professionalData =
            decodedResponse['data'] as Map<String, dynamic>?;

        // Verifique se as variáveis 'table' e 'professionalData' não são nulas
        if (table != null && professionalData != null) {
          print('Tipo de "table": ${table.runtimeType}');
          print('Tipo de "data": ${professionalData.runtimeType}');
          print('Conteúdo de "data": $professionalData');

          if (table == 'personals') {
            emit(PersonalSuccess(
                professionalData)); // Emite sucesso com os dados do personal
          } else {
            print(
                "Erro: Estrutura de resposta inesperada. Esperava 'personals' como table.");
            emit(PersonalFailure(
                'Erro: Estrutura de resposta inesperada. Esperava "personals" como table.'));
          }
        } else {
          print("Erro: 'table' ou 'data' são nulos.");
          emit(PersonalFailure(
              'Erro: Estrutura de resposta inesperada. Esperava "table" e "data".'));
        }
      } else {
        print('Erro: Login falhou com status: ${response.statusCode}');
        emit(
            PersonalFailure('Login falhou com status: ${response.statusCode}'));
      }
    } catch (e) {
      print('Exceção durante o login: $e');
      emit(PersonalFailure('Login falhou com exceção: $e'));
    }
  }

  Future<void> _onPersonalCadastro(
      PersonalCadastro event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading()); // Emitindo estado de carregamento
    try {
      final token = await getToken();
      print("Token obtido: $token");

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/personal'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.personalData),
      );

      print("Status da resposta: ${response.statusCode}");
      print("Corpo da resposta: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Dados do personal recebidos: $data");
        emit(PersonalSuccess(data)); // Emite sucesso com os dados do personal
        if (data['data'] == null) {
          emit(PersonalFailure('Erro: Dados do personal não encontrados.'));
        } else {
          emit(PersonalSuccess(data['data']));
        }
      } else {
        print("Falha ao cadastrar o personal");
        emit(PersonalFailure('Cadastro falhou'));
      }
    } catch (e) {
      print("Erro ao cadastrar o personal: $e");
      emit(PersonalFailure(e.toString()));
    }
  }

  // Obtenção de todos os Personais
  Future<void> _onGetAllPersonais(
    GetAllPersonais event,
    Emitter<PersonalState> emit,
  ) async {
    emit(PersonalLoading()); // Emitindo estado de carregamento
    try {
      final token = await getToken();

      Uri uri = Uri.parse('https://developerxpb.com.br/api/personal').replace(
        queryParameters: {
          if (event.professionalType != null)
            'especialidade-do-personal': event.professionalType,
          if (event.gender != null) 'gender': event.gender,
          if (event.attendanceType != null)
            'attendanceType': event.attendanceType,
          if (event.modalities != null && event.modalities!.isNotEmpty)
            'modalities': event.modalities?.join(','),
          if (event.freeTrial != null) 'freeTrial': event.freeTrial.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(PersonalSuccess(data)); // Emite sucesso com os dados dos personais
      } else {
        emit(PersonalFailure('Falha ao obter personal'));
      }
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }

  // Obtenção de um personal específico
  Future<void> _onGetPersonal(
      GetPersonal event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading()); // Emitindo estado de carregamento
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/personal/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(PersonalSuccess(
            data)); // Emite sucesso com os dados do personal específico
      } else {
        emit(PersonalFailure('Failed to fetch personal'));
      }
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }

  // Atualização de um personal
  Future<void> _onUpdatePersonal(
      UpdatePersonal event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading()); // Emit loading state
    try {
      final token = await getToken();

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('https://developerxpb.com.br/api/personal/${event.id}'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add fields
      event.personalData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add image if provided
      if (event.image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('foto', event.image!.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(PersonalSuccess(data)); // Emit success with updated data
      } else {
        emit(PersonalFailure('Update failed'));
      }
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }

  // Exclusão de um personal
  Future<void> _onDeletePersonal(
      DeletePersonal event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading()); // Emitindo estado de carregamento
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/personal/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(PersonalSuccess(
            'Personal deleted')); // Emite sucesso com a mensagem de exclusão
      } else {
        emit(PersonalFailure('Delete failed'));
      }
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }

  // Fetch the current password (or a hashed version, depending on your security needs)
  Future<void> _onGetPersonalPassword(
      GetPersonalPassword event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading());
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/personal/password'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final password =
            data['password']; // Adjust based on your API response structure
        emit(PersonalPasswordLoaded(password));
      } else {
        emit(PersonalFailure('Failed to fetch personal password'));
      }
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }

  Future<void> _onUpdatePersonalPassword(
      UpdatePersonalPassword event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading());
    try {
      final token = await getToken();
      final response = await http.put(
        Uri.parse('https://developerxpb.com.br/api/personal/password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': event.currentPassword,
          'newPassword': event.newPassword,
        }),
      );

      if (response.statusCode == 200) {
        emit(PersonalSuccess('Password updated successfully'));
      } else {
        emit(PersonalFailure('Failed to update password'));
      }
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }

    // Lógica de atualização de perfil, incluindo upload de imagem
  Future<void> _onUpdatePersonalProfile(
      UpdatePersonalProfile event, Emitter<PersonalState> emit) async {
    emit(PersonalLoading()); // Emitir estado de carregamento

    try {
      final String? token = await getToken();

      // Converter o mapa dinâmico para Map<String, String> para compatibilidade
      final Map<String, String> updatedData = event.updatedData.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      if (event.image != null) {
        // Se uma imagem foi selecionada, enviar uma requisição multipart
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://developerxpb.com.br/api/personal/update'),
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(updatedData);
        request.files.add(
            await http.MultipartFile.fromPath('foto', event.image!.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          emit(PersonalSuccess('Perfil atualizado com sucesso com imagem'));
        } else {
          emit(PersonalFailure('Falha ao atualizar perfil com imagem'));
        }
      } else {
        // Se nenhuma imagem foi selecionada, enviar uma requisição PUT normal
        final response = await http.put(
          Uri.parse('https://developerxpb.com.br/api/personal/update'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(updatedData),
        );

        if (response.statusCode == 200) {
          emit(PersonalSuccess('Perfil atualizado com sucesso'));
        } else {
          emit(PersonalFailure('Falha ao atualizar perfil'));
        }
      }
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }
}






