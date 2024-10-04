import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfil_professor/components/button.dart';
import 'package:perfil_professor/components/colors.dart';
import 'package:perfil_professor/components/progress_bar.dart';
import 'package:perfil_professor/pages/curriculum_page.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:sprylife/components/button.dart';
import 'package:sprylife/pages/cadastro/cadastro_professor/curriculo_page.dart';
import 'package:sprylife/utils/colors.dart';
import 'package:sprylife/widgets/progress_widget.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final imagePicker = ImagePicker();
  File? imageFile;

  // Controllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController crefController = TextEditingController();
  final TextEditingController redesController = TextEditingController();

  // Method to pick an image from gallery or camera
  Future<void> pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // Method to build the profile image section
  Widget _buildProfileImageSection() {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
          radius: 75,
          backgroundColor: const Color.fromARGB(255, 203, 214, 224),
          child: imageFile == null
              ? const Icon(Icons.person, size: 70, color: personalColor)
              : null,
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white, // Border color
                width: 3.0, // Border width
              ),
            ),
            child: CircleAvatar(
              backgroundColor: personalColor,
              child: IconButton(
                onPressed: _showImagePickerBottomSheet,
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Method to build the text fields section
  Widget _buildTextFieldsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(hintText: 'Digite seu nome', label: 'Nome', controller: nameController),
        _buildTextField(
          label: 'CPF',
          controller: cpfController,
          keyBoardType: TextInputType.number,
          hintText: '000.000.000-00',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(), // Adicionando o formatador de CPF
          ],
        ),
        _buildTextField(hintText: '00000-G/SP', label: 'CREF', controller: crefController),
        _buildTextField(
            hintText: '@profissional', label: 'Redes Sociais', controller: redesController),
      ],
    );
  }

  // Helper method to build individual text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyBoardType,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          inputFormatters: inputFormatters,
          keyboardType: keyBoardType,
          style: TextStyle(color: Colors.grey[600]),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey[600]),
            hintText: hintText,
            fillColor: Colors.grey.shade200,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  // Method to show the bottom sheet for image picker options
  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImagePickerOption(
                icon: Icons.photo_camera_back,
                title: 'Galeria',
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.gallery);
                },
              ),
              _buildImagePickerOption(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
              _buildImagePickerOption(
                icon: Icons.delete_outline,
                title: 'Remover',
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build individual image picker options
  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 203, 214, 224),
        child: Icon(icon, color: personalColor),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Button(
          text: 'Próximo',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CurriculumPage()),
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const ProgressBar(currentStep: 2, totalSteps: 4),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Preencha seu Perfil na SpryLife',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Suas informações são sigilosas e serão tratadas com segurança. Maiores informações veja nosso Termo de Uso da Plataforma.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildProfileImageSection(),
            const SizedBox(height: 20),
            _buildTextFieldsSection(),
          ],
        ),
      ),
    );
  }
}
