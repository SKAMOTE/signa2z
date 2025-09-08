import 'package:flutter/material.dart';
import '../pages/notificationpage.dart'; // 👈 import your notification page
import '../pages/settingpage.dart';   // 👈 import your settings page

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;

  const CustomAppBar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3366CC), // blue header
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.jpg"),
            radius: 18,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back,",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),

      // 🔹 HAMBURGER MENU
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Colors.white),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: Text("Settings"),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text("Theme"),
            ),
            const PopupMenuItem(
              value: 3,
              child: Text("Notification"),
            ),
            const PopupMenuItem(
              value: 4,
              child: Text("Logout"),
            ),
          ],
          onSelected: (value) {
            if (value == 1) {
              // ✅ Navigate to Settings Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            } else if (value == 2) {
              // TODO: Navigate to Theme
            } else if (value == 3) {
              // ✅ Navigate to Notification Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            } else if (value == 4) {
              // TODO: Handle Logout
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
