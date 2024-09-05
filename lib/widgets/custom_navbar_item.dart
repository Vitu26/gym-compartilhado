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
    double iconSize = 20;  // Reduced icon size
    Color selectedColor = Color(0xFF2163E8);
    Color unselectedColor = Colors.grey;

    return Expanded(  // Ensure each item takes up the available space
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Positioned(
                    top: -20,  // Increase the distance between icon and circle
                    child: Container(
                      width: 32,  // Circle size remains similar but slightly bigger
                      height: 32,
                      decoration: BoxDecoration(
                        color: selectedColor.withOpacity(0.2),  // Transparent background
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                Icon(
                  icon,
                  size: iconSize,  // Icon size reduced slightly
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ],
            ),
            SizedBox(height: 6),  // Increased gap between icon and label
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



