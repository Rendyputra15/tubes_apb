import 'package:tubes_apb/models/room_model.dart';

class RoomData {
  static List<Room> allRooms = [
    Room(
      name: 'Ruang A201',
      capacity: 30,
      status: 'Tersedia',
      time: 'Kosong sampai 13:00',
    ),
    Room(
      name: 'Ruang B105',
      capacity: 25,
      status: 'Cleaning',
      time: 'Tersedia dalam 10 menit',
    ),
    Room(
      name: 'Ruang C303',
      capacity: 40,
      status: 'Tersedia',
      time: 'Kosong sampai 15:30',
    ),
    Room(
      name: 'Lab Komputer 1',
      capacity: 35,
      status: 'Tersedia',
      time: 'Kosong sampai 16:00',
    ),
    Room(
      name: 'Ruang Diskusi D204',
      capacity: 15,
      status: 'Tersedia',
      time: 'Kosong sampai 14:30',
    ),
    Room(
      name: 'Ruang E101',
      capacity: 20,
      status: 'Dipakai',
      time: 'Dipakai sampai 12:00',
    ),
    Room(
      name: 'Lab Multimedia 2',
      capacity: 32,
      status: 'Tersedia',
      time: 'Kosong sampai 17:00',
    ),
  ];
}