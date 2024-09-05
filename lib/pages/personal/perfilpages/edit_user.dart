import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/custom_button.dart';
import 'package:sprylife/widgets/textfield.dart';
import 'package:sprylife/bloc/personal/personal_bloc.dart';
import 'package:sprylife/bloc/personal/personal_event.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> personalData;

  UserProfileScreen({required this.personalData});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController birthDateController;
  late TextEditingController genderController;
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.personalData['nome'] ?? '');
    phoneController =
        TextEditingController(text: widget.personalData['telefone'] ?? '');
    emailController =
        TextEditingController(text: widget.personalData['email'] ?? '');
    birthDateController = TextEditingController(
        text: widget.personalData['data_nascimento'] ?? '');
    genderController =
        TextEditingController(text: widget.personalData['genero'] ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _updateProfile() {
    Map<String, dynamic> updatedData = {
      'nome': nameController.text,
      'telefone': phoneController.text,
      'email': emailController.text,
      'data_nascimento': birthDateController.text,
      'genero': genderController.text,
    };

    BlocProvider.of<PersonalBloc>(context).add(
      UpdatePersonalProfile(updatedData: updatedData, image: _image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Seu Perfil'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _image != null
                        ? FileImage(File(_image!.path))
                        : (widget.personalData['foto'] != null
                                ? NetworkImage(widget.personalData['foto'])
                                : AssetImage('assets/default_avatar.png'))
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Nome'),
            TextFieldLC(
              controller: nameController,
              obscureText: false,
              hintText: 'Nome',
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 20),
            Text('Número de Telefone'),
            TextFieldLC(
              controller: phoneController,
              obscureText: false,
              hintText: 'Número de Telefone',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            Text('Email'),
            TextFieldLC(
              controller: emailController,
              obscureText: false,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            Text('Data de Nascimento'),
            TextFieldLC(
              controller: birthDateController,
              obscureText: false,
              hintText: 'DD/MM/AAAA',
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            Text('Gênero'),
            DropdownButtonFormField<String>(
              value: genderController.text.isNotEmpty
                  ? genderController.text
                  : null,
              hint: Text('Selecionar'),
              items: <String>['Masculino', 'Feminino', 'Outro']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: (value) {
                genderController.text = value ?? '';
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Color(0xFFF4F6F9),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: CustomButton(
                text: 'Atualizar Perfil',
                backgroundColor: personalColor,
                onPressed: _updateProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
