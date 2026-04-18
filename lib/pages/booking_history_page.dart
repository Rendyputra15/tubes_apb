import 'package:flutter/material.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = [
      {
        'room': 'Ruang A201',
        'date': '17 April 2026',
        'status': 'Berhasil',
      },
      {
        'room': 'Lab Komputer 1',
        'date': '16 April 2026',
        'status': 'Menunggu',
      },
      {
        'room': 'Ruang Diskusi D204',
        'date': '15 April 2026',
        'status': 'Selesai',
      },
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case 'Berhasil':
          return Colors.green;
        case 'Menunggu':
          return Colors.orange;
        case 'Selesai':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Riwayat',
              subtitle: 'Daftar booking yang pernah dilakukan',
              icon: Icons.history,
              showBackButton: true,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final item = bookings[index];
                  final color = getStatusColor(item['status']!);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withOpacity(0.12),
                          child: Icon(Icons.bookmark_added, color: color),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['room']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(item['date']!),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['status']!,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
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