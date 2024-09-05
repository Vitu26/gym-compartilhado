import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sprylife/bloc/aluno/aluno_evet.dart';
import 'package:sprylife/bloc/aluno/aluno_state.dart';
import 'package:sprylife/utils/token_storege.dart';

class AlunoBloc extends Bloc<AlunoEvent, AlunoState> {
  AlunoBloc() : super(AlunoInitial()) {
    on<AlunoLogin>(_onAlunoLogin);
    on<AlunoCadastro>(_onAlunoCadastro);
    on<GetAllAlunos>(_onGetAllAlunos);
    on<GetAluno>(_onGetAluno);
    on<UpdateAluno>(_onUpdateAluno);
    on<DeleteAluno>(_onDeleteAluno);
    on<FetchObjetivos>(_onFetchObjetivos);
    on<FetchModalidades>(_onFetchModalidades);
    on<FetchNiveisAtividade>(_onFetchNiveisAtividade);
  }

  @override
  Stream<AlunoState> mapEventToState(AlunoEvent event) async* {
    if (event is FetchAllData) {
      yield* _mapFetchAllDataToState();
    }
  }

  Stream<AlunoState> _mapFetchAllDataToState() async* {
    try {
      // Acione eventos que geram as requisições de fetch
      add(FetchObjetivos());
      add(FetchModalidades());
      add(FetchNiveisAtividade());

      await Future.delayed(Duration(
          seconds: 1)); // Simula um pequeno delay para aguardar os fetchs

      // Acessa o estado atual após os fetchs
      final state = this.state;
      if (state is ObjetivosLoaded &&
          state is ModalidadesLoaded &&
          state is NiveisAtividadeLoaded) {
        yield AllDataLoaded(
          objetivos: (state as ObjetivosLoaded).objetivos,
          modalidades: (state as ModalidadesLoaded).modalidades,
          niveisAtividade: (state as NiveisAtividadeLoaded).niveisAtividade,
        );
      }
    } catch (e) {
      yield AlunoFailure(e.toString());
    }
  }

  Future<void> _onAlunoLogin(AlunoLogin event, Emitter<AlunoState> emit) async {
    emit(AlunoLoading());

    try {
      // Log da requisição sendo enviada
      print('Iniciando login para o aluno...');
      print(
          'Dados enviados: {email: ${event.email}, password: ${event.password}}');
          final token = await getToken();

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

      // Log do status da resposta e do corpo da resposta
      print('Status da resposta HTTP: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Log verificando a presença do token na resposta
        if (data.containsKey('token')) {
          final token = data['token'];
          print('Token JWT obtido: $token');
          await saveToken(token);
        } else {
          print('Aviso: Nenhum token encontrado na resposta.');
        }
        emit(AlunoSuccess(data));
      } else {
        emit(AlunoFailure(
            'Login falhou com status: ${response.statusCode}, resposta: ${response.body}'));
      }
    } catch (e) {
      // Log do erro capturado
      print('Exceção durante o login: $e');
      emit(AlunoFailure('Login falhou com exceção: $e'));
    }
  }

  Future<void> _onAlunoCadastro(
      AlunoCadastro event, Emitter<AlunoState> emit) async {
    emit(AlunoLoading());

    try {
      print('Iniciando o processo de cadastro do aluno...');
      print('Dados do aluno sendo enviados: ${jsonEncode(event.alunoData)}');

      final token = await getToken();
      print('Token JWT obtido: $token'); // Log do token

      final response = await http.post(
        Uri.parse('https://developerxpb.com.br/api/aluno'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.alunoData),
      );

      print('Status da resposta HTTP: ${response.statusCode}');
      print('Corpo da resposta do servidor: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Cadastro realizado com sucesso! Dados retornados: $data');
        emit(AlunoSuccess(data));
      } else {
        print(
            'Falha no cadastro. Status: ${response.statusCode}, Mensagem: ${response.body}');
        emit(
            AlunoFailure('Cadastro falhou com status: ${response.statusCode}'));
      }
    } catch (e, stackTrace) {
      print('Erro ao realizar o cadastro: $e');
      print('Stack trace: $stackTrace');
      emit(AlunoFailure('Cadastro falhou com exceção: $e'));
    }
  }

  Future<void> _onGetAllAlunos(
      GetAllAlunos event, Emitter<AlunoState> emit) async {
    emit(AlunoLoading());
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/aluno'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> alunos = data['data'];

        final filteredAlunos = alunos.where((aluno) {
          if (event.searchQuery == null || event.searchQuery!.isEmpty) {
            return true;
          } else {
            return aluno['nome']
                .toLowerCase()
                .contains(event.searchQuery!.toLowerCase());
          }
        }).toList();

        emit(AlunoSuccess(filteredAlunos));
      } else {
        emit(AlunoFailure('Failed to fetch alunos'));
      }
    } catch (e) {
      emit(AlunoFailure(e.toString()));
    }
  }

  Future<void> _onGetAluno(GetAluno event, Emitter<AlunoState> emit) async {
    emit(AlunoLoading());
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/aluno/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(AlunoSuccess(data));
      } else {
        emit(AlunoFailure('Failed to fetch aluno'));
      }
    } catch (e) {
      emit(AlunoFailure(e.toString()));
    }
  }

