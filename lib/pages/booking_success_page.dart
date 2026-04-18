import 'package:flutter/material.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class BookingSuccessPage extends StatelessWidget {
  final String roomName;
  final int capacity;
  final String scheduleInfo;
  final String whatsapp;
  final String purpose;
  final String ktpFileName;

  const BookingSuccessPage({
    super.key,
    required this.roomName,
    required this.capacity,
    required this.scheduleInfo,
    required this.whatsapp,
    required this.purpose,
    required this.ktpFileName,
  });

  Widget detailItem({
    required IconData icon,
    required String title,
    required String value,
    Color color = const Color(0xFF1E88E5),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Berhasil',
              subtitle: 'Detail booking ruangan',
              icon: Icons.check_circle_rounded,
              showBackButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$roomName berhasil dibooking',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Berikut detail lengkap booking yang sudah kamu ajukan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    detailItem(
                      icon: Icons.meeting_room_outlined,
                      title: 'Ruangan',
                      value: roomName,
                    ),
                    detailItem(
                      icon: Icons.groups_rounded,
                      title: 'Kapasitas',
                      value: '$capacity orang',
                    ),
                    detailItem(
                      icon: Icons.schedule_rounded,
                      title: 'Jadwal',
                      value: scheduleInfo,
                    ),
                    detailItem(
                      icon: Icons.phone_android_rounded,
                      title: 'Nomor WhatsApp',
                      value: whatsapp,
                    ),
                    detailItem(
                      icon: Icons.description_outlined,
                      title: 'Keperluan',
                      value: purpose,
                    ),
                    detailItem(
                      icon: Icons.badge_outlined,
                      title: 'File KTP',
                      value: ktpFileName,
                    ),
                    detailItem(
                      icon: Icons.verified_rounded,
                      title: 'Status',
                      value: 'Booking berhasil diajukan',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Kembali ke Awal',
                          style: TextStyle(fontSize: 16),
                        ),
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