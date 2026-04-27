import 'package:flutter/material.dart';
import 'package:tubes_apb/widgets/app_header.dart';
import 'identity_verification_page.dart';
import 'loan_history_page.dart';
import 'login_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = const Color(0xFFD32F2F),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Profil',
              subtitle: 'Informasi akun dan pengaturan',
              icon: Icons.person_rounded,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD32F2F),
                          Color(0xFFF44336),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Dewa Mahasiswa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'dewa@telkomuniversity.ac.id',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'Belum Terverifikasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  menuTile(
                    icon: Icons.history_outlined,
                    title: 'Riwayat Pinjaman',
                    subtitle: 'Lihat semua pinjaman yang pernah dibuat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoanHistoryPage(),
                        ),
                      );
                    },
                  ),
                  menuTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Verifikasi Identitas',
                    subtitle: 'Cek status verifikasi akun',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IdentityVerificationPage(),
                        ),
                      );
                    },
                  ),
                  menuTile(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan',
                    subtitle: 'Kelola preferensi dan akun',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  menuTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Keluar dari aplikasi',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}