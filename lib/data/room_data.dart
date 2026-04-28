import 'package:tubes_apb/models/room_model.dart';

class RoomData {
  static final List<Room> allRooms = _generateRooms();

  static List<Room> _generateRooms() {
    final List<String> roomNumbers = [
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '09',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
    ];

    final List<String> statuses = [
      'Tersedia',
      'Tersedia',
      'Cleaning',
      'Terpakai',
    ];

    final List<String> facilities = [
      'TV',
      'Proyektor',
      'Papan Tulis Putih',
      'AC',
      'WiFi',
      'Kursi & Meja',
      'Kabel Olor',
    ];

    final List<String> images = [
      'https://images.unsplash.com/photo-1509062522246-3755977927d7?q=80&w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1497366811353-6870744d04b2?q=80&w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1517502884422-41eaead166d4?q=80&w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=1200&auto=format&fit=crop',
    ];

    final List<Map<String, List<String>>> scheduleTemplates = [
      {
        'Senin': ['07.00 - 08.30', '10.30 - 12.00', '15.30 - 17.00'],
        'Selasa': ['08.30 - 10.00', '13.00 - 14.30'],
        'Rabu': ['07.00 - 08.30', '12.30 - 14.00', '14.00 - 15.30'],
        'Kamis': ['10.30 - 12.00', '13.00 - 14.30', '15.30 - 17.00'],
        'Jumat': ['08.00 - 09.30', '13.30 - 15.00'],
      },
      {
        'Senin': ['08.30 - 10.00', '13.00 - 14.30'],
        'Selasa': ['07.00 - 08.30', '10.30 - 12.00', '15.30 - 17.00'],
        'Rabu': ['09.00 - 10.30', '13.00 - 14.30'],
        'Kamis': ['07.00 - 08.30', '12.30 - 14.00'],
        'Jumat': ['10.00 - 11.30', '14.00 - 15.30'],
      },
      {
        'Senin': ['09.00 - 10.30', '14.00 - 15.30'],
        'Selasa': ['08.00 - 09.30', '11.00 - 12.30'],
        'Rabu': ['07.00 - 08.30', '10.30 - 12.00', '15.30 - 17.00'],
        'Kamis': ['09.30 - 11.00', '13.30 - 15.00'],
        'Jumat': ['07.00 - 08.30', '10.00 - 11.30'],
      },
      {
        'Senin': ['07.30 - 09.00', '12.30 - 14.00'],
        'Selasa': ['09.00 - 10.30', '13.00 - 14.30'],
        'Rabu': ['08.30 - 10.00', '14.30 - 16.00'],
        'Kamis': ['07.00 - 08.30', '10.30 - 12.00', '15.00 - 16.30'],
        'Jumat': ['09.30 - 11.00', '13.00 - 14.30'],
      },
    ];

    final List<Room> rooms = [];
    int index = 0;

    for (int floor = 1; floor <= 2; floor++) {
      for (final number in roomNumbers) {
        final roomCode = '$floor.$number';
        final schedules = scheduleTemplates[index % scheduleTemplates.length];

        rooms.add(
          Room(
            name: 'Kelas $roomCode',
            capacity: 40,
            status: statuses[index % statuses.length],
            time: 'Menyesuaikan jadwal akademik',
            location: 'Gedung Kuliah Lantai $floor',
            imageUrl: images[index % images.length],
            facilities: facilities,
            description:
                'Ruang kelas $roomCode digunakan untuk kegiatan akademik, diskusi, presentasi, dan peminjaman di luar jadwal mata kuliah.',
            availableSchedules: schedules,
          ),
        );

        index++;
      }
    }

    return rooms;
  }
}