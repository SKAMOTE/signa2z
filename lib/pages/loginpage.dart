import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signa2z/pages/homepage.dart';
import '../styles/loginpagestyle.dart'; // 👈 import styles

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;

  // ✅ Controllers for input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // =========================
  // Email/Password Login
  // =========================
  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      await _postSignIn(userCredential.user);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // =========================
  // Google Sign-In
  // =========================
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      // Instantiate GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled
        setState(() => _isLoading = false);
        return;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in with Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Common post sign-in logic
      await _postSignIn(userCredential.user);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // =========================
  // Common post sign-in logic
  // =========================
  Future<void> _postSignIn(User? user) async {
    if (user != null) {
      // Check Firestore profile
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "email": user.email,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      // Navigate to Homepage
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
    }
  }

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

              // 🔹 Login header
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
                child:
                    Text("Email or Username", style: LoginPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Password
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Password", style: LoginPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                ),
              ),

              const SizedBox(height: 10),
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

              // 🔹 Google Sign-In Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: LoginPageStyles.googleButton,
                  onPressed: _signInWithGoogle,
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

              // 🔹 Email/Password Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: LoginPageStyles.loginButton,
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Log In",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 15),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 10),

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
