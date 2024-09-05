import 'package:flutter/material.dart';
import 'package:sprylife/utils/colors.dart';

class CustomNavBarItemAluno extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomNavBarItemAluno({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;  // Reduced icon size
    Color selectedColor = alunoCor;
    Color unselectedColor = Colors.grey;

    return Expanded(  // Ensure each item takes up the available space
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: iconSize,  // Icon size
              color: isSelected ? selectedColor : unselectedColor,
            ),
            SizedBox(height: 6),  // Gap between icon and label
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
