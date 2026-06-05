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
    LoanRecord(
      code: '#PNJ2405002',
      roomName: 'Kelas 1.05',
      dateText: '28-5-2026',
      timeText: '10.30 - 12.00',
      participantCount: 30,
      purpose: 'Rapat koordinasi organisasi mahasiswa.',
      studentCardFile: 'KTM_1202230049.png',
      status: 'Dikonfirmasi',
    ),
    LoanRecord(
      code: '#PNJ2405003',
      roomName: 'Kelas 2.03',
      dateText: '29-5-2026',
      timeText: '13.00 - 14.30',
      participantCount: 20,
      purpose: 'Kegiatan belajar kelompok mata kuliah pemrograman mobile.',
      studentCardFile: 'KTM_1202230049.png',
      status: 'Selesai',
    ),
    LoanRecord(
      code: '#PNJ2405004',
      roomName: 'Kelas 2.09',
      dateText: '30-5-2026',
      timeText: '15.30 - 17.00',
      participantCount: 35,
      purpose: 'Latihan presentasi project akhir semester.',
      studentCardFile: 'KTM_1202230049.png',
      status: 'Dikonfirmasi',
    ),
    LoanRecord(
      code: '#PNJ2405005',
      roomName: 'Kelas 1.15',
      dateText: '31-5-2026',
      timeText: '08.30 - 10.00',
      participantCount: 18,
      purpose: 'Diskusi persiapan lomba dan pembagian tugas tim.',
      studentCardFile: 'KTM_1202230049.png',
      status: 'Selesai',
    ),
  ];

  static final List<AppNotificationModel> notifications = [
    AppNotificationModel(
      title: 'Peminjaman Menunggu Konfirmasi',
      subtitle: 'Peminjaman Kelas 1.02 sedang menunggu persetujuan admin.',
      time: 'Hari ini, 08.20',
      type: 'warning',
    ),
    AppNotificationModel(
      title: 'Peminjaman Disetujui',
      subtitle:
          'Pengajuan Kelas 2.05 untuk kegiatan rapat divisi telah disetujui oleh admin.',
      time: 'Kemarin, 15.40',
      type: 'success',
    ),
    AppNotificationModel(
      title: 'Jadwal Hampir Dimulai',
      subtitle:
          'Peminjaman Kelas 1.15 akan dimulai dalam 30 menit. Pastikan peserta sudah siap.',
      time: 'Kemarin, 12.30',
      type: 'info',
    ),
    AppNotificationModel(
      title: 'Pengajuan Perlu Dicek',
      subtitle:
          'Admin meminta pengecekan kembali data peminjaman Kelas 2.03 sebelum diproses.',
      time: '2 hari lalu',
      type: 'warning',
    ),
    AppNotificationModel(
      title: 'Peminjaman Selesai',
      subtitle:
          'Peminjaman Kelas 1.09 telah selesai. Terima kasih sudah menggunakan Inst4Class.',
      time: '3 hari lalu',
      type: 'success',
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