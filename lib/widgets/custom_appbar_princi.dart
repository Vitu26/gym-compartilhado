import 'package:flutter/material.dart';

class CustomAppBarPrinci extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;
  final Color borderColor;
 // Espaço entre o título e a borda

  CustomAppBarPrinci({
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.iconColor = Colors.black,
    this.borderColor = Colors.grey,
 // Espaço padrão de 8.0 pixels
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
