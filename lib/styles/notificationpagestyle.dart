import 'package:flutter/material.dart';

/// 🔹 Background Decoration
const BoxDecoration notificationPageBackground = BoxDecoration(
  image: DecorationImage(
    image: AssetImage("assets/images/bg.png"),
    fit: BoxFit.cover,
  ),
);

/// 🔹 Card Style
const double notificationCardElevation = 2;
const EdgeInsets notificationCardMargin = EdgeInsets.symmetric(vertical: 6);

/// 🔹 Title Text Style
const TextStyle notificationTitleTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
);

/// 🔹 Delete Button Style
const Color deleteButtonBackground = Colors.red;
const Color deleteButtonForeground = Colors.white;
const IconData deleteButtonIcon = Icons.delete;
const String deleteButtonLabel = 'Delete';

/// 🔹 Unread Indicator
const Icon unreadIndicator = Icon(
  Icons.circle,
  color: Colors.red,
  size: 10,
);
