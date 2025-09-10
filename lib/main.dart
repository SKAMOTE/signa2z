import 'package:flutter/material.dart';
import 'package:signa2z/pages/welcomepage.dart';
import 'package:signa2z/pages/loginpage.dart';
import 'package:signa2z/pages/signuppage.dart';
import 'pages/historypage.dart'; // 👈 added signup

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signa2Z',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcomepage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}
