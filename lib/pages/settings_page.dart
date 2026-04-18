import 'package:flutter/material.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationEnabled = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Pengaturan',
              subtitle: 'Kelola preferensi aplikasi',
              icon: Icons.settings,
              showBackButton: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: notificationEnabled,
                          title: const Text('Notifikasi'),
                          subtitle: const Text('Aktifkan notifikasi booking'),
                          onChanged: (value) {
                            setState(() {
                              notificationEnabled = value;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          value: darkMode,
                          title: const Text('Mode Gelap'),
                          subtitle: const Text('Tampilan tema gelap'),
                          onChanged: (value) {
                            setState(() {
                              darkMode = value;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('Tentang Aplikasi'),
                          subtitle: const Text('Inst4Class v1.0'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Inst4Class versi 1.0'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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