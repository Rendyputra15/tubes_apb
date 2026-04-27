import 'package:flutter/material.dart';
import 'package:tubes_apb/data/app_state.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/widgets/app_header.dart';
import 'borrow_form_page.dart';
import 'loan_history_page.dart';

class LoanPage extends StatelessWidget {
  const LoanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final latestLoan =
        AppState.loanHistory.isNotEmpty ? AppState.loanHistory.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: ListView(
          children: [
            const AppHeader(
              title: 'Pinjam',
              subtitle: 'Kelola proses peminjaman ruangan',
              icon: Icons.assignment_outlined,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD32F2F),
                          Color(0xFFF44336),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
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
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BorrowFormPage(
                                    room: RoomData.allRooms.first,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFD32F2F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Mulai Peminjaman'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alur Peminjaman',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: const [
                            Expanded(child: _StepItem(number: '1', text: 'Pilih Ruangan')),
                            Expanded(child: _StepItem(number: '2', text: 'Isi Form')),
                            Expanded(child: _StepItem(number: '3', text: 'Konfirmasi')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (latestLoan != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pinjaman Terbaru',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            latestLoan.roomName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(latestLoan.dateText),
                          const SizedBox(height: 6),
                          Text('Status: ${latestLoan.status}'),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoanHistoryPage(),
                                  ),
                                );
                              },
                              child: const Text('Lihat Riwayat Pinjaman'),
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
}

class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({
    required this.number,
    required this.text,
  });

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
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}