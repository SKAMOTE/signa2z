import 'package:flutter/material.dart';
import '../styles/signuppagestyle.dart'; // 👈 import styles

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SignupPageStyles.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: SignupPageStyles.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Logo
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/app_logo.png",
                      height: 100,
                    ),
                    const SizedBox(height: 4),
                    Text("Real-Time ASL Translation App",
                        style: SignupPageStyles.subtitleText),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Register", style: SignupPageStyles.titleText),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Please Register to continue.",
                    style: SignupPageStyles.hintText),
              ),

              const SizedBox(height: 30),

              // 🔹 Google Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: SignupPageStyles.googleButton,
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/images/google_logo.png",
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Divider
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Username Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Username", style: SignupPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              const TextField(decoration: SignupPageStyles.inputDecoration),
              const SizedBox(height: 20),

              // 🔹 Email Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: SignupPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              const TextField(decoration: SignupPageStyles.inputDecoration),
              const SizedBox(height: 20),

              // 🔹 Password Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Password", style: SignupPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              const TextField(
                obscureText: true,
                decoration: SignupPageStyles.inputDecoration,
              ),

              const SizedBox(height: 10),

              // 🔹 Remember Me
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (val) {
                      setState(() {
                        rememberMe = val ?? false;
                      });
                    },
                  ),
                  const Text("Remember me"),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: SignupPageStyles.signupButton,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Sign Up pressed")),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 🔹 Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
