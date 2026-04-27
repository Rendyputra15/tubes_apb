import 'package:flutter/material.dart';
import 'package:tubes_apb/data/app_state.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({super.key});

  @override
  State<LoanHistoryPage> createState() => _LoanHistoryPageState();
}

class _LoanHistoryPageState extends State<LoanHistoryPage> {
  String selectedTab = 'Semua';

  Color statusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Dikonfirmasi':
        return Colors.green;
      case 'Selesai':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<LoanRecord> get filteredLoans {
    final all = AppState.loanHistory;
    if (selectedTab == 'Semua') return all;
    return all.where((loan) => loan.status == selectedTab).toList();
  }

  Widget tabChip(String text) {
    final selected = selectedTab == text;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: selected,
        selectedColor: const Color(0xFFFFE3E3),
        onSelected: (_) {
          setState(() {
            selectedTab = text;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loans = filteredLoans;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Riwayat Pinjaman',
              subtitle: 'Catatan seluruh peminjaman ruangan',
              icon: Icons.history_rounded,
              showBackButton: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  tabChip('Semua'),
                  tabChip('Menunggu'),
                  tabChip('Dikonfirmasi'),
                  tabChip('Selesai'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: loans.length,
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  final color = statusColor(loan.status);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: color.withOpacity(0.12),
                          child: Icon(Icons.assignment_turned_in, color: color),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loan.roomName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                loan.dateText,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${loan.timeText} hari • ${loan.participantCount} orang',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            loan.status,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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