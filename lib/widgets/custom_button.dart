import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool isThin;

  const CustomButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 18),
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.isThin = false,
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
          padding: isThin 
              ? const EdgeInsets.symmetric(vertical: 8) // Altura menor quando fino
              : padding,
        ),
      ),
    );
  }
}
