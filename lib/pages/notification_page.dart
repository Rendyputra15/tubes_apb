import 'package:flutter/material.dart';
import 'package:tubes_apb/data/app_state.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Color getColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle_outline;
      case 'warning':
        return Icons.hourglass_top_outlined;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.notifications_none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = AppState.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Notifikasi',
              subtitle: 'Status dan informasi peminjaman ruangan',
              icon: Icons.notifications_none_rounded,
            ),
            Expanded(
              child: notifications.isEmpty
                  ? const Center(
                      child: Text('Belum ada notifikasi peminjaman.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        final color = getColor(item.type);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: color.withOpacity(0.12),
                                child: Icon(getIcon(item.type), color: color),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.subtitle,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.time,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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