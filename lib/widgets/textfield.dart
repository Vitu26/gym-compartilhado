import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldLC extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final bool showPasswordToggle;
  final String hintText;
  final Color textColor;
  final Color hintTextColor;
  final Color cursorColor;
  final Color iconColor;
  final Color fillColor;
  final TextInputType keyboardType; // Tipo de teclado
  final Function(String)? onChanged; // Função onChanged opcional
  final int? maxLines; // Adicionado para definir o número máximo de linhas
  final int? minLines; // Adicionado para definir o número mínimo de linhas
  final int? maxLength; // Adicionado para definir o número máximo de caracteres
  final bool isObservation; // Para definir se o campo é de observação

  TextFieldLC({
    Key? key,
    required this.controller,
    required this.obscureText,
    this.showPasswordToggle = false,
    this.hintText = '',
    this.textColor = Colors.black,
    this.hintTextColor = Colors.grey,
    this.cursorColor = Colors.blue,
    this.iconColor = Colors.grey,
    this.fillColor = const Color(0xFFF4F6F9),
    this.keyboardType = TextInputType.text, // Definido padrão
    this.onChanged, // Função onChanged opcional
    this.maxLines, // Definido padrão
    this.minLines, // Definido padrão
    this.maxLength, // Definido padrão
    this.isObservation = false, List<TextInputFormatter>? inputFormatters, // Adicionado para identificar campos de observação
  }) : super(key: key);

  @override
  _TextFieldLCState createState() => _TextFieldLCState();
}

class _TextFieldLCState extends State<TextFieldLC> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintTextColor),
        suffixIcon: widget.showPasswordToggle
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: widget.iconColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      obscureText: widget.showPasswordToggle ? _obscureText : widget.obscureText,
      style: TextStyle(color: widget.textColor),
      cursorColor: widget.cursorColor,
      onChanged: widget.onChanged,
      maxLines: widget.isObservation ? null : widget.maxLines, // Permitir linhas infinitas para observações
      minLines: widget.minLines ?? 1,
      maxLength: widget.maxLength, // Definir limite de caracteres
    );
  }
}
