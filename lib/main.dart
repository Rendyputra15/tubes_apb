import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const Inst4ClassApp());
}

class Inst4ClassApp extends StatelessWidget {
  const Inst4ClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inst4Class',
      theme: ThemeData(
        primaryColor: const Color(0xFFD32F2F),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
        ),
      ),
      home: const LoginPage(),
    );
  }
}