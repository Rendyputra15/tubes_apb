import 'package:flutter/material.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/widgets/room_card.dart';
import 'borrow_form_page.dart';
import 'identity_verification_page.dart';
import 'loan_history_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'room_detail_page.dart';
import 'rooms_page.dart';
import 'schedule_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryRed = Color(0xFFE51C23);
  static const Color softRed = Color(0xFFFFE8EA);
  static const Color background = Color(0xFFF8F9FB);

  @override
  Widget build(BuildContext context) {
    final List<Room> recommendedRooms = RoomData.allRooms
        .where((room) => room.status == 'Tersedia')
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: background,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: _buildStickyHeader(context),
            ),

            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 16),
                  _buildHeroCard(),
                  const SizedBox(height: 24),

                  _sectionTitle('Fitur'),
                  const SizedBox(height: 12),
                  _buildFeaturePanel(context),

                  const SizedBox(height: 24),
                  _sectionTitleWithAction(
                    title: 'Ruang Terbaik & Rekomendasi',
                    action: 'Lihat semua >',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RoomsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildRecommendationList(context, recommendedRooms),

                  const SizedBox(height: 22),
                  _buildStatusCard(context),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
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
          RichText(
            text: const TextSpan(
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
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
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

  Widget _buildHeroCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 18),
    height: 230,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      gradient: const LinearGradient(
        colors: [
          Color(0xFFFF3B45),
          Color(0xFFE51C23),
          Color(0xFFD90416),
        ],
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
                border: Border.all(
                  color: Colors.white.withOpacity(0.20),
                ),
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
                    'Hai, Dewa 👋',
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

                Row(
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
                          color: Color(0xFFE51C23),
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
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
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

  Widget _sectionTitleWithAction({
    required String title,
    required String action,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Text(
              action,
              style: const TextStyle(
                color: primaryRed,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePanel(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _featureItem(
            icon: Icons.meeting_room_rounded,
            title: 'Ruangan',
            color: primaryRed,
            bgColor: const Color(0xFFFFE5E7),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RoomsPage()),
              );
            },
          ),
          _featureItem(
            icon: Icons.calendar_month_rounded,
            title: 'Jadwal',
            color: Colors.orange,
            bgColor: const Color(0xFFFFF0DA),
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
            bgColor: const Color(0xFFE7F2FF),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoanHistoryPage()),
              );
            },
          ),
          _featureItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notifikasi',
            color: Colors.purple,
            bgColor: const Color(0xFFF4E8FF),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
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
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationList(BuildContext context, List<Room> rooms) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 18, right: 8),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return _recommendationCard(context, rooms[index]);
        },
      ),
    );
  }

  Widget _recommendationCard(BuildContext context, Room room) {
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
            MaterialPageRoute(
              builder: (_) => RoomDetailPage(room: room),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Image.network(
                room.imageUrl,
                height: 112,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 112,
                    color: Colors.grey[300],
                    child: const Icon(Icons.meeting_room),
                  );
                },
              ),
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
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 17,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Tersedia',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: softRed,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Akun & Peminjaman',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Verifikasi akun untuk mempercepat proses peminjaman ruangan.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IdentityVerificationPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF113B70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: const Text(
                      'Verifikasi Akun',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: primaryRed,
              size: 42,
            ),
          ),
        ],
      ),
    );
  }
}