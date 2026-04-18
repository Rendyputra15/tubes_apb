import 'package:flutter/material.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/widgets/app_header.dart';
import 'package:tubes_apb/widgets/room_card.dart';
import 'package:tubes_apb/widgets/summary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  late List<Room> previewRooms;
  late List<Room> filteredRooms;

  @override
  void initState() {
    super.initState();
    previewRooms = RoomData.allRooms.take(4).toList();
    filteredRooms = List.from(previewRooms);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchRooms(String keyword) {
    setState(() {
      if (keyword.trim().isEmpty) {
        filteredRooms = List.from(previewRooms);
      } else {
        filteredRooms = previewRooms.where((room) {
          return room.name.toLowerCase().contains(keyword.toLowerCase());
        }).toList();
      }
    });
  }

  void resetSearch() {
    searchController.clear();
    setState(() {
      filteredRooms = List.from(previewRooms);
    });
  }

  int get availableCount =>
      RoomData.allRooms.where((room) => room.status == 'Tersedia').length;

  int get cleaningCount =>
      RoomData.allRooms.where((room) => room.status == 'Cleaning').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(
                title: 'Inst4Class',
                subtitle: 'Smart Room Booking System',
                icon: Icons.meeting_room_rounded,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: searchRooms,
                    onChanged: searchRooms,
                    decoration: InputDecoration(
                      hintText: 'Cari ruangan...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: resetSearch,
                              icon: const Icon(Icons.close),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Tersedia',
                        value: '$availableCount',
                        icon: Icons.meeting_room,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Cleaning',
                        value: '$cleaningCount',
                        icon: Icons.cleaning_services,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preview Ruangan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              filteredRooms.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.search_off, size: 50),
                            SizedBox(height: 12),
                            Text(
                              'Ruangan tidak ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredRooms.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        return RoomCard(room: filteredRooms[index]);
                      },
                    ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}