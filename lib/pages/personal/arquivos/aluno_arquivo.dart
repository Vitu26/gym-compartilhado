import 'package:flutter/material.dart';
import 'package:sprylife/pages/personal/arquivos/adicionar_arquivo.dart';

class AlunoArquivosScreen extends StatefulWidget {
  final Map<String, dynamic> alunoData;

  AlunoArquivosScreen({required this.alunoData});

  @override
  _AlunoArquivosScreenState createState() => _AlunoArquivosScreenState();
}

class _AlunoArquivosScreenState extends State<AlunoArquivosScreen> {
  List<Map<String, String>> arquivos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(),
          iconSize: 24,
        ),
        title: const Text(
          'Detalhes do Aluno',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildFileList(),
            const SizedBox(height: 20),
            _buildAddFileButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(
              'images/${(widget.alunoData['user']?['name']?.replaceAll(' ', '').toLowerCase()) ?? 'default_image'}.jpg'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.alunoData['user']?['name'] ?? 'Nome Indisponível',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.alunoData['address']?['cidade'] ?? 'Localização Indisponível',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFileList() {
    return arquivos.isEmpty
        ? const Text(
            'Adicione arquivos para seu aluno.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: arquivos.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(arquivos[index]['nomeDocumento']!),
                subtitle: Text('Tipo: PDF'),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Ações como editar ou excluir o arquivo
                  },
                ),
              );
            },
          );
  }

  Widget _buildAddFileButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final novoArquivo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarArquivoScreen()),
          );

          if (novoArquivo != null) {
            setState(() {
              arquivos.add(novoArquivo);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text('Adicionar arquivo', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
