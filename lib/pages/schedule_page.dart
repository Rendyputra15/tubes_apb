import 'package:flutter/material.dart';
import '../data/room_data.dart';
import '../models/room_model.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  static const Color primaryRed = Color(0xFFE51C23);
  static const Color background = Color(0xFFF8F9FB);

  List<Map<String, String>> getSchedules(Room room) {
    if (room.name.contains('A101')) {
      return [
        {'time': '07.00 - 09.00', 'status': 'Tersedia'},
        {'time': '09.00 - 09.20', 'status': 'Cleaning'},
        {'time': '09.20 - 11.20', 'status': 'Dipakai'},
        {'time': '11.20 - 11.40', 'status': 'Cleaning'},
        {'time': '11.40 - 13.40', 'status': 'Tersedia'},
      ];
    }

    if (room.name.contains('B205')) {
      return [
        {'time': '08.00 - 10.00', 'status': 'Dipakai'},
        {'time': '10.00 - 10.20', 'status': 'Cleaning'},
        {'time': '10.20 - 12.20', 'status': 'Tersedia'},
        {'time': '12.20 - 12.40', 'status': 'Cleaning'},
        {'time': '12.40 - 14.40', 'status': 'Tersedia'},
      ];
    }

    if (room.name.contains('Lab')) {
      return [
        {'time': '07.30 - 09.30', 'status': 'Tersedia'},
        {'time': '09.30 - 09.50', 'status': 'Cleaning'},
        {'time': '09.50 - 11.50', 'status': 'Tersedia'},
        {'time': '11.50 - 12.10', 'status': 'Cleaning'},
        {'time': '12.10 - 14.10', 'status': 'Dipakai'},
      ];
    }

    return [
      {'time': '08.30 - 10.30', 'status': 'Tersedia'},
      {'time': '10.30 - 10.50', 'status': 'Cleaning'},
      {'time': '10.50 - 12.50', 'status': 'Dipakai'},
      {'time': '12.50 - 13.10', 'status': 'Cleaning'},
      {'time': '13.10 - 15.10', 'status': 'Tersedia'},
    ];
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Tersedia':
        return Colors.green;
      case 'Cleaning':
        return Colors.orange;
      case 'Dipakai':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'Tersedia':
        return Icons.check_circle;
      case 'Cleaning':
        return Icons.cleaning_services;
      case 'Dipakai':
        return Icons.block;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rooms = RoomData.allRooms;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 42,
                      height: 42,
                      child: Icon(Icons.arrow_back_ios_new, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Jadwal Ruangan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Lihat jam kosong setiap ruangan. Sesi peminjaman tersedia setiap 2 jam dengan jeda cleaning 20 menit.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final schedules = getSchedules(room);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.055),
                          blurRadius: 16,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                room.imageUrl,
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    width: 68,
                                    height: 68,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.meeting_room),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    room.location,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kapasitas ${room.capacity} orang',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Column(
                          children: schedules.map((item) {
                            final color = statusColor(item['status']!);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    statusIcon(item['status']!),
                                    color: color,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item['time']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['status']!,
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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