import 'package:flutter/material.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/widgets/app_header.dart';
import 'package:tubes_apb/widgets/room_card.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final TextEditingController searchController = TextEditingController();
  late List<Room> allRooms;
  late List<Room> filteredRooms;

  @override
  void initState() {
    super.initState();
    allRooms = RoomData.allRooms;
    filteredRooms = List.from(allRooms);
  }

  void searchRooms(String keyword) {
    setState(() {
      if (keyword.trim().isEmpty) {
        filteredRooms = List.from(allRooms);
      } else {
        filteredRooms = allRooms.where((room) {
          return room.name.toLowerCase().contains(keyword.toLowerCase());
        }).toList();
      }
    });
  }

  void resetSearch() {
    searchController.clear();
    setState(() {
      filteredRooms = List.from(allRooms);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Jadwal',
              subtitle: 'Daftar lengkap ruangan dan statusnya',
              icon: Icons.calendar_today_rounded,
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
                  onSubmitted: searchRooms,
                  onChanged: searchRooms,
                  decoration: InputDecoration(
                    hintText: 'Cari semua ruangan...',
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRooms.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return RoomCard(room: filteredRooms[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}