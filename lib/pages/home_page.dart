import 'package:flutter/material.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/pages/borrow_form_page.dart';
import 'package:tubes_apb/pages/loan_history_page.dart';
import 'package:tubes_apb/pages/profile_page.dart';
import 'package:tubes_apb/pages/room_detail_page.dart';
import 'package:tubes_apb/pages/schedule_page.dart';
import 'package:tubes_apb/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryRed = Color(0xFFE51C23);

  static const Color background = Color(0xFFF8F9FB);

  late Future<List<Room>> roomsFuture;

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

  void _retryLoad() {
    setState(() {
      roomsFuture = ApiService.instance.getRooms();
    });
  }

  bool _isRoomAvailable(Room room) {
    final status = room.status.toLowerCase();

    return status == 'tersedia' || status == 'available' || room.isActive;
  }

  List<Room> _getRecommendedRooms(List<Room> rooms) {
    final availableRooms = rooms.where(_isRoomAvailable).take(4).toList();

    if (availableRooms.isNotEmpty) {
      return availableRooms;
    }

    return rooms.take(4).toList();
  }

  Room? _getFirstAvailableRoom(List<Room> rooms) {
    for (final room in rooms) {
      if (_isRoomAvailable(room)) {
        return room;
      }
    }

    if (rooms.isNotEmpty) {
      return rooms.first;
    }

    return null;
  }

  Future<void> _goToBorrowForm(List<Room> rooms) async {
    final room = _getFirstAvailableRoom(rooms);

    if (room == null) {
      _showMessage('Belum ada ruangan yang tersedia untuk dipinjam.');

      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BorrowFormPage(room: room)),
    );

    if (!mounted) {
      return;
    }

    await _refreshRooms();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _stickyHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryRed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.meeting_room_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
                children: [
                  TextSpan(
                    text: 'Inst4',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: 'Class',
                    style: TextStyle(color: primaryRed),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primaryRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryRed.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'AD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroCard(List<Room> rooms) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF3B45), Color(0xFFE51C23), Color(0xFFD90416)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.30),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(
              right: -35,
              top: -30,
              child: Container(
                width: 145,
                height: 145,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.10),
                ),
              ),
            ),
            Positioned(
              right: 18,
              bottom: 20,
              child: Icon(
                Icons.groups_rounded,
                size: 110,
                color: Colors.white.withOpacity(0.18),
              ),
            ),
            Positioned(
              right: 28,
              top: 35,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.meeting_room_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Selamat datang 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Temukan ruangan\nterbaik untuk\nkegiatanmu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      height: 1.12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      _goToBorrowForm(rooms);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Pinjam mudah & cepat',
                            style: TextStyle(
                              color: primaryRed,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _featurePanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _featureItem(
            icon: Icons.calendar_month_rounded,
            title: 'Jadwal',
            color: Colors.orange,
            backgroundColor: const Color(0xFFFFF0DA),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SchedulePage()),
              );
            },
          ),
          _featureItem(
            icon: Icons.history_rounded,
            title: 'Riwayat',
            color: Colors.blue,
            backgroundColor: const Color(0xFFE7F2FF),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoanHistoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureItem({
    required IconData icon,
    required String title,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 110,
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendationList(List<Room> rooms) {
    if (rooms.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Icon(
              Icons.meeting_room_outlined,
              size: 52,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 10),
            const Text(
              'Belum ada data ruangan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 18, right: 8),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return _recommendationCard(rooms[index]);
        },
      ),
    );
  }

  Widget _recommendationCard(Room room) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RoomDetailPage(room: room)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: room.imageUrl.isNotEmpty
                  ? Image.network(
                      room.imageUrl,
                      height: 112,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _roomPlaceholder();
                      },
                    )
                  : _roomPlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kapasitas ${room.capacity} orang',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      Icon(
                        _isRoomAvailable(room)
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: _isRoomAvailable(room)
                            ? Colors.green
                            : Colors.red,
                        size: 17,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          room.status.isEmpty
                              ? (_isRoomAvailable(room)
                                    ? 'Tersedia'
                                    : 'Tidak tersedia')
                              : room.status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _isRoomAvailable(room)
                                ? Colors.green
                                : Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
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
    );
  }

  Widget _roomPlaceholder() {
    return Container(
      height: 112,
      width: double.infinity,
      color: const Color(0xFFFFE5E7),
      child: const Icon(
        Icons.meeting_room_rounded,
        color: primaryRed,
        size: 42,
      ),
    );
  }

  Widget _feedbackSection() {
    final feedbacks = [
      {
        'name': 'Ahmad Dewa',
        'role': 'Mahasiswa Teknologi Informasi',
        'text': 'Peminjaman ruangan menjadi lebih cepat dan mudah.',
        'rating': 5,
        'initial': 'AD',
      },
      {
        'name': 'Salsa Putri',
        'role': 'Mahasiswa Sistem Informasi',
        'text': 'Aplikasi membantu mengecek ruangan yang tersedia.',
        'rating': 5,
        'initial': 'SP',
      },
      {
        'name': 'Rizky Pratama',
        'role': 'Mahasiswa Informatika',
        'text': 'Tampilan jelas dan proses peminjaman mudah dipahami.',
        'rating': 4,
        'initial': 'RP',
      },
    ];

    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 18, right: 8),
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final item = feedbacks[index];

          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryRed,
                      child: Text(
                        item['initial'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            item['role'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(5, (starIndex) {
                    final rating = item['rating'] as int;

                    return Icon(
                      starIndex < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.orange,
                      size: 19,
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    '"${item['text']}"',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.45,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loadingState() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator(color: primaryRed)),
    );
  }

  Widget _errorState(Object? error) {
    final message = error is ApiException
        ? error.message
        : 'Data ruangan gagal dimuat.';

    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 14),
              const Text(
                'Gagal memuat beranda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _retryLoad,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FutureBuilder<List<Room>>(
          future: roomsFuture,
          builder: (context, snapshot) {
            final rooms = snapshot.data ?? [];
            final recommendedRooms = _getRecommendedRooms(rooms);

            return RefreshIndicator(
              color: primaryRed,
              onRefresh: _refreshRooms,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: background,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: _stickyHeader(),
                  ),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    _loadingState()
                  else if (snapshot.hasError)
                    _errorState(snapshot.error)
                  else
                    SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 16),
                        _heroCard(rooms),
                        const SizedBox(height: 24),
                        _sectionTitle('Fitur'),
                        const SizedBox(height: 12),
                        _featurePanel(),
                        const SizedBox(height: 24),
                        _sectionTitle('Ruang Terbaik & Rekomendasi'),
                        const SizedBox(height: 12),
                        _recommendationList(recommendedRooms),
                        const SizedBox(height: 24),
                        _sectionTitle('Feedback Pengguna'),
                        const SizedBox(height: 12),
                        _feedbackSection(),
                        const SizedBox(height: 28),
                      ]),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
