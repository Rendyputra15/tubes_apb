import 'package:flutter/material.dart';
import 'main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool showForm = false;
  bool hidePassword = true;

  void login() {
    if (usernameController.text.trim() == 'ahmaddewa' &&
        passwordController.text.trim() == 'dewa123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah.')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFF44336)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.meeting_room_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 22),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: 'Inst4',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: 'Class',
                      style: TextStyle(color: Color(0xFFD32F2F)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sistem Peminjaman Ruangan Kampus',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: showForm
                    ? Column(
                        children: [
                          const Text(
                            'Login SSO',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              filled: true,
                              fillColor: const Color(0xFFF7F8FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: passwordController,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: const Color(0xFFF7F8FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD32F2F),
                              ),
                              child: const Text('Masuk'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showForm = false;
                              });
                            },
                            child: const Text('Kembali'),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const Text(
                            'Masuk dengan akun kampus',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gunakan akun SSO Telkom University untuk mengakses sistem peminjaman ruangan.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  showForm = true;
                                });
                              },
                              icon: const Icon(Icons.login),
                              label: const Text('Login SSO'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD32F2F),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}