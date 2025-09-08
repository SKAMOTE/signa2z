import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';

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
              color: Colors.blue.shade100,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/images/profile.jpg"), // 👈 replace with real image
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Malupiton G. Hussle",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                  _profileField("Email", "Malupiton@hot.mail.com"),
                  const SizedBox(height: 12),
                  _profileField("Date of Birth", "09/12/2004"),
                  const SizedBox(height: 12),
                  _profileField("Language", "English"),
                  const SizedBox(height: 12),
                  _profileField("Country Region", "Japan"),
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
  Widget _profileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          enabled: false, // 👈 makes it read-only
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
