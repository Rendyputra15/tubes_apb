import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tubes_apb/data/app_state.dart';
import 'package:tubes_apb/data/room_data.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/widgets/app_header.dart';
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
  DateTime? selectedDate;
  Room? selectedRoom;
  String? selectedSchedule;

  final participantController = TextEditingController();
  final purposeController = TextEditingController();
  final noteController = TextEditingController();

  String? ktmFileName;

  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color titleRed = Color(0xFFE51C23);
  static const Color softRed = Color(0xFFFFE3E3);

  DateTime get minBorrowDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
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

  List<Room> getAvailableRoomsForSelectedDate() {
    if (selectedDate == null) return [];

    final dayName = getDayName(selectedDate!);

    return RoomData.allRooms.where((room) {
      final schedules = room.availableSchedules[dayName] ?? [];
      return schedules.isNotEmpty;
    }).toList();
  }

  List<String> getAvailableSchedulesForSelectedRoom() {
    if (selectedDate == null || selectedRoom == null) return [];

    final dayName = getDayName(selectedDate!);
    return selectedRoom!.availableSchedules[dayName] ?? [];
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: minBorrowDate,
      firstDate: minBorrowDate,
      lastDate: minBorrowDate.add(const Duration(days: 60)),
    );

    if (picked != null) {
      final rooms = RoomData.allRooms.where((room) {
        final schedules = room.availableSchedules[getDayName(picked)] ?? [];
        return schedules.isNotEmpty;
      }).toList();

      setState(() {
        selectedDate = picked;

        if (rooms.contains(widget.room)) {
          selectedRoom = widget.room;
        } else {
          selectedRoom = null;
        }

        final schedules = selectedRoom == null
            ? <String>[]
            : selectedRoom!.availableSchedules[getDayName(picked)] ?? [];

        selectedSchedule = schedules.isNotEmpty ? schedules.first : null;
      });
    }
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
        selectedRoom == null ||
        selectedSchedule == null ||
        participantController.text.trim().isEmpty ||
        purposeController.text.trim().isEmpty ||
        ktmFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi tanggal, ruangan, waktu, jumlah peserta, keperluan, dan KTM.',
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

    if (participant > selectedRoom!.capacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Jumlah peserta tidak boleh melebihi kapasitas ${selectedRoom!.capacity} orang.',
          ),
        ),
      );
      return;
    }

    final loan = LoanRecord(
      code:
          '#PNJ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      roomName: selectedRoom!.name,
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
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: 18),
      ],
    );
  }

  Widget stepIndicator() {
    final bool dateDone = selectedDate != null;
    final bool roomDone = selectedRoom != null;
    final bool timeDone = selectedSchedule != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          stepItem(
            number: '1',
            title: 'Tanggal',
            active: dateDone,
          ),
          stepLine(dateDone && roomDone),
          stepItem(
            number: '2',
            title: 'Ruangan',
            active: roomDone,
          ),
          stepLine(roomDone && timeDone),
          stepItem(
            number: '3',
            title: 'Waktu',
            active: timeDone,
          ),
        ],
      ),
    );
  }

  Widget stepItem({
    required String number,
    required String title,
    required bool active,
  }) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: active ? titleRed : softRed,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: active
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    number,
                    style: const TextStyle(
                      color: titleRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: active ? titleRed : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget stepLine(bool active) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: active ? titleRed : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget datePickerBox() {
    return InkWell(
      onTap: pickDate,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                selectedDate == null ? Colors.grey.shade200 : titleRed,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: softRed,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: titleRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate == null
                    ? 'Pilih tanggal peminjaman'
                    : '${formatDate(selectedDate!)} • ${getDayName(selectedDate!)}',
                style: TextStyle(
                  color: selectedDate == null ? Colors.grey[600] : Colors.black87,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: titleRed,
            ),
          ],
        ),
      ),
    );
  }

  Widget roomDropdownBox() {
    final rooms = getAvailableRoomsForSelectedDate();

    if (selectedDate == null) {
      return disabledInfoBox(
        icon: Icons.meeting_room_rounded,
        text: 'Pilih tanggal terlebih dahulu untuk melihat ruangan yang kosong.',
      );
    }

    if (rooms.isEmpty) {
      return disabledInfoBox(
        icon: Icons.event_busy_rounded,
        text:
            'Tidak ada ruangan kosong pada hari ${getDayName(selectedDate!)}. Silakan pilih tanggal lain.',
        isWarning: true,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selectedRoom == null ? Colors.grey.shade200 : titleRed,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Room>(
          value: selectedRoom,
          isExpanded: true,
          borderRadius: BorderRadius.circular(18),
          hint: const Text(
            'Pilih ruangan kosong',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: titleRed,
          ),
          onChanged: (room) {
            if (room == null) return;

            final schedules =
                room.availableSchedules[getDayName(selectedDate!)] ?? [];

            setState(() {
              selectedRoom = room;
              selectedSchedule = schedules.isNotEmpty ? schedules.first : null;
            });
          },
          items: rooms.map((room) {
            final schedules =
                room.availableSchedules[getDayName(selectedDate!)] ?? [];

            return DropdownMenuItem<Room>(
              value: room,
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: softRed,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.meeting_room_rounded,
                      color: titleRed,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      room.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '${schedules.length} sesi',
                    style: const TextStyle(
                      color: titleRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget scheduleSection() {
    final schedules = getAvailableSchedulesForSelectedRoom();

    if (selectedDate == null) {
      return disabledInfoBox(
        icon: Icons.access_time_filled_rounded,
        text: 'Pilih tanggal terlebih dahulu.',
      );
    }

    if (selectedRoom == null) {
      return disabledInfoBox(
        icon: Icons.access_time_filled_rounded,
        text: 'Pilih ruangan terlebih dahulu untuk melihat waktu kosong.',
      );
    }

    if (schedules.isEmpty) {
      return disabledInfoBox(
        icon: Icons.event_busy_rounded,
        text: 'Tidak ada waktu kosong untuk ruangan ini.',
        isWarning: true,
      );
    }

    return Column(
      children: schedules.map((schedule) => scheduleChoice(schedule)).toList(),
    );
  }

  Widget scheduleChoice(String schedule) {
    final selected = selectedSchedule == schedule;
    final parts = schedule.split(' - ');
    final start = parts.isNotEmpty ? parts[0] : schedule;
    final end = parts.length > 1 ? parts[1] : '';

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSchedule = schedule;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected ? titleRed : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? titleRed : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected ? Colors.white.withOpacity(0.18) : softRed,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.access_time_filled_rounded,
                color: selected ? Colors.white : titleRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Text(
                    start,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (end.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: selected ? Colors.white : titleRed,
                      ),
                    ),
                    Text(
                      end,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget disabledInfoBox({
    required IconData icon,
    required String text,
    bool isWarning = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFFFE8EA) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isWarning ? titleRed.withOpacity(0.2) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isWarning ? titleRed : Colors.grey[500],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isWarning ? titleRed : Colors.grey[700],
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectedRoomPreviewCard() {
    if (selectedRoom == null) {
      return const SizedBox();
    }

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
        boxShadow: [
          BoxShadow(
            color: titleRed.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              selectedRoom!.imageUrl,
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
                  selectedRoom!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedRoom!.location,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kapasitas ${selectedRoom!.capacity} orang',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
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
          Text(
            'Tanggal: ${selectedDate == null ? '-' : formatDate(selectedDate!)}',
          ),
          Text(
            'Hari: ${selectedDate == null ? '-' : getDayName(selectedDate!)}',
          ),
          Text('Ruangan: ${selectedRoom?.name ?? '-'}'),
          Text('Waktu: ${selectedSchedule ?? '-'}'),
          Text(
            'Peserta: ${participantController.text.isEmpty ? '-' : participantController.text} orang',
          ),
        ],
      ),
    );
  }

  Widget textInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: titleRed, width: 1.3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = getAvailableRoomsForSelectedDate();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Form Peminjaman',
              subtitle: 'Pilih tanggal, ruangan, lalu waktu kosong',
              icon: Icons.assignment_rounded,
              showBackButton: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  stepIndicator(),
                  const SizedBox(height: 18),

                  inputBox(
                    title: '1. Pilih Tanggal Peminjaman',
                    helper:
                        'Tanggal dipilih terlebih dahulu agar sistem dapat menampilkan ruangan yang kosong pada hari tersebut.',
                    child: datePickerBox(),
                  ),

                  inputBox(
                    title: '2. Pilih Ruangan Kosong',
                    helper: selectedDate == null
                        ? null
                        : 'Tersedia ${rooms.length} ruangan kosong pada hari ${getDayName(selectedDate!)}.',
                    child: roomDropdownBox(),
                  ),

                  if (selectedRoom != null) ...[
                    selectedRoomPreviewCard(),
                    const SizedBox(height: 18),
                  ],

                  inputBox(
                    title: '3. Pilih Waktu Kosong',
                    child: scheduleSection(),
                  ),

                  inputBox(
                    title: 'Jumlah Peserta',
                    child: textInput(
                      controller: participantController,
                      hint: 'Masukkan jumlah peserta',
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  inputBox(
                    title: 'Keperluan Peminjaman',
                    child: textInput(
                      controller: purposeController,
                      hint: 'Contoh: Diskusi kelompok dan presentasi tugas',
                      maxLines: 3,
                    ),
                  ),

                  inputBox(
                    title: 'Catatan Tambahan',
                    helper: 'Opsional',
                    child: textInput(
                      controller: noteController,
                      hint: 'Tambahkan catatan jika diperlukan',
                      maxLines: 3,
                    ),
                  ),

                  inputBox(
                    title: 'Upload KTM',
                    helper: 'Digunakan sebagai bukti identitas mahasiswa.',
                    child: uploadKtmBox(),
                  ),

                  summaryCard(),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: submitLoan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: titleRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Ajukan Peminjaman',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}