import 'package:flutter/material.dart';

class CustomButtonBorda extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final double borderWidth;

  const CustomButtonBorda({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 18),
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.borderColor = Colors.transparent, // Cor padrão sem borda
    this.borderWidth = 2.0, // Largura padrão da borda
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: textStyle),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          side: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}
