import 'package:flutter/material.dart';
import 'package:tubes_apb/pages/login_page.dart';

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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const LoginPage(),
    );
  }
}