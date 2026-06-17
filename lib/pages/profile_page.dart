import 'package:flutter/material.dart';
import 'package:tubes_apb/pages/loan_history_page.dart';
import 'package:tubes_apb/pages/login_page.dart';
import 'package:tubes_apb/pages/settings_page.dart';
import 'package:tubes_apb/services/api_service.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryRed = Color(0xFFD32F2F);

  static const Color brightRed = Color(0xFFF44336);

  late Future<Map<String, dynamic>> profileFuture;

  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();

    profileFuture = ApiService.instance.getProfile();
  }

  void _retryProfile() {
    setState(() {
      profileFuture = ApiService.instance.getProfile();
    });
  }

  Future<void> _refreshProfile() async {
    final newFuture = ApiService.instance.getProfile();

    setState(() {
      profileFuture = newFuture;
    });

    await newFuture;
  }

  String _readValue(
    Map<String, dynamic> profile,
    List<String> keys, {
    String fallback = '-',
  }) {
    for (final key in keys) {
      final value = profile[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return fallback;
  }

  String _getName(Map<String, dynamic> profile) {
    return _readValue(profile, [
      'name',
      'full_name',
      'fullName',
      'nama',
    ], fallback: 'Pengguna Inst4Class');
  }

  String _getEmail(Map<String, dynamic> profile) {
    return _readValue(profile, [
      'email',
      'email_address',
      'emailAddress',
    ], fallback: 'Email belum tersedia');
  }

  String _getUsername(Map<String, dynamic> profile) {
    return _readValue(profile, ['username', 'user_name', 'userName']);
  }

  String _getStudentNumber(Map<String, dynamic> profile) {
    return _readValue(profile, [
      'nim',
      'student_number',
      'studentNumber',
      'identity_number',
      'identityNumber',
    ]);
  }

  String _getPhone(Map<String, dynamic> profile) {
    return _readValue(profile, [
      'phone',
      'phone_number',
      'phoneNumber',
      'no_hp',
      'nomor_telepon',
    ]);
  }

  String _getRole(Map<String, dynamic> profile) {
    final role = _readValue(profile, [
      'role',
      'user_role',
      'userRole',
    ], fallback: 'Mahasiswa');

    if (role.isEmpty) {
      return 'Mahasiswa';
    }

    return role[0].toUpperCase() + role.substring(1);
  }

  String _getInitial(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'U';
    }

    final parts = trimmed.split(' ').where((item) => item.isNotEmpty).toList();

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return trimmed[0].toUpperCase();
  }

  Future<void> _showLogoutConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: primaryRed),
              SizedBox(width: 10),
              Text('Konfirmasi Logout'),
            ],
          ),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari aplikasi?',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    if (isLoggingOut) {
      return;
    }

    setState(() {
      isLoggingOut = true;
    });

    try {
      await ApiService.instance.logout();
    } catch (_) {
      await ApiService.instance.clearSession();
    }

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _profileHeader(Map<String, dynamic> profile) {
    final name = _getName(profile);
    final email = _getEmail(profile);
    final role = _getRole(profile);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryRed, brightRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.70),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getInitial(name),
                style: const TextStyle(
                  color: primaryRed,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              role,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationCard(Map<String, dynamic> profile) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Akun',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 15),
          _informationRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama Lengkap',
            value: _getName(profile),
          ),
          _informationRow(
            icon: Icons.alternate_email_rounded,
            label: 'Username',
            value: _getUsername(profile),
          ),
          _informationRow(
            icon: Icons.badge_outlined,
            label: 'NIM',
            value: _getStudentNumber(profile),
          ),
          _informationRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _getEmail(profile),
          ),
          _informationRow(
            icon: Icons.phone_outlined,
            label: 'Nomor Telepon',
            value: _getPhone(profile),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: primaryRed, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color color = primaryRed,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing:
            trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator(color: primaryRed));
  }

  Widget _errorState(Object? error) {
    final message = error is ApiException
        ? error.message
        : 'Terjadi kesalahan saat mengambil profil.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 68,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 14),
            const Text(
              'Profil gagal dimuat',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _retryProfile,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
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
              title: 'Profil',
              subtitle: 'Informasi akun dan pengaturan',
              icon: Icons.person_rounded,
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _loadingState();
                  }

                  if (snapshot.hasError) {
                    return _errorState(snapshot.error);
                  }

                  final profile = snapshot.data ?? <String, dynamic>{};

                  return RefreshIndicator(
                    color: primaryRed,
                    onRefresh: _refreshProfile,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        _profileHeader(profile),
                        const SizedBox(height: 18),
                        _informationCard(profile),
                        const SizedBox(height: 20),
                        const Text(
                          'Menu Akun',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 11),
                        _menuTile(
                          icon: Icons.history_rounded,
                          title: 'Riwayat Peminjaman',
                          subtitle: 'Lihat semua pengajuan yang pernah dibuat',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoanHistoryPage(),
                              ),
                            );
                          },
                        ),
                        _menuTile(
                          icon: Icons.settings_rounded,
                          title: 'Pengaturan',
                          subtitle: 'Kelola preferensi aplikasi',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsPage(),
                              ),
                            );
                          },
                        ),
                        _menuTile(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          subtitle: 'Keluar dari akun Inst4Class',
                          color: Colors.red,
                          onTap: isLoggingOut ? null : _showLogoutConfirmation,
                          trailing: isLoggingOut
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.red,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.red,
                                ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
