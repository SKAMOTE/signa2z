import 'package:flutter/material.dart';

class WelcomePageColors {
  static const Color background = Color(0xFFE8FCFC);
  static const Color primary = Color(0xFF1f75fe);
  static const Color title = Color(0xFF1f3c88);
  static const Color text = Colors.black87;
}

class WelcomePageTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: WelcomePageColors.title,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: WelcomePageColors.text,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}

class WelcomePageButtonStyles {
  static ButtonStyle roundedBlue = ElevatedButton.styleFrom(
    backgroundColor: WelcomePageColors.primary,
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  );
}
