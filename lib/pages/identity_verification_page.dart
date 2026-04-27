import 'package:flutter/material.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class IdentityVerificationPage extends StatelessWidget {
  const IdentityVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Verifikasi',
              subtitle: 'Status verifikasi identitas akun',
              icon: Icons.verified_user_outlined,
              showBackButton: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.pending_actions_outlined,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Status Verifikasi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Akun kamu saat ini belum terverifikasi penuh. Verifikasi diperlukan agar proses pinjam ruangan menjadi lebih cepat.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5E5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Status saat ini: Belum Terverifikasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Permintaan verifikasi sedang diproses.'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Cek Status'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}