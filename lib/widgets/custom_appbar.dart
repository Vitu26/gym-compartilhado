import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;

  CustomAppBar({
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: () => Navigator.of(context).pop(),
        padding: EdgeInsets.all(0),
        constraints: BoxConstraints(),
        iconSize: 24,
      ),
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
