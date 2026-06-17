import 'package:flutter/material.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/services/api_service.dart';
import 'package:tubes_apb/widgets/app_header.dart';
import 'package:tubes_apb/widgets/room_card.dart';

import 'borrow_form_page.dart';
import 'room_detail_page.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  static const Color primaryRed = Color(0xFFD32F2F);

  static const Color titleRed = Color(0xFFE51C23);

  String selectedFilter = 'Semua';

  late Future<List<Room>> roomsFuture;

  final List<String> filters = const ['Semua', 'Lantai 1', 'Lantai 2'];

  @override
  void initState() {
    super.initState();

    roomsFuture = ApiService.instance.getRooms();
  }

  Future<void> _refreshRooms() async {
    final newFuture = ApiService.instance.getRooms();

    setState(() {
      roomsFuture = newFuture;
    });

    await newFuture;
  }

  void _retryLoadRooms() {
    setState(() {
      roomsFuture = ApiService.instance.getRooms();
    });
  }

  List<Room> _filterRooms(List<Room> rooms) {
    switch (selectedFilter) {
      case 'Lantai 1':
        return rooms.where((room) => room.floor == 1).toList();

      case 'Lantai 2':
        return rooms.where((room) => room.floor == 2).toList();

      default:
        return rooms;
    }
  }

  Widget _filterChip(String label) {
    final bool isSelected = selectedFilter == label;

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
          color: isSelected ? titleRed : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? titleRed : Colors.grey.shade200,
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

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator(color: primaryRed));
  }

  Widget _errorState(Object? error) {
    String message = 'Terjadi kesalahan saat mengambil data ruangan.';

    if (error is ApiException) {
      message = error.message;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 14),
            const Text(
              'Gagal memuat ruangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _retryLoadRooms,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              selectedFilter == 'Semua'
                  ? 'Belum ada data ruangan.'
                  : 'Tidak ada ruangan pada $selectedFilter.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roomList(List<Room> rooms) {
    final filteredRooms = _filterRooms(rooms);

    if (filteredRooms.isEmpty) {
      return _emptyState();
    }

    return RefreshIndicator(
      color: primaryRed,
      onRefresh: _refreshRooms,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        itemCount: filteredRooms.length,
        itemBuilder: (context, index) {
          final room = filteredRooms[index];

          return RoomCard(
            room: room,
            onDetailTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RoomDetailPage(room: room)),
              );
            },
            onBorrowTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BorrowFormPage(room: room)),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Ruangan',
              subtitle: 'Lihat daftar ruang kelas dan fasilitasnya',
              icon: Icons.meeting_room_rounded,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 46,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                children: filters.map(_filterChip).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Room>>(
                future: roomsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _loadingState();
                  }

                  if (snapshot.hasError) {
                    return _errorState(snapshot.error);
                  }

                  final rooms = snapshot.data ?? [];

                  return _roomList(rooms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
