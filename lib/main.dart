import 'package:flutter/material.dart';
import 'package:tubes_apb/pages/login_page.dart';
import 'package:tubes_apb/pages/main_navigation.dart';
import 'package:tubes_apb/services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        useMaterial3: true,
        primaryColor: const Color(0xFFD32F2F),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD32F2F)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> sessionFuture;

  @override
  void initState() {
    super.initState();

    sessionFuture = _checkSession();
  }

  Future<bool> _checkSession() async {
    try {
      final isLoggedIn = await ApiService.instance.isLoggedIn();

      if (!isLoggedIn) {
        return false;
      }

      /*
       * Memastikan token masih dapat
       * digunakan untuk mengambil profil.
       */
      await ApiService.instance.getProfile();

      return true;
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await ApiService.instance.clearSession();

        return false;
      }

      /*
       * Jika server sedang tidak aktif,
       * token lokal tetap dianggap ada.
       */
      return await ApiService.instance.isLoggedIn();
    } catch (_) {
      return await ApiService.instance.isLoggedIn();
    }
  }

  void _retrySession() {
    setState(() {
      sessionFuture = _checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashPage();
        }

        if (snapshot.hasError) {
          return SessionErrorPage(onRetry: _retrySession);
        }

        final isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
          return const MainNavigation();
        }

        return const LoginPage();
      },
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFD32F2F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.meeting_room_rounded,
                  size: 52,
                  color: Color(0xFFD32F2F),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Inst4Class',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Sistem Peminjaman Ruangan',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 28),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionErrorPage extends StatelessWidget {
  final VoidCallback onRetry;

  const SessionErrorPage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 70,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tidak dapat memeriksa sesi',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pastikan server Laravel aktif dan koneksi jaringan tersedia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], height: 1.5),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
