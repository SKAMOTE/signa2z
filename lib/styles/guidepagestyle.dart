import 'package:flutter/material.dart';

/// 🔹 Background Decoration
const BoxDecoration guidePageBackground = BoxDecoration(
  image: DecorationImage(
    image: AssetImage("assets/images/sign_bg.png"),
    fit: BoxFit.cover,
  ),
);

/// 🔹 Search Bar Decoration
BoxDecoration searchBarDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(30),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
    ),
  ],
);

/// 🔹 Text Styles
const TextStyle noResultsTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.grey,
);

const TextStyle aslLetterTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

const TextStyle aslDescTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.black87,
);

/// 🔹 Button Styles
final ButtonStyle watchButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  padding: const EdgeInsets.symmetric(horizontal: 10),
  minimumSize: const Size(60, 30),
);

final ButtonStyle practiceButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepPurple,
  padding: const EdgeInsets.symmetric(horizontal: 10),
  minimumSize: const Size(60, 30),
);

/// 🔹 Card Style
RoundedRectangleBorder aslCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
);
