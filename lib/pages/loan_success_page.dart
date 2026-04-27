import 'package:flutter/material.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'loan_history_page.dart';

class LoanSuccessPage extends StatelessWidget {
  final LoanRecord loan;

  const LoanSuccessPage({
    super.key,
    required this.loan,
  });

  Widget detailItem({
    required IconData icon,
    required String title,
    required String value,
    Color color = const Color(0xFFE51C23),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Peminjaman Berhasil!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Peminjaman ruangan telah diajukan.\nNotifikasi akan dikirim melalui aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            detailItem(
              icon: Icons.tag,
              title: 'Kode Pinjam',
              value: loan.code,
            ),
            detailItem(
              icon: Icons.meeting_room,
              title: 'Ruangan',
              value: loan.roomName,
            ),
            detailItem(
              icon: Icons.calendar_month,
              title: 'Tanggal',
              value: loan.dateText,
            ),
            detailItem(
              icon: Icons.access_time,
              title: 'Waktu',
              value: loan.timeText,
            ),
            detailItem(
              icon: Icons.groups,
              title: 'Jumlah Peserta',
              value: '${loan.participantCount} orang',
            ),
            detailItem(
              icon: Icons.description,
              title: 'Keperluan',
              value: loan.purpose,
            ),
            detailItem(
              icon: Icons.badge,
              title: 'KTM',
              value: loan.studentCardFile,
            ),
            detailItem(
              icon: Icons.pending_actions,
              title: 'Status',
              value: loan.status,
              color: Colors.orange,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoanHistoryPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE51C23)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Lihat Riwayat',
                        style: TextStyle(
                          color: Color(0xFFE51C23),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE51C23),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Ke Beranda',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}