import 'package:flutter/material.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/widgets/room_card.dart';
import 'borrow_form_page.dart';
import 'room_detail_page.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  String selectedFilter = 'Semua';

  final List<String> filters = [
    'Semua',
    'Tersedia',
    'Cleaning',
    'Terpakai',
  ];

  List<Room> get filteredRooms {
    if (selectedFilter == 'Semua') {
      return RoomData.allRooms;
    }

    return RoomData.allRooms
        .where((room) => room.status == selectedFilter)
        .toList();
  }

  Color getFilterColor(String filter) {
    switch (filter) {
      case 'Tersedia':
        return Colors.green;
      case 'Cleaning':
        return Colors.orange;
      case 'Terpakai':
        return Colors.red;
      default:
        return const Color(0xFFE51C23);
    }
  }

  Widget filterChip(String label) {
    final isSelected = selectedFilter == label;
    final color = getFilterColor(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.meeting_room_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            const Text(
              'Ruangan tidak ditemukan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tidak ada ruangan dengan status $selectedFilter.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = filteredRooms;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                children: [
                  const Text(
                    'Ruangan',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE51C23),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.meeting_room_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih ruang kelas berdasarkan status ketersediaan.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 46,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                children: filters.map(filterChip).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: rooms.isEmpty
                  ? emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];

                        return RoomCard(
                          room: room,
                          onDetailTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RoomDetailPage(room: room),
                              ),
                            );
                          },
                          onBorrowTap: () {
                            if (room.status != 'Tersedia') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ruangan hanya bisa dipinjam jika status tersedia.',
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BorrowFormPage(room: room),
                              ),
                            );
                          },
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