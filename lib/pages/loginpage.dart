import 'package:flutter/material.dart';
import 'package:signa2z/pages/homepage.dart';
import '../styles/loginpagestyle.dart'; // 👈 import styles

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginPageStyles.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: LoginPageStyles.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Logo
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/app_logo.png",
                      height: 120,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Real-Time ASL Translation App",
                      style: LoginPageStyles.subtitleText,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Login", style: LoginPageStyles.titleText),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Please login to continue.",
                    style: LoginPageStyles.hintText),
              ),

              const SizedBox(height: 30),

              // 🔹 Email
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email or Username",
                    style: LoginPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Password
              Align(
                alignment: Alignment.centerLeft,
                child:
                    Text("Password", style: LoginPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                ),
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

              const SizedBox(height: 10),

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

              // 🔹 Google Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: LoginPageStyles.googleButton,
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/images/google_logo.png",
                    width: 24,
                    height: 24,
                  ),
                  label: const Text("Sign in with Google",
                      style: TextStyle(color: Colors.black87, fontSize: 14)),
                ),
              ),

              const SizedBox(height: 25),

              // 🔹 Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: LoginPageStyles.loginButton,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Homepage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 🔹 Forgot Password
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Signup link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      "Sign Up",
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
