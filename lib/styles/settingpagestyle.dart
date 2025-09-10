import 'package:flutter/material.dart';

// 🔹 App Colors
class SettingPageColors {
  static const Color appBarColor = Color(0xFF3366CC);
  static const Color buttonColor = Color(0xFF3366CC);
  static const Color inputFill = Colors.white;
}

// 🔹 App Text Styles
class SettingPageTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle appBarCancel = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
}

// 🔹 Input Decoration (reusable)
class SettingPageInput {
  static InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      filled: true,
      fillColor: SettingPageColors.inputFill,
    );
  }
}

// 🔹 Button Style
class SettingPageButtons {
  static ButtonStyle saveButton = ElevatedButton.styleFrom(
    backgroundColor: SettingPageColors.buttonColor,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
