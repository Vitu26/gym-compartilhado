import 'package:flutter/material.dart';
import 'package:sprylife/components/colors.dart';

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
    double iconSize = 20; // Tamanho reduzido do ícone
    Color selectedColor = personalColor;
    Color unselectedColor = Colors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.translate(
                  offset: isSelected
                      ? const Offset(0, -5)
                      : const Offset(
                          0, 0), // Move o ícone para cima quando selecionado
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                ),
                const SizedBox(
                    height: 6), // Espaçamento entre o ícone e o texto
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: -10, // Mova o círculo para cima
                child: Container(
                  width: 35, // Largura ajustada para o semicírculo
                  height: 20, // Altura ajustada
                  decoration: const BoxDecoration(
                    color: personalColor, // Cor do semicírculo
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ), // Forma do semicírculo
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}