import 'package:flutter/material.dart';

/// 🔹 Top Section Background
final Color profileHeaderBackground = Colors.blue.shade100;

/// 🔹 Profile Name Text Style
const TextStyle profileNameTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

/// 🔹 Profile Label Text Style
const TextStyle profileLabelTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
);

/// 🔹 Profile Value Field Decoration
InputDecoration profileFieldDecoration(BuildContext context) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
  );
}

/// 🔹 Profile Value Text Style
const TextStyle profileValueTextStyle = TextStyle(
  color: Colors.black,
);
