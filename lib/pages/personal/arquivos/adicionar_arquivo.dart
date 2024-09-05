import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AdicionarArquivoScreen extends StatefulWidget {
  @override
  _AdicionarArquivoScreenState createState() => _AdicionarArquivoScreenState();
}

class _AdicionarArquivoScreenState extends State<AdicionarArquivoScreen> {
  PlatformFile? arquivoSelecionado;
  TextEditingController nomeDocumentoController = TextEditingController();

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
          'Adicionar Arquivo',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  setState(() {
                    arquivoSelecionado = result.files.first;
                    nomeDocumentoController.text = arquivoSelecionado!.name;
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
              child: const Text('Escolher documento', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (arquivoSelecionado != null) ...[
              TextField(
                controller: nomeDocumentoController,
                decoration: const InputDecoration(
                  labelText: 'Nome do documento',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      arquivoSelecionado!.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'nomeDocumento': nomeDocumentoController.text,
                    'arquivo': arquivoSelecionado,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Salvar', style: TextStyle(color: Colors.white)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
