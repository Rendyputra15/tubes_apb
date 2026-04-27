import 'package:flutter/material.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'borrow_form_page.dart';

class RoomDetailPage extends StatelessWidget {
  final Room room;

  const RoomDetailPage({
    super.key,
    required this.room,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'Tersedia':
        return Colors.green;
      case 'Cleaning':
        return Colors.orange;
      case 'Terpakai':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget facilityChip(String facility) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        facility,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(room.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Detail Ruangan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                room.imageUrl,
                height: 210,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 210,
                    color: Colors.grey[300],
                    child: const Icon(Icons.meeting_room, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              room.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    room.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Kapasitas ${room.capacity} orang',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Lokasi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              room.location,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              room.description,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Fasilitas',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: room.facilities.map(facilityChip).toList(),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: room.status == 'Tersedia'
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BorrowFormPage(room: room),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE51C23),
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Pinjam Sekarang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}