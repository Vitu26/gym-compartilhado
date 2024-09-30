import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sprylife/bloc/chat/chat_bloc.dart';
import 'package:sprylife/bloc/chat/chat_event.dart';
import 'package:sprylife/bloc/chat/chat_state.dart';
import 'package:sprylife/widgets/custom_appbar.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class ChatScreenPersonal extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverName; // Adicione o nome do destinatário
  final Map<String, dynamic> personalData;

  ChatScreenPersonal({
    required this.senderId,
    required this.receiverId,
    required this.receiverName, // Adicione aqui também
    required this.personalData,
  });

  @override
  _ChatScreenPersonalState createState() => _ChatScreenPersonalState();
}

class _ChatScreenPersonalState extends State<ChatScreenPersonal> {
  File? _selectedFile;
  String? _selectedFileName;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Controlador de rolagem
  bool isUploading = false;
  bool canSendMessage =
      false; // Novo estado para controlar se o botão deve ser habilitado

  @override
  void initState() {
    super.initState();

    // Adiciona um listener para atualizar o estado sempre que o texto mudar
    _controller.addListener(_checkCanSendMessage);
  }

  // Função para verificar se o botão deve ser habilitado
  void _checkCanSendMessage() {
    setState(() {
      canSendMessage = _controller.text.isNotEmpty || _selectedFile != null;
    });
  }

  // Função para selecionar um arquivo
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _selectedFileName = result.files.single.name;
        canSendMessage =
            true; // Atualiza o estado para habilitar o botão de envio
      });
    }
  }

  // Função para rolar a tela para a última mensagem
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()
        ..add(LoadMessages(
            senderId: widget.senderId, receiverId: widget.receiverId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          // Alteração no título da AppBar
          title:
              'Conversa com ${widget.receiverName}', // Exibe o nome da pessoa
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    // Rolagem para o final ao carregar mensagens
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    return ListView.builder(
                      controller:
                          _scrollController, // Adiciona o controlador aqui
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0, // Espaço entre as mensagens e a AppBar
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isSender = message['sender'] == widget.senderId;

                        return Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 14.0),
                            decoration: BoxDecoration(
                              color: isSender
                                  ? Colors.blueAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: isSender
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (message['file_url'] != null)
                                  message['file_name']?.endsWith('.pdf') == true
                                      ? GestureDetector(
                                          onTap: () {
                                            launch(message['file_url']);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.picture_as_pdf,
                                                  color: Colors.red),
                                              SizedBox(width: 8),
                                              Text(
                                                  message['file_name'] ?? 'PDF')
                                            ],
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            launch(message['file_url']);
                                          },
                                          child: Image.network(
                                            message[
                                                'file_url']!, // Exibe a imagem
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                if (message['message'] != null)
                                  Text(
                                    message['message'],
                                    style: TextStyle(
                                      color: isSender
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                SizedBox(height: 5),
                                Text(
                                  DateFormat('HH:mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        message['timestamp']),
                                  ),
                                  style: TextStyle(
                                    color: isSender
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatMessageSent) {
                    // Volta ao estado de carregamento de mensagens para exibir as atualizações
                    BlocProvider.of<ChatBloc>(context).add(LoadMessages(
                      senderId: widget.senderId,
                      receiverId: widget.receiverId,
                    ));
                    return Container();
                  } else if (state is ChatError) {
                    return Center(child: Text('Erro: ${state.error}'));
                  } else {
                    return Center(child: Text('Nenhuma mensagem ainda'));
                  }
                },
              )),
              _buildMessageInput(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom:
            16.0, // Espaçamento da barra de digitação até a bottom navigation bar
        top: 8.0, // Espaçamento entre o campo de texto e as mensagens
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: _pickFile, // Selecionar arquivo
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (text) {
                setState(
                    () {}); // Atualiza o estado para habilitar/desabilitar o botão
              },
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: (_controller.text.isNotEmpty || _selectedFile != null)
                ? () {
                    // Envia a mensagem e/ou o arquivo
                    BlocProvider.of<ChatBloc>(context).add(SendMessage(
                      senderId: widget.senderId,
                      receiverId: widget.receiverId,
                      message: _controller.text,
                      file: _selectedFile, // Enviar arquivo se houver
                      fileName: _selectedFileName, // Nome do arquivo
                    ));

                    _controller.clear(); // Limpa o campo de texto após o envio
                    setState(() {
                      _selectedFile = null; // Limpa o arquivo selecionado
                      _selectedFileName =
                          null; // Limpa o nome do arquivo selecionado
                    });

                    // Rola para o final após enviar a mensagem
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
                : null, // Desabilita o botão se não há texto ou arquivo
          ),
        ],
      ),
    );
  }
}
