import 'package:flutter/material.dart';

class BorderedCircleAvatar extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final String imagePath;

  const BorderedCircleAvatar({
    Key? key,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        color: borderColor, // Cor da borda
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: radius,
        child: Image.asset(imagePath, height: radius - 5), // Ajuste o tamanho conforme necessário
      ),
    );
  }
}