Future<void> _onUpdateAluno(UpdateAluno event, Emitter<AlunoState> emit) async {
  emit(AlunoLoading());
  try {
    final token = await getToken();

    // Criando uma requisição Multipart para suportar envio de imagem e dados JSON
    final request = http.MultipartRequest(
      'POST', // ou 'PUT' dependendo da sua API
      Uri.parse('https://developerxpb.com.br/api/aluno/{id}'),
    );

    // Adicionando cabeçalho com o token JWT
    request.headers['Authorization'] = 'Bearer $token';

    // Adicionando campos do formulário de aluno
    event.alunoData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Se houver imagem, adicioná-la à requisição
    if (event.alunoData.containsKey('foto') && event.alunoData['foto'] != null) {
      final File imageFile = File(event.alunoData['foto'].path);
      request.files.add(await http.MultipartFile.fromPath('foto', imageFile.path));
    }

    // Enviar a requisição
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      emit(AlunoSuccess(data));
    } else {
      emit(AlunoFailure('Falha ao atualizar o perfil. Código de status: ${response.statusCode}'));
    }
  } catch (e) {
    emit(AlunoFailure('Erro ao atualizar o perfil: $e'));
  }
}


  Future<void> _onDeleteAluno(
      DeleteAluno event, Emitter<AlunoState> emit) async {
    emit(AlunoLoading());
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('https://developerxpb.com.br/api/aluno/${event.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(AlunoSuccess('Aluno deleted'));
      } else {
        emit(AlunoFailure('Delete failed'));
      }
    } catch (e) {
      emit(AlunoFailure(e.toString()));
    }
  }

  Future<void> _onFetchObjetivos(
      FetchObjetivos event, Emitter<AlunoState> emit) async {
    try {
      print('Iniciando _onFetchObjetivos');
      final token = await getToken();
      print('Token obtido para FetchObjetivos: $token');

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/objetivos'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta para FetchObjetivos: ${response.statusCode}');
      print('Corpo da resposta para FetchObjetivos: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data =
            responseData['data']; // Extraindo a lista "data"

        print('Objetivos carregados com sucesso: $data');
        emit(ObjetivosLoaded(objetivos: data));
      } else {
        print('Falha ao carregar objetivos com status: ${response.statusCode}');
        emit(AlunoFailure('Failed to load objetivos'));
      }
    } catch (e) {
      print('Exceção ao carregar objetivos: $e');
      emit(AlunoFailure(e.toString()));
    }
  }

  Future<void> _onFetchModalidades(
      FetchModalidades event, Emitter<AlunoState> emit) async {
    try {
      print('Iniciando _onFetchModalidades');
      final token = await getToken();
      print('Token obtido para FetchModalidades: $token');

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/modalidade-alunos'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status da resposta para FetchModalidades: ${response.statusCode}');
      print('Corpo da resposta para FetchModalidades: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data =
            responseData['data']; // Extraindo a lista "data"

        print('Modalidades carregadas com sucesso: $data');
        emit(ModalidadesLoaded(modalidades: data));
      } else {
        print(
            'Falha ao carregar modalidades com status: ${response.statusCode}');
        emit(AlunoFailure('Failed to load modalidades'));
      }
    } catch (e) {
      print('Exceção ao carregar modalidades: $e');
      emit(AlunoFailure(e.toString()));
    }
  }

  Future<void> _onFetchNiveisAtividade(
      FetchNiveisAtividade event, Emitter<AlunoState> emit) async {
    try {
      print('Iniciando _onFetchNiveisAtividade');
      final token = await getToken();
      print('Token obtido para FetchNiveisAtividade: $token');

      final response = await http.get(
        Uri.parse('https://developerxpb.com.br/api/nivel-atividade'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status da resposta para FetchNiveisAtividade: ${response.statusCode}');
      print('Corpo da resposta para FetchNiveisAtividade: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data =
            responseData['data']; // Extraindo a lista "data"

        print('Níveis de atividade carregados com sucesso: $data');
        emit(NiveisAtividadeLoaded(niveisAtividade: data));
      } else {
        print(
            'Falha ao carregar níveis de atividade com status: ${response.statusCode}');
        emit(AlunoFailure('Failed to load niveis de atividade'));
      }
    } catch (e) {
      print('Exceção ao carregar níveis de atividade: $e');
      emit(AlunoFailure(e.toString()));
    }
  }
}
