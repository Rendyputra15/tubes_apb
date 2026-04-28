import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tubes_apb/data/app_state.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'loan_success_page.dart';

class BorrowFormPage extends StatefulWidget {
  final Room room;

  const BorrowFormPage({
    super.key,
    required this.room,
  });

  @override
  State<BorrowFormPage> createState() => _BorrowFormPageState();
}

class _BorrowFormPageState extends State<BorrowFormPage> {
  late Room selectedRoom;

  DateTime? selectedDate;
  String? selectedSchedule;

  final participantController = TextEditingController();
  final purposeController = TextEditingController();
  final noteController = TextEditingController();

  String? ktmFileName;

  List<Room> get availableRooms =>
      RoomData.allRooms.where((room) => room.status == 'Tersedia').toList();

  DateTime get minBorrowDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  @override
  void initState() {
    super.initState();

    selectedRoom = widget.room.status == 'Tersedia'
        ? widget.room
        : availableRooms.first;
  }

  @override
  void dispose() {
    participantController.dispose();
    purposeController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  String getDayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return '-';
    }
  }

  List<String> getAvailableSchedulesForSelectedDate() {
    if (selectedDate == null) return [];

    final dayName = getDayName(selectedDate!);

    return selectedRoom.availableSchedules[dayName] ?? [];
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: minBorrowDate,
      firstDate: minBorrowDate,
      lastDate: minBorrowDate.add(const Duration(days: 60)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        final schedules = getAvailableSchedulesForDate(picked);
        selectedSchedule = schedules.isNotEmpty ? schedules.first : null;
      });
    }
  }

  List<String> getAvailableSchedulesForDate(DateTime date) {
    final dayName = getDayName(date);
    return selectedRoom.availableSchedules[dayName] ?? [];
  }

  Future<void> pickKtm() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        ktmFileName = result.files.first.name;
      });
    }
  }

  void submitLoan() {
    if (selectedDate == null ||
        selectedSchedule == null ||
        participantController.text.trim().isEmpty ||
        purposeController.text.trim().isEmpty ||
        ktmFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi ruangan, tanggal, waktu, jumlah peserta, keperluan, dan KTM.',
          ),
        ),
      );
      return;
    }

    final participant = int.tryParse(participantController.text.trim()) ?? 0;

    if (participant <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah peserta harus lebih dari 0.'),
        ),
      );
      return;
    }

    if (participant > selectedRoom.capacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Jumlah peserta tidak boleh melebihi kapasitas ${selectedRoom.capacity} orang.',
          ),
        ),
      );
      return;
    }

    final loan = LoanRecord(
      code: '#PNJ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      roomName: selectedRoom.name,
      dateText: formatDate(selectedDate!),
      timeText: selectedSchedule!,
      participantCount: participant,
      purpose: purposeController.text.trim(),
      studentCardFile: ktmFileName ?? '-',
      status: 'Menunggu',
    );

    AppState.addLoan(loan);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoanSuccessPage(loan: loan),
      ),
    );
  }

  Widget inputBox({
    required String title,
    required Widget child,
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(
            helper,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 18),
      ],
    );
  }

  Widget roomPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF2D38),
            Color(0xFFE51C23),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              selectedRoom.imageUrl,
              width: 74,
              height: 74,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 74,
                  height: 74,
                  color: Colors.grey[300],
                  child: const Icon(Icons.meeting_room),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedRoom.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedRoom.location,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kapasitas ${selectedRoom.capacity} orang',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduleChoice(String schedule) {
    final selected = selectedSchedule == schedule;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSchedule = schedule;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE51C23) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFE51C23) : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          schedule,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget uploadKtmBox() {
    return InkWell(
      onTap: pickKtm,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(
              ktmFileName == null
                  ? Icons.cloud_upload_outlined
                  : Icons.check_circle,
              size: 42,
              color: ktmFileName == null ? Colors.grey : Colors.green,
            ),
            const SizedBox(height: 10),
            Text(
              ktmFileName ?? 'Upload KTM',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'File berupa gambar JPG/PNG',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scheduleSection() {
    final schedules = getAvailableSchedulesForSelectedDate();

    if (selectedDate == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Pilih tanggal terlebih dahulu untuk melihat waktu yang tersedia.',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (schedules.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE8EA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Tidak ada waktu kosong untuk hari ${getDayName(selectedDate!)}. Silakan pilih tanggal lain.',
          style: const TextStyle(
            color: Color(0xFFE51C23),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Wrap(
      children: schedules.map((schedule) => scheduleChoice(schedule)).toList(),
    );
  }

  Widget summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EA),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Peminjaman',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text('Ruangan: ${selectedRoom.name}'),
          Text(
            'Tanggal: ${selectedDate == null ? '-' : formatDate(selectedDate!)}',
          ),
          Text(
            'Hari: ${selectedDate == null ? '-' : getDayName(selectedDate!)}',
          ),
          Text('Waktu: ${selectedSchedule ?? '-'}'),
          Text(
            'Peserta: ${participantController.text.isEmpty ? '-' : participantController.text} orang',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tomorrow = minBorrowDate;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Form Peminjaman',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            roomPreviewCard(),
            const SizedBox(height: 24),
            inputBox(
              title: 'Pilih Ruangan',
              helper: 'Hanya ruangan dengan status tersedia yang dapat dipilih.',
              child: DropdownButtonFormField<Room>(
                value: selectedRoom,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: availableRooms.map((room) {
                  return DropdownMenuItem(
                    value: room,
                    child: Text(room.name),
                  );
                }).toList(),
                onChanged: (room) {
                  if (room == null) return;

                  setState(() {
                    selectedRoom = room;
                    selectedDate = null;
                    selectedSchedule = null;
                  });
                },
              ),
            ),
            inputBox(
              title: 'Tanggal Pinjam',
              helper:
                  'Peminjaman minimal satu hari setelah hari ini. Tanggal paling cepat: ${formatDate(tomorrow)}',
              child: InkWell(
                onTap: pickDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? 'Pilih tanggal'
                              : '${formatDate(selectedDate!)} (${getDayName(selectedDate!)})',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.calendar_month_rounded),
                    ],
                  ),
                ),
              ),
            ),
            inputBox(
              title: 'Pilih Waktu Tersedia',
              helper:
                  'Waktu tersedia menyesuaikan jadwal akademik ruangan pada hari yang dipilih.',
              child: scheduleSection(),
            ),
            inputBox(
              title: 'Jumlah Peserta',
              helper: 'Maksimal ${selectedRoom.capacity} orang.',
              child: TextField(
                controller: participantController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Masukkan jumlah peserta',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            inputBox(
              title: 'Keperluan',
              child: TextField(
                controller: purposeController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Contoh: Diskusi kelompok, rapat, presentasi, dll',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            inputBox(
              title: 'Upload KTM',
              child: uploadKtmBox(),
            ),
            inputBox(
              title: 'Catatan Tambahan (Opsional)',
              child: TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Contoh: Membutuhkan proyektor tambahan, dll',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active_outlined, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Notifikasi status peminjaman akan dikirim melalui aplikasi.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            summaryCard(),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: submitLoan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE51C23),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Konfirmasi Peminjaman',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}