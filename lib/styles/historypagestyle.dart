import 'package:flutter/material.dart';

/// 🔹 App Colors
class HistoryColors {
  static const backgroundOverlay = Colors.white;
  static const searchIcon = Colors.grey;
  static const emptyText = Colors.grey;
  static const deleteAction = Colors.red;
  static const deleteText = Colors.white;
}

/// 🔹 Text Styles
class HistoryTextStyles {
  static const emptyHistory = TextStyle(
    fontSize: 16,
    color: HistoryColors.emptyText,
  );

  static const historyTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const historySubtitle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );
}

/// 🔹 Decorations
class HistoryDecorations {
  // Background
  static const background = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/images/sign_bg.png"),
      fit: BoxFit.cover,
    ),
  );

  // Search Bar
  static BoxDecoration searchBar = BoxDecoration(
    color: HistoryColors.backgroundOverlay.withOpacity(0.8),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 4,
      ),
    ],
  );

  // Card
  static BoxDecoration card = BoxDecoration(
    color: Colors.white.withOpacity(0.85),
    borderRadius: BorderRadius.circular(12),
  );
}

/// 🔹 Buttons
class HistoryButtons {
  static ButtonStyle clearAll = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade700,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
