import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signa2z/pages/homepage.dart';
import '../styles/signuppagestyle.dart'; // 👈 import styles

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool rememberMe = false;
  bool _isLoading = false;

  // ✅ Controllers for input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          "username": _usernameController.text.trim(),
          "email": user.email,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      // Navigate to Homepage
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
    }
  }

  // =========================
  // Email/Password Sign-Up
  // =========================
  Future<void> _signUp() async {
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

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
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User canceled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await _postSignIn(userCredential.user);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                  onPressed: _signInWithGoogle,
                  icon: Image.asset(
                    "assets/images/google_logo.png",
                    width: 24,
                    height: 24,
                  ),
                  label: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
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
              TextField(
                  controller: _usernameController,
                  decoration: SignupPageStyles.inputDecoration),
              const SizedBox(height: 20),

              // 🔹 Email Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: SignupPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              TextField(
                  controller: _emailController,
                  decoration: SignupPageStyles.inputDecoration),
              const SizedBox(height: 20),

              // 🔹 Password Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Password", style: SignupPageStyles.labelText),
              ),
              const SizedBox(height: 6),
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: SignupPageStyles.inputDecoration),

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
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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
