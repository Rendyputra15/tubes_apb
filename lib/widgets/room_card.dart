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

  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color titleRed = Color(0xFFE51C23);

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoomImage(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFEBEE,
                            ),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: Text(
                            room.code,
                            style: const TextStyle(
                              color: titleRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 17,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            room.location,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.layers_outlined,
                          size: 17,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Lantai ${room.floor}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(
                          Icons.people_outline_rounded,
                          size: 17,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${room.capacity} orang',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    if (room.facilities.isNotEmpty) ...[
                      const SizedBox(height: 9),
                      Text(
                        _facilityText(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onDetailTap,
                            style:
                                OutlinedButton.styleFrom(
                              foregroundColor: titleRed,
                              side: const BorderSide(
                                color: titleRed,
                                width: 1.3,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Detail',
                              style: TextStyle(
                                color: titleRed,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onBorrowTap,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor: primaryRed,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Pinjam',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),
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

  Widget _buildRoomImage() {
    if (room.imageUrl.trim().isEmpty) {
      return _imagePlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        room.imageUrl,
        width: 96,
        height: 126,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _imagePlaceholder();
        },
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 96,
      height: 126,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.meeting_room_rounded,
        color: primaryRed,
        size: 42,
      ),
    );
  }

  String _facilityText() {
    final visibleFacilities =
        room.facilities.take(3).join(' • ');

    if (room.facilities.length > 3) {
      return '$visibleFacilities • lainnya';
    }

    return visibleFacilities;
  }
}