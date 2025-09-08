import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController nameController =
      TextEditingController(text: "Malupiton G. Hussle");
  final TextEditingController emailController =
      TextEditingController(text: "Malupiton@hot.mail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "malupiton123");
  final TextEditingController dobController = TextEditingController();

  String? selectedLanguage;
  String? selectedRegion;

  bool _isPasswordVisible = false; // ✅ toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3366CC),
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,

        // ✅ Cancel button
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 Profile Image
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 18,
                      child: const Icon(Icons.camera_alt, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Name
            TextField(
              controller: nameController,
              decoration: _inputDecoration("Name"),
            ),
            const SizedBox(height: 15),

            // 🔹 Email
            TextField(
              controller: emailController,
              decoration: _inputDecoration("Email"),
            ),
            const SizedBox(height: 15),

            // 🔹 Password with show/hide
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: _inputDecoration("Password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 🔹 Date of Birth with Calendar
            TextField(
              controller: dobController,
              readOnly: true,
              decoration: _inputDecoration("Date of Birth").copyWith(
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    dobController.text =
                        "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 15),

            // 🔹 Language (Dropdown)
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: _inputDecoration("Language"),
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "Filipino", child: Text("Filipino")),
              ],
              onChanged: (value) => setState(() => selectedLanguage = value),
            ),
            const SizedBox(height: 15),

            // 🔹 Country Region (Dropdown)
            DropdownButtonFormField<String>(
              value: selectedRegion,
              decoration: _inputDecoration("Country Region"),
              items: const [
                DropdownMenuItem(
                    value: "Philippines", child: Text("Philippines")),
                DropdownMenuItem(value: "USA", child: Text("USA")),
                DropdownMenuItem(value: "Japan", child: Text("Japan")),
              ],
              onChanged: (value) => setState(() => selectedRegion = value),
            ),
            const SizedBox(height: 25),

            // 🔹 Save Button
            ElevatedButton(
              onPressed: () {
                // ✅ Save logic with Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Saved!\n"
                      "Name: ${nameController.text}\n"
                      "Email: ${emailController.text}\n"
                      "Password: ${passwordController.text}\n"
                      "DOB: ${dobController.text}\n"
                      "Language: ${selectedLanguage ?? "Not set"}\n"
                      "Region: ${selectedRegion ?? "Not set"}",
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3366CC),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Save Profile",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable input decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
