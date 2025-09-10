import 'package:flutter/material.dart';

// 🔹 App-wide colors
class HomeColors {
  static const background = Color(0xFFE8FCFC);
  static const cameraOverlay = Color.fromRGBO(76, 77, 76, 0.882);
  static const buttonBlue = Colors.blue;
}

// 🔹 Camera Section
class HomeTextStyles {
  static const cameraTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const tipTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static const tipSubtitle = TextStyle(
    color: Colors.black87,
    fontStyle: FontStyle.italic,
  );

  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const sectionAction = TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w600,
  );

  static const buttonText = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
}

// 🔹 Decorations
class HomeDecorations {
  static const cameraContainer = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/images/zigzag_bg.png"),
      fit: BoxFit.cover,
    ),
    border: Border(
      top: BorderSide(color: Colors.blue, width: 2),
      bottom: BorderSide(color: Colors.blue, width: 2),
    ),
  );

  static BoxDecoration cameraOverlayBox = const BoxDecoration(
    color: HomeColors.cameraOverlay,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
}

// 🔹 Buttons
class HomeButtons {
  static ButtonStyle cameraToggleButton = ElevatedButton.styleFrom(
    backgroundColor: HomeColors.buttonBlue,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
