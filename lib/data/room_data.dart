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

    final List<List<String>> scheduleTemplates = [
      ['07.00 - 09.00', '09.30 - 11.30', '13.00 - 15.00'],
      ['07.30 - 09.30', '10.00 - 12.00', '13.30 - 15.30'],
      ['08.00 - 10.00', '10.30 - 12.30', '14.00 - 16.00'],
      ['08.30 - 10.30', '11.00 - 13.00', '15.00 - 17.00'],
      ['07.00 - 08.30', '09.00 - 11.00', '12.30 - 14.30', '15.00 - 17.00'],
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

    final List<Room> rooms = [];

    int index = 0;

    for (int floor = 1; floor <= 2; floor++) {
      for (final number in roomNumbers) {
        final roomCode = '$floor.$number';

        rooms.add(
          Room(
            name: 'Kelas $roomCode',
            capacity: 40,
            status: statuses[index % statuses.length],
            time: scheduleTemplates[index % scheduleTemplates.length].join(', '),
            location: 'Gedung Kuliah Lantai $floor',
            imageUrl: images[index % images.length],
            facilities: facilities,
            description:
                'Ruang kelas $roomCode digunakan untuk kegiatan belajar, diskusi, presentasi, dan rapat akademik.',
            schedules: scheduleTemplates[index % scheduleTemplates.length],
          ),
        );

        index++;
      }
    }

    return rooms;
  }
}