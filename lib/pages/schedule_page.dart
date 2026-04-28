import 'package:flutter/material.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/models/room_model.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String selectedFloor = 'Semua';
  String selectedDay = 'Senin';

  final List<String> floors = ['Semua', 'Lantai 1', 'Lantai 2'];
  final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  List<Room> get filteredRooms {
    if (selectedFloor == 'Semua') return RoomData.allRooms;

    if (selectedFloor == 'Lantai 1') {
      return RoomData.allRooms
          .where((room) => room.name.contains('1.'))
          .toList();
    }

    return RoomData.allRooms
        .where((room) => room.name.contains('2.'))
        .toList();
  }

  Color statusColor(String status) {
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

  Widget floorChip(String label) {
    final active = selectedFloor == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFloor = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE51C23) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget dayDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          selectedDay = value;
        });
      },
      itemBuilder: (context) {
        return days.map((day) {
          return PopupMenuItem(
            value: day,
            child: Text(day),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE51C23),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              selectedDay,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget scheduleChip(String time) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Color(0xFFE51C23),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget roomCard(Room room) {
    final schedules = room.availableSchedules[selectedDay] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor(room.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  room.status,
                  style: TextStyle(
                    color: statusColor(room.status),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Waktu tersedia hari $selectedDay',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 8),

          schedules.isEmpty
              ? const Text('Tidak ada waktu kosong')
              : Wrap(
                  children:
                      schedules.map((e) => scheduleChip(e)).toList(),
                ),
        ],
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
            const SizedBox(height: 16),

            const Text(
              'Jadwal Ruangan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: floors.map(floorChip).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  dayDropdown(),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return roomCard(rooms[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}