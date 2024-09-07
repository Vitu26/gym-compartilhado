import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/bloc/aluno/aluno_bloc.dart';
import 'package:sprylife/bloc/categoriaExercicio/categoria_exercicio_bloc.dart';
import 'package:sprylife/bloc/chat/chat_bloc.dart';
import 'package:sprylife/bloc/exercicios/exericios_bloc.dart';
import 'package:sprylife/bloc/exericioHasTreeino/treino_has_exercicio_bloc.dart';
import 'package:sprylife/bloc/faturas/faturas_bloc.dart';
import 'package:sprylife/bloc/informa%C3%A7%C3%B5es_comum/informacoes_comum_bloc.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/planos/planos_bloc.dart';
import 'package:sprylife/bloc/rotinaHasTreino/rotina_has_treino_bloc.dart';
import 'package:sprylife/bloc/rotinaTreino/rotina_treino_bloc.dart';
import 'package:sprylife/bloc/treino/treino_bloc.dart';
import 'package:sprylife/models/rotas.dart';
import 'package:sprylife/pages/aluno/pesquisarPersonal/pesquisar_personal.dart';
import 'package:sprylife/pages/aluno/pesquisarPersonal/pesquisar_personal_lista.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/activity_level_page.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/cadastro_estudante.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/complete_cadastro_aluno.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/objective_page.dart';
import 'package:sprylife/pages/cadastro/cadastro_aluno/verificacao_cadastro.dart';
import 'package:sprylife/pages/cadastro/cadastro_professor/cadstro_professor.dart';
import 'package:sprylife/pages/home_page.dart';
import 'package:sprylife/pages/login/login.dart';
import 'package:sprylife/pages/personal/alunoperfil/aluno_perfil_personal.dart';
import 'package:sprylife/pages/personal/cadastro_aluno_personal.dart';
import 'package:sprylife/pages/personal/home_page_parsonal.dart';
import 'package:sprylife/pages/personal/perfilpages/treinos/treinos_detalhe_page.dart';
import 'package:sprylife/pages/pesquisar/filter_result.dart';
import 'package:sprylife/pages/pesquisar/filter_screen.dart';
import 'package:sprylife/pages/pesquisar/treiner_details.dart'; // Nova página do Trainer Details
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlunoBloc>(
          create: (context) => AlunoBloc(),
        ),
        BlocProvider<PersonalBloc>(
          create: (context) => PersonalBloc(),
        ),
        BlocProvider<TreinoBloc>(
          create: (context) => TreinoBloc(),
        ),
        BlocProvider<FaturaBloc>(
          create: (context) => FaturaBloc(),
        ),
        BlocProvider<PlanoBloc>(
          create: (context) => PlanoBloc(),
        ),
        BlocProvider<RotinaDeTreinoBloc>(
          create: (context) => RotinaDeTreinoBloc(),
        ),
        BlocProvider<RotinaHasTreinoBloc>(
          create: (context) => RotinaHasTreinoBloc(),
        ),
        BlocProvider<ExercicioBloc>(
          create: (context) => ExercicioBloc(),
        ),
        BlocProvider<CategoriaExercicioBloc>(
          create: (context) => CategoriaExercicioBloc(),
        ),
        BlocProvider<ExercicioTreinoBloc>(
          create: (context) => ExercicioTreinoBloc(),
        ),
        BlocProvider<InformacoesComunsBloc>(
          create: (context) => InformacoesComunsBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Academia App',
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => LoginScreen(),
          AppRoutes.pesquisarPersonal: (context) => PesquisarPersonal(),
          AppRoutes.pesquisarPersonalLista: (context) => PesquisarPersonalLista(),
          AppRoutes.home: (context) => HomeScreen(),
          AppRoutes.cadastroAluno: (context) => CadastroAlunoScreen(),
          AppRoutes.cadastroProfissionalScreen: (context) =>
              CadastroProfissionalScreen(),
          AppRoutes.activity: (context) => ActivityLevelSelectionPage(),
          AppRoutes.objective: (context) => ObjectiveSelectionPage(),
          AppRoutes.filter: (context) => FilterScreen(),
          AppRoutes.filterResult: (context) => ResultsScreen(),
          AppRoutes.homePersonal: (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return HomePersonalScreen(
              personalData: args['personalData'],
            ); // Passando personalData
          },
          AppRoutes.cadastroAlunoPersonal: (context) => CadastroAlunoPersonalScreen(),
          AppRoutes.perfilAlunoPersonal: (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return AlunoPerfilScreen(
                alunoData: args['alunoData']); // Passando alunoData
          },
          AppRoutes.treinoDetalhes: (context) {
            final args = ModalRoute.of(context)!.settings.arguments as int;
            return TreinoDetalhesPage(treinoId: args); // Passando treinoId
          },
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.completeProfileScreen) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(
                email: args['email'],
                phone: args['phone'],
                password: args['password'],
                selectedGender: args['selectedGender'],
                selectedObjective: args['selectedObjective'],
                selectedActivityLevel: args['selectedActivityLevel'],
              ),
            );
          }

          if (settings.name == AppRoutes.verify) {
            final args = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => VerifyCodeScreen(email: args),
            );
          }

          return null; // Se não encontrar a rota, retorna null
        },
      ),
    );
  }
}
