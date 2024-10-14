import 'package:flutter/material.dart';
import 'package:sprylife/components/colors.dart';

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
    this.textStyle = const TextStyle(color: personalColor, fontSize: 18),
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.borderColor = personalColor,
    this.borderWidth = 2.0,
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
