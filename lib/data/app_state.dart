import 'package:tubes_apb/models/app_notification_model.dart';
import 'package:tubes_apb/models/loan_record_model.dart';

class AppState {
  static final List<LoanRecord> loanHistory = [
    LoanRecord(
      code: '#PNJ2405001',
      roomName: 'Kelas 1.02',
      dateText: '27-5-2026',
      timeText: '07.00 - 09.00',
      participantCount: 25,
      purpose: 'Diskusi kelompok dan presentasi tugas akhir.',
      studentCardFile: 'KTM_1202230049.png',
      status: 'Menunggu',
    ),
  ];

  static final List<AppNotificationModel> notifications = [
    AppNotificationModel(
      title: 'Peminjaman Menunggu Konfirmasi',
      subtitle: 'Peminjaman Kelas 1.02 sedang menunggu persetujuan admin.',
      time: 'Hari ini',
      type: 'warning',
    ),
  ];

  static void addLoan(LoanRecord loan) {
    loanHistory.insert(0, loan);

    notifications.insert(
      0,
      AppNotificationModel(
        title: 'Peminjaman Baru Diajukan',
        subtitle: '${loan.roomName} sedang menunggu konfirmasi admin.',
        time: 'Baru saja',
        type: 'warning',
      ),
    );
  }
}