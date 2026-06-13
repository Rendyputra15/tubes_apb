import 'package:tubes_apb/models/room_model.dart';

class RoomData {
  static final List<Room> allRooms = _generateRooms();

  static List<Room> _generateRooms() {
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

    return [
      Room(
        name: 'Kelas 1.02',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[0],
        facilities: facilities,
        description:
            'Ruang kelas 1.02 digunakan untuk kegiatan akademik, diskusi, presentasi, dan peminjaman di luar jadwal mata kuliah.',
        availableSchedules: {
          'Senin': ['07.00 - 08.30', '10.30 - 12.00'],
          'Selasa': ['08.30 - 10.00', '13.00 - 14.30'],
          'Rabu': [],
          'Kamis': ['10.30 - 12.00', '15.30 - 17.00'],
          'Jumat': ['08.00 - 09.30'],
        },
      ),
      Room(
        name: 'Kelas 1.03',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[1],
        facilities: facilities,
        description:
            'Ruang kelas 1.03 cocok untuk pembelajaran, diskusi kelompok, dan kegiatan presentasi mahasiswa.',
        availableSchedules: {
          'Senin': [],
          'Selasa': ['07.00 - 08.30', '10.30 - 12.00'],
          'Rabu': ['09.00 - 10.30', '13.00 - 14.30'],
          'Kamis': [],
          'Jumat': ['10.00 - 11.30', '14.00 - 15.30'],
        },
      ),
      Room(
        name: 'Kelas 1.04',
        capacity: 40,
        status: 'Terpakai',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[2],
        facilities: facilities,
        description:
            'Ruang kelas 1.04 biasa digunakan untuk perkuliahan reguler dan kegiatan akademik tambahan.',
        availableSchedules: {
          'Senin': ['09.00 - 10.30'],
          'Selasa': [],
          'Rabu': ['07.00 - 08.30', '15.30 - 17.00'],
          'Kamis': ['09.30 - 11.00'],
          'Jumat': [],
        },
      ),
      Room(
        name: 'Kelas 1.05',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[3],
        facilities: facilities,
        description:
            'Ruang kelas 1.05 memiliki fasilitas lengkap untuk kegiatan belajar, rapat kecil, dan diskusi.',
        availableSchedules: {
          'Senin': [],
          'Selasa': ['08.30 - 10.00', '13.00 - 14.30'],
          'Rabu': ['10.30 - 12.00'],
          'Kamis': ['07.00 - 08.30', '15.00 - 16.30'],
          'Jumat': ['08.00 - 09.30', '13.30 - 15.00'],
        },
      ),
      Room(
        name: 'Kelas 1.06',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[0],
        facilities: facilities,
        description:
            'Ruang kelas 1.06 dapat digunakan untuk perkuliahan, seminar kecil, dan kegiatan organisasi mahasiswa.',
        availableSchedules: {
          'Senin': ['13.00 - 14.30', '15.30 - 17.00'],
          'Selasa': [],
          'Rabu': ['08.30 - 10.00'],
          'Kamis': ['10.30 - 12.00'],
          'Jumat': [],
        },
      ),
      Room(
        name: 'Kelas 1.07',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[1],
        facilities: facilities,
        description:
            'Ruang kelas 1.07 mendukung kegiatan pembelajaran dan presentasi dengan suasana kelas yang nyaman.',
        availableSchedules: {
          'Senin': ['07.00 - 08.30', '12.30 - 14.00'],
          'Selasa': ['09.00 - 10.30'],
          'Rabu': [],
          'Kamis': ['13.00 - 14.30'],
          'Jumat': ['10.00 - 11.30'],
        },
      ),
      Room(
        name: 'Kelas 1.09',
        capacity: 40,
        status: 'Terpakai',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[2],
        facilities: facilities,
        description:
            'Ruang kelas 1.09 sering digunakan untuk pembelajaran reguler dan kegiatan akademik terjadwal.',
        availableSchedules: {
          'Senin': [],
          'Selasa': ['15.30 - 17.00'],
          'Rabu': ['07.00 - 08.30', '10.30 - 12.00'],
          'Kamis': [],
          'Jumat': ['13.00 - 14.30'],
        },
      ),
      Room(
        name: 'Kelas 1.15',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 1',
        imageUrl: images[3],
        facilities: facilities,
        description:
            'Ruang kelas 1.15 cocok digunakan untuk diskusi kelompok, presentasi, dan kegiatan mahasiswa.',
        availableSchedules: {
          'Senin': ['08.30 - 10.00'],
          'Selasa': ['11.00 - 12.30', '14.00 - 15.30'],
          'Rabu': [],
          'Kamis': ['07.00 - 08.30', '12.30 - 14.00'],
          'Jumat': ['09.30 - 11.00'],
        },
      ),
      Room(
        name: 'Kelas 2.03',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 2',
        imageUrl: images[0],
        facilities: facilities,
        description:
            'Ruang kelas 2.03 berada di lantai dua dan mendukung kegiatan kelas, rapat, serta presentasi.',
        availableSchedules: {
          'Senin': ['10.30 - 12.00', '15.30 - 17.00'],
          'Selasa': [],
          'Rabu': ['09.00 - 10.30'],
          'Kamis': ['13.00 - 14.30'],
          'Jumat': [],
        },
      ),
      Room(
        name: 'Kelas 2.05',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 2',
        imageUrl: images[1],
        facilities: facilities,
        description:
            'Ruang kelas 2.05 dapat dipakai untuk pembelajaran, kegiatan organisasi, dan diskusi akademik.',
        availableSchedules: {
          'Senin': [],
          'Selasa': ['07.00 - 08.30', '13.00 - 14.30'],
          'Rabu': ['10.30 - 12.00'],
          'Kamis': [],
          'Jumat': ['08.00 - 09.30', '14.00 - 15.30'],
        },
      ),
      Room(
        name: 'Kelas 2.09',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 2',
        imageUrl: images[2],
        facilities: facilities,
        description:
            'Ruang kelas 2.09 memiliki fasilitas lengkap untuk mendukung kegiatan akademik mahasiswa.',
        availableSchedules: {
          'Senin': ['07.30 - 09.00'],
          'Selasa': ['09.00 - 10.30', '15.30 - 17.00'],
          'Rabu': [],
          'Kamis': ['08.30 - 10.00'],
          'Jumat': ['13.00 - 14.30'],
        },
      ),
      Room(
        name: 'Kelas 2.15',
        capacity: 40,
        status: 'Terpakai',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 2',
        imageUrl: images[3],
        facilities: facilities,
        description:
            'Ruang kelas 2.15 biasa digunakan untuk kelas reguler, diskusi tim, dan persiapan presentasi.',
        availableSchedules: {
          'Senin': ['12.30 - 14.00'],
          'Selasa': [],
          'Rabu': ['08.30 - 10.00', '14.30 - 16.00'],
          'Kamis': ['07.00 - 08.30', '15.00 - 16.30'],
          'Jumat': [],
        },
      ),
      Room(
        name: 'Kelas 2.20',
        capacity: 40,
        status: 'Tersedia',
        time: 'Menyesuaikan jadwal akademik',
        location: 'Gedung Kuliah Lantai 2',
        imageUrl: images[0],
        facilities: facilities,
        description:
            'Ruang kelas 2.20 digunakan untuk kegiatan akademik, diskusi, dan peminjaman di luar jadwal perkuliahan.',
        availableSchedules: {
          'Senin': [],
          'Selasa': ['08.00 - 09.30'],
          'Rabu': ['10.30 - 12.00', '15.30 - 17.00'],
          'Kamis': [],
          'Jumat': ['07.00 - 08.30', '10.00 - 11.30'],
        },
      ),
    ];
  }
}