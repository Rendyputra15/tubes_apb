import 'package:flutter/material.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool bookingNotification = true;
  bool darkMode = false;
  String selectedLanguage = 'Indonesia';

  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color titleRed = Color(0xFFE51C23);
  static const Color softRed = Color(0xFFFFE3E3);

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget tile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color color = primaryRed,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget infoRow({
    required IconData icon,
    required String label,
    required String value,
    Color color = titleRed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  void showProfileAccount() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return bottomSheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bottomSheetHandle(),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 38,
                backgroundColor: softRed,
                child: Icon(
                  Icons.person_rounded,
                  size: 42,
                  color: titleRed,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Profil Akun',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Informasi akun mahasiswa aktif',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              infoRow(
                icon: Icons.badge_rounded,
                label: 'Nama',
                value: 'Dewa Mahasiswa',
              ),
              infoRow(
                icon: Icons.numbers_rounded,
                label: 'NIM',
                value: '1202230049',
              ),
              infoRow(
                icon: Icons.email_rounded,
                label: 'Email',
                value: 'dewa@telkomuniversity.ac.id',
              ),
              infoRow(
                icon: Icons.school_rounded,
                label: 'Kampus',
                value: 'Telkom University Surabaya',
              ),
              infoRow(
                icon: Icons.verified_user_rounded,
                label: 'Status',
                value: 'Mahasiswa Aktif',
                color: Colors.green,
              ),
              const SizedBox(height: 14),
              closeButton(),
            ],
          ),
        );
      },
    );
  }

  void showSecurityAccount() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return bottomSheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bottomSheetHandle(),
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: titleRed,
                  size: 38,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Keamanan Akun',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Proteksi login dan keamanan akun mahasiswa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              infoRow(
                icon: Icons.lock_clock_rounded,
                label: 'Login Terakhir',
                value: 'Hari ini',
              ),
              infoRow(
                icon: Icons.shield_rounded,
                label: 'Metode Login',
                value: 'SSO Tel-U',
                color: Colors.blue,
              ),
              infoRow(
                icon: Icons.verified_rounded,
                label: 'Verifikasi Akun',
                value: 'Aktif',
                color: Colors.green,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: softRed.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_rounded,
                      color: titleRed,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Nantinya login dapat dihubungkan dengan API Telkom University Surabaya, sehingga hanya mahasiswa aktif yang bisa masuk menggunakan username dan password SSO Tel-U.',
                        style: TextStyle(
                          color: Colors.grey[800],
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              closeButton(),
            ],
          ),
        );
      },
    );
  }

  void showLanguageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return bottomSheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bottomSheetHandle(),
              const SizedBox(height: 20),
              const Text(
                'Pilih Bahasa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pilih bahasa yang digunakan pada aplikasi',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              languageOption('Indonesia', Icons.flag_rounded),
              languageOption('English', Icons.language_rounded),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  Widget languageOption(String language, IconData icon) {
    final bool selected = selectedLanguage == language;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bahasa diubah ke $language'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? softRed : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? titleRed : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? titleRed : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: selected ? titleRed : Colors.black87,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: titleRed,
              ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: SingleChildScrollView(child: child),
    );
  }

  Widget bottomSheetHandle() {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget closeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: titleRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: const Text(
          'Tutup',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
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
                    subtitle: 'Lihat informasi akun mahasiswa',
                    onTap: showProfileAccount,
                  ),
                  tile(
                    icon: Icons.lock_outline,
                    title: 'Keamanan Akun',
                    subtitle: 'Informasi login dan proteksi akun',
                    onTap: showSecurityAccount,
                  ),

                  sectionTitle('Notifikasi'),
                  tile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifikasi Peminjaman',
                    subtitle: 'Aktifkan info status pinjaman',
                    trailing: Switch(
                      value: bookingNotification,
                      activeColor: titleRed,
                      onChanged: (value) {
                        setState(() {
                          bookingNotification = value;
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
                      activeColor: titleRed,
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
                    subtitle: selectedLanguage,
                    onTap: showLanguageOptions,
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