import 'package:flutter/material.dart';
import 'package:tubes_apb/models/room_model.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onDetailTap;
  final VoidCallback onBorrowTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.onDetailTap,
    required this.onBorrowTap,
  });

  Color getStatusColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(room.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: onDetailTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  room.imageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 96,
                      height: 96,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(room.location),
                    const SizedBox(height: 5),
                    Text('Kapasitas ${room.capacity} orang'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            room.status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onDetailTap,
                            child: const Text('Detail'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                room.status == 'Tersedia' ? onBorrowTap : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                            ),
                            child: const Text('Pinjam'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}