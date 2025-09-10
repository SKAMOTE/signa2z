import 'package:flutter/material.dart';

class SignupPageStyles {
  // 🔹 Background
  static const Color backgroundColor = Color(0xFFE8FCFC);

  // 🔹 Page padding
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: 24.0, vertical: 40);

  // 🔹 Text styles
  static const TextStyle titleText = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1f3c88),
  );

  static const TextStyle subtitleText = TextStyle(
    fontSize: 14,
    color: Colors.red,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle hintText =
      TextStyle(fontSize: 14, color: Colors.black54);

  static const TextStyle labelText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  // 🔹 Input Fields
  static const InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    filled: true,
    fillColor: Color(0xFFF2F2F2),
  );

  // 🔹 Buttons
  static final ButtonStyle googleButton = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
    side: const BorderSide(color: Colors.grey),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );

  static final ButtonStyle signupButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
