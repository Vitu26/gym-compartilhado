import 'package:flutter/material.dart';

class CustomGreetingWidget extends StatelessWidget {
  final String name;
  final String? profileVisitsText;
  final int notificationCount;
  final VoidCallback onNotificationTap;
  final Color? greetingTextColor;
  final Color? nameTextColor;
  final Color? profileVisitsTextColor;
  final Color? notificationIconColor;
  final Color? notificationBadgeColor;
  final Color? notificationBadgeTextColor;

  const CustomGreetingWidget({
    Key? key,
    required this.name,
    this.profileVisitsText, // Tornando profileVisitsText opcional
    required this.notificationCount,
    required this.onNotificationTap,
    this.greetingTextColor,
    this.nameTextColor,
    this.profileVisitsTextColor,
    this.notificationIconColor,
    this.notificationBadgeColor,
    this.notificationBadgeTextColor,
  }) : super(key: key);

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Bom dia,';
    } else if (hour < 18) {
      return 'Boa tarde,';
    } else {
      return 'Boa noite,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreetingMessage(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: greetingTextColor ?? Colors.black, // Default color
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: nameTextColor ?? Colors.black, // Default color
              ),
            ),
            const SizedBox(height: 5),
            if (profileVisitsText != null)
              Text(
                profileVisitsText!,
                style: TextStyle(
                  fontSize: 14,
                  color: profileVisitsTextColor ?? Colors.grey, // Default color
                ),
              ),
          ],
        ),
        const Spacer(),
        Stack(
          children: [
            IconButton(
              onPressed: onNotificationTap,
              icon: Icon(
                Icons.notifications,
                color: notificationIconColor ?? Colors.black, // Default color
              ),
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        notificationBadgeColor ?? Colors.red, // Default color
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: TextStyle(
                      color: notificationBadgeTextColor ??
                          Colors.white, // Default color
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
