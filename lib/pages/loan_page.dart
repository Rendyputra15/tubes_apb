import 'package:flutter/material.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/pages/borrow_form_page.dart';
import 'package:tubes_apb/pages/loan_history_page.dart';
import 'package:tubes_apb/services/api_service.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color titleRed = Color(0xFFE51C23);

  late Future<_LoanPageData> pageFuture;

  @override
  void initState() {
    super.initState();

    pageFuture = _loadPageData();
  }

  Future<_LoanPageData> _loadPageData() async {
    final results = await Future.wait<dynamic>([
      ApiService.instance.getBookings(),
      ApiService.instance.getRooms(),
    ]);

    final bookings = results[0] as List<LoanRecord>;
    final rooms = results[1] as List<Room>;

    return _LoanPageData(bookings: bookings, rooms: rooms);
  }

  Future<void> _refreshPage() async {
    final newFuture = _loadPageData();

    setState(() {
      pageFuture = newFuture;
    });

    await newFuture;
  }

  void _retryLoad() {
    setState(() {
      pageFuture = _loadPageData();
    });
  }

  Room? _getFirstAvailableRoom(List<Room> rooms) {
    for (final room in rooms) {
      final status = room.status.toLowerCase();

      if (status == 'tersedia' || status == 'available' || room.isActive) {
        return room;
      }
    }

    if (rooms.isNotEmpty) {
      return rooms.first;
    }

    return null;
  }

  Future<void> _openBorrowForm(List<Room> rooms) async {
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

    await _refreshPage();
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
      case 'pending':
        return Colors.orange;

      case 'dikonfirmasi':
      case 'approved':
      case 'confirmed':
        return Colors.green;

      case 'selesai':
      case 'completed':
        return Colors.blue;

      case 'ditolak':
      case 'rejected':
        return Colors.red;

      case 'dibatalkan':
      case 'cancelled':
      case 'canceled':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
      case 'pending':
        return Icons.hourglass_top_rounded;

      case 'dikonfirmasi':
      case 'approved':
      case 'confirmed':
        return Icons.check_circle_rounded;

      case 'selesai':
      case 'completed':
        return Icons.task_alt_rounded;

      case 'ditolak':
      case 'rejected':
        return Icons.cancel_rounded;

      default:
        return Icons.info_rounded;
    }
  }

  Widget _heroCard(List<Room> rooms) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFF44336)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.20),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mulai pinjam ruangan dengan cepat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pilih ruangan yang tersedia lalu lengkapi form peminjaman.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                _openBorrowForm(rooms);
              },
              icon: const Icon(Icons.add_rounded, color: titleRed),
              label: const Text(
                'Mulai Peminjaman',
                style: TextStyle(color: titleRed, fontWeight: FontWeight.w900),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: titleRed,
                side: const BorderSide(color: Colors.white, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanFlowCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alur Peminjaman',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StepItem(number: '1', text: 'Pilih Ruangan'),
              ),
              Expanded(
                child: _StepItem(number: '2', text: 'Isi Form'),
              ),
              Expanded(
                child: _StepItem(number: '3', text: 'Konfirmasi'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _latestLoanCard(LoanRecord latestLoan) {
    final statusColor = _statusColor(latestLoan.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peminjaman Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_statusIcon(latestLoan.status), color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      latestLoan.roomName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latestLoan.code,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  latestLoan.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _loanInformation(
            icon: Icons.calendar_month_rounded,
            label: 'Tanggal',
            value: latestLoan.dateText,
          ),
          const SizedBox(height: 12),
          _loanInformation(
            icon: Icons.access_time_rounded,
            label: 'Waktu',
            value: latestLoan.timeText,
          ),
          const SizedBox(height: 12),
          _loanInformation(
            icon: Icons.description_rounded,
            label: 'Keperluan',
            value: latestLoan.purpose,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoanHistoryPage()),
                );
              },
              icon: const Icon(Icons.history_rounded, color: titleRed),
              label: const Text(
                'Lihat Riwayat Peminjaman',
                style: TextStyle(color: titleRed, fontWeight: FontWeight.w900),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: titleRed,
                side: const BorderSide(color: titleRed, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanInformation({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: titleRed, size: 20),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyLoanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 55,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada peminjaman',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'Peminjaman terbaru akan ditampilkan di bagian ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator(color: primaryRed));
  }

  Widget _errorState(Object? error) {
    final message = error is ApiException
        ? error.message
        : 'Data peminjaman gagal dimuat.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 14),
            const Text(
              'Gagal memuat data',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Pinjam',
              subtitle: 'Kelola proses peminjaman ruangan',
              icon: Icons.assignment_outlined,
            ),
            Expanded(
              child: FutureBuilder<_LoanPageData>(
                future: pageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _loadingState();
                  }

                  if (snapshot.hasError) {
                    return _errorState(snapshot.error);
                  }

                  final data =
                      snapshot.data ??
                      const _LoanPageData(bookings: [], rooms: []);

                  final latestLoan = data.bookings.isNotEmpty
                      ? data.bookings.first
                      : null;

                  return RefreshIndicator(
                    color: primaryRed,
                    onRefresh: _refreshPage,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        _heroCard(data.rooms),
                        const SizedBox(height: 18),
                        _loanFlowCard(),
                        const SizedBox(height: 18),
                        if (latestLoan != null)
                          _latestLoanCard(latestLoan)
                        else
                          _emptyLoanCard(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanPageData {
  final List<LoanRecord> bookings;
  final List<Room> rooms;

  const _LoanPageData({required this.bookings, required this.rooms});
}

class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFFFE3E3),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFFD32F2F),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
