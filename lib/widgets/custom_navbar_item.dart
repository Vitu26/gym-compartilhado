import 'package:flutter/material.dart';

class CustomNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomNavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = 24;  // Ajuste do tamanho do ícone
    Color selectedColor = Color(0xFF2163E8);
    Color unselectedColor = Colors.grey;

    return Expanded(  // Garantir que cada item ocupe o espaço disponível
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: iconSize,  // Tamanho do ícone
              color: isSelected ? selectedColor : unselectedColor,
            ),
            SizedBox(height: 6),  // Espaçamento entre o ícone e o texto
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
