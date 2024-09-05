import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprylife/widgets/textfield_sufixicon.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';
import 'package:sprylife/bloc/personal/personal_state.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the current password or any required data here
    if (mounted) {
      BlocProvider.of<PersonalBloc>(context).add(GetPersonalPassword());
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          iconSize: 24,
        ),
        title: const Text(
          'Gerenciar Senhas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<PersonalBloc, PersonalState>(
        listener: (context, state) {
          if (state is PersonalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Senha atualizada com sucesso!'),
            ));
            if (mounted) {
              Navigator.of(context).pop();
            }
          } else if (state is PersonalFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Erro ao atualizar senha: ${state.error}'),
            ));
          }
        },
        child: BlocBuilder<PersonalBloc, PersonalState>(
          builder: (context, state) {
            if (state is PersonalLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PersonalPasswordLoaded) {
              _currentPasswordController.text = state.password ?? '';
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFieldWithSuffixIcon(
                    controller: _currentPasswordController,
                    obscureText: true,
                    hintText: 'Senha Atual',
                    showPasswordToggle: true,
                  ),
                  SizedBox(height: 16),
                  TextFieldWithSuffixIcon(
                    controller: _newPasswordController,
                    obscureText: true,
                    hintText: 'Nova Senha',
                    showPasswordToggle: true,
                  ),
                  SizedBox(height: 16),
                  TextFieldWithSuffixIcon(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    hintText: 'Confirmar Nova Senha',
                    showPasswordToggle: true,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_newPasswordController.text ==
                          _confirmPasswordController.text) {
                        BlocProvider.of<PersonalBloc>(context).add(
                          UpdatePersonalPassword(
                            currentPassword: _currentPasswordController.text,
                            newPassword: _newPasswordController.text,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('As novas senhas não coincidem.'),
                        ));
                      }
                    },
                    child: Text('Mudar Senha'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
