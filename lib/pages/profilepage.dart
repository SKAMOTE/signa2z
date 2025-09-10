import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';
import '../styles/profilepagestyle.dart'; // ✅ import styles

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(username: "Malupiton G. Hussle"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Top Section with profile image + name
            Container(
              width: double.infinity,
              color: profileHeaderBackground, // ✅ style
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Malupiton G. Hussle",
                    style: profileNameTextStyle, // ✅ style
                  )
                ],
              ),
            ),

            // 🔹 Profile Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileField(context, "Email", "Malupiton@hot.mail.com"),
                  const SizedBox(height: 12),
                  _profileField(context, "Date of Birth", "09/12/2004"),
                  const SizedBox(height: 12),
                  _profileField(context, "Language", "English"),
                  const SizedBox(height: 12),
                  _profileField(context, "Country Region", "Japan"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
    );
  }

  // 🔹 Reusable Profile Field Widget
  Widget _profileField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: profileLabelTextStyle), // ✅ style
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: profileFieldDecoration(context), // ✅ style
          style: profileValueTextStyle, // ✅ style
        ),
      ],
    );
  }
}
