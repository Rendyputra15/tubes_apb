import 'package:flutter/material.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool bookingNotification = true;
  bool appNotification = true;
  bool darkMode = false;

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget tile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color color = const Color(0xFFD32F2F),
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
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
              title: 'Pengaturan',
              subtitle: 'Kelola preferensi aplikasi',
              icon: Icons.settings_outlined,
              showBackButton: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  sectionTitle('Akun'),
                  tile(
                    icon: Icons.person_outline,
                    title: 'Profil Akun',
                    subtitle: 'Ubah nama dan informasi akun',
                    onTap: () {},
                  ),
                  tile(
                    icon: Icons.lock_outline,
                    title: 'Keamanan Akun',
                    subtitle: 'Ubah password dan proteksi login',
                    onTap: () {},
                  ),
                  sectionTitle('Notifikasi'),
                  tile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifikasi Peminjaman',
                    subtitle: 'Aktifkan info status pinjaman',
                    trailing: Switch(
                      value: bookingNotification,
                      onChanged: (value) {
                        setState(() {
                          bookingNotification = value;
                        });
                      },
                    ),
                  ),
                  tile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifikasi Aplikasi',
                    subtitle: 'Info promo dan pembaruan aplikasi',
                    trailing: Switch(
                      value: appNotification,
                      onChanged: (value) {
                        setState(() {
                          appNotification = value;
                        });
                      },
                    ),
                  ),
                  sectionTitle('Tampilan'),
                  tile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Mode Gelap',
                    subtitle: 'Aktifkan tema gelap',
                    trailing: Switch(
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });
                      },
                    ),
                  ),
                  tile(
                    icon: Icons.language_outlined,
                    title: 'Bahasa',
                    subtitle: 'Indonesia',
                    onTap: () {},
                  ),
                  sectionTitle('Lainnya'),
                  tile(
                    icon: Icons.help_outline,
                    title: 'Bantuan & FAQ',
                    subtitle: 'Pertanyaan umum dan bantuan pengguna',
                    onTap: () {},
                  ),
                  tile(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    subtitle: 'Inst4Class versi 1.0',
                    onTap: () {},
                  ),
                  tile(
                    icon: Icons.support_agent_outlined,
                    title: 'Hubungi Admin',
                    subtitle: 'Laporkan kendala atau pertanyaan',
                    onTap: () {},
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