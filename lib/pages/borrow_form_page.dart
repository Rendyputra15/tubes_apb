import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tubes_apb/models/availability_model.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/services/api_service.dart';
import 'package:tubes_apb/widgets/app_header.dart';

import 'loan_success_page.dart';

class BorrowFormPage extends StatefulWidget {
  final Room room;

  const BorrowFormPage({super.key, required this.room});

  @override
  State<BorrowFormPage> createState() => _BorrowFormPageState();
}

class _BorrowFormPageState extends State<BorrowFormPage> {
  static const Color primaryRed = Color(0xFFD32F2F);

  static const Color titleRed = Color(0xFFE51C23);

  static const Color softRed = Color(0xFFFFE3E3);

  DateTime? selectedDate;

  AvailabilityRoom? selectedRoom;

  AvailableSlot? selectedSlot;

  PlatformFile? selectedKtmFile;

  List<AvailabilityRoom> availableRooms = [];

  bool isLoadingAvailability = false;
  bool isSubmitting = false;
  bool isPickingFile = false;

  final participantController = TextEditingController();

  final purposeController = TextEditingController();

  final noteController = TextEditingController();

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
    final day = date.day.toString().padLeft(2, '0');

    final month = date.month.toString().padLeft(2, '0');

    return '$day-$month-${date.year}';
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? minBorrowDate,
      firstDate: minBorrowDate,
      lastDate: minBorrowDate.add(const Duration(days: 60)),
      helpText: 'Pilih tanggal peminjaman',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked == null) {
      return;
    }

    setState(() {
      selectedDate = picked;
      selectedRoom = null;
      selectedSlot = null;
      availableRooms = [];
      isLoadingAvailability = true;
    });

    try {
      final response = await ApiService.instance.getAvailability(picked);

      if (!mounted) {
        return;
      }

      final rooms = response.rooms;

      AvailabilityRoom? initialRoom;

      for (final room in rooms) {
        if (room.id == widget.room.id) {
          initialRoom = room;
          break;
        }
      }

      setState(() {
        availableRooms = rooms;
        selectedRoom = initialRoom;

        if (initialRoom != null && initialRoom.availableSlots.isNotEmpty) {
          selectedSlot = initialRoom.availableSlots.first;
        }

        isLoadingAvailability = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingAvailability = false;
      });

      _showMessage(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingAvailability = false;
      });

      _showMessage('Terjadi kesalahan saat mengambil jadwal.');
    }
  }

  Future<void> pickKtmFile() async {
    if (isPickingFile) {
      return;
    }

    setState(() {
      isPickingFile = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
      );

      if (!mounted) {
        return;
      }

      if (result == null || result.files.isEmpty) {
        setState(() {
          isPickingFile = false;
        });

        return;
      }

      final file = result.files.first;

      if (file.bytes == null) {
        setState(() {
          isPickingFile = false;
        });

        _showMessage('File KTM tidak dapat dibaca.');

        return;
      }

      final fileSizeInMb = file.size / (1024 * 1024);

      if (fileSizeInMb > 2) {
        setState(() {
          isPickingFile = false;
        });

        _showMessage('Ukuran file KTM maksimal 2 MB.');

        return;
      }

      setState(() {
        selectedKtmFile = file;
        isPickingFile = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isPickingFile = false;
      });

      _showMessage('Gagal memilih file KTM.');
    }
  }

  void removeKtmFile() {
    setState(() {
      selectedKtmFile = null;
    });
  }

  Future<void> submitBooking() async {
    if (selectedDate == null) {
      _showMessage('Silakan pilih tanggal peminjaman.');
      return;
    }

    if (selectedRoom == null) {
      _showMessage('Silakan pilih ruangan.');
      return;
    }

    if (selectedSlot == null) {
      _showMessage('Silakan pilih slot waktu.');
      return;
    }

    final participant = int.tryParse(participantController.text.trim());

    if (participant == null || participant <= 0) {
      _showMessage('Jumlah peserta harus lebih dari 0.');
      return;
    }

    if (participant > selectedRoom!.capacity) {
      _showMessage('Jumlah peserta melebihi kapasitas ruangan.');
      return;
    }

    final purpose = purposeController.text.trim();

    if (purpose.isEmpty) {
      _showMessage('Keperluan peminjaman wajib diisi.');
      return;
    }

    if (selectedKtmFile == null || selectedKtmFile!.bytes == null) {
      _showMessage('Silakan upload KTM terlebih dahulu.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await ApiService.instance.createBooking(
        roomId: selectedRoom!.id,
        bookingDate: selectedDate!,
        startTime: selectedSlot!.startTime,
        endTime: selectedSlot!.endTime,
        participantCount: participant,
        purpose: purpose,
        note: noteController.text,
        studentCardBytes: selectedKtmFile!.bytes,
        studentCardFileName: selectedKtmFile!.name,
      );

      if (!mounted) {
        return;
      }

      final rawBooking = result['data'] ?? result['booking'] ?? result;

      Map<String, dynamic> booking = {};

      if (rawBooking is Map<String, dynamic>) {
        booking = rawBooking;
      } else if (rawBooking is Map) {
        booking = Map<String, dynamic>.from(rawBooking);
      }

      final bookingCode =
          booking['code']?.toString() ??
          booking['booking_code']?.toString() ??
          '#PNJ${DateTime.now().millisecondsSinceEpoch}';

      final status = booking['status']?.toString() ?? 'Menunggu';

      final studentCardFile =
          booking['student_card_file']?.toString() ??
          booking['studentCardFile']?.toString() ??
          selectedKtmFile!.name;

      final loan = LoanRecord(
        code: bookingCode,
        roomName: selectedRoom!.name,
        dateText: formatDate(selectedDate!),
        timeText: selectedSlot!.displayTime,
        participantCount: participant,
        purpose: purpose,
        studentCardFile: studentCardFile,
        status: status,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoanSuccessPage(loan: loan)),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage('Pengajuan gagal dikirim.');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon, color: titleRed),
      filled: true,
      fillColor: Colors.white,
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
        borderSide: const BorderSide(color: titleRed, width: 1.5),
      ),
    );
  }

  Widget _dateBox() {
    return InkWell(
      onTap: isLoadingAvailability ? null : pickDate,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selectedDate == null ? Colors.grey.shade200 : titleRed,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: softRed,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.calendar_month_rounded, color: titleRed),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate == null
                    ? 'Pilih tanggal peminjaman'
                    : formatDate(selectedDate!),
                style: TextStyle(
                  color: selectedDate == null
                      ? Colors.grey[600]
                      : Colors.black87,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (isLoadingAvailability)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: titleRed,
                ),
              )
            else
              const Icon(Icons.keyboard_arrow_down, color: titleRed),
          ],
        ),
      ),
    );
  }

  Widget _roomDropdown() {
    if (selectedDate == null) {
      return _disabledBox('Pilih tanggal terlebih dahulu.');
    }

    if (isLoadingAvailability) {
      return _disabledBox('Mengambil daftar ruangan...');
    }

    if (availableRooms.isEmpty) {
      return _disabledBox('Tidak ada ruangan tersedia pada tanggal tersebut.');
    }

    return DropdownButtonFormField<AvailabilityRoom>(
      value: selectedRoom,
      isExpanded: true,
      decoration: _inputDecoration(
        hint: 'Pilih ruangan',
        icon: Icons.meeting_room_rounded,
      ),
      items: availableRooms.map((room) {
        return DropdownMenuItem<AvailabilityRoom>(
          value: room,
          child: Text(
            '${room.name} • ${room.availableSlots.length} slot',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (room) {
        setState(() {
          selectedRoom = room;

          if (room != null && room.availableSlots.isNotEmpty) {
            selectedSlot = room.availableSlots.first;
          } else {
            selectedSlot = null;
          }
        });
      },
    );
  }

  Widget _slotDropdown() {
    if (selectedRoom == null) {
      return _disabledBox('Pilih ruangan terlebih dahulu.');
    }

    final slots = selectedRoom!.availableSlots;

    if (slots.isEmpty) {
      return _disabledBox('Tidak ada slot waktu tersedia.');
    }

    return DropdownButtonFormField<AvailableSlot>(
      value: selectedSlot,
      isExpanded: true,
      decoration: _inputDecoration(
        hint: 'Pilih slot waktu',
        icon: Icons.access_time_rounded,
      ),
      items: slots.map((slot) {
        return DropdownMenuItem<AvailableSlot>(
          value: slot,
          child: Text(slot.displayTime),
        );
      }).toList(),
      onChanged: (slot) {
        setState(() {
          selectedSlot = slot;
        });
      },
    );
  }

  Widget _ktmUploadBox() {
    final file = selectedKtmFile;

    return InkWell(
      onTap: isPickingFile || isSubmitting ? null : pickKtmFile,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: file == null ? Colors.grey.shade200 : titleRed,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: softRed,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.badge_rounded, color: titleRed),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: file == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upload KTM',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Format JPG, PNG, atau PDF. Maksimal 2 MB.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(file.size / 1024).toStringAsFixed(1)} KB',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),
            if (isPickingFile)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: titleRed,
                ),
              )
            else if (file != null)
              IconButton(
                onPressed: removeKtmFile,
                icon: const Icon(Icons.close_rounded, color: Colors.red),
              )
            else
              const Icon(Icons.upload_file_rounded, color: titleRed),
          ],
        ),
      ),
    );
  }

  Widget _disabledBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: titleRed.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Peminjaman',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(height: 10),
          _summaryRow(
            'Tanggal',
            selectedDate == null ? '-' : formatDate(selectedDate!),
          ),
          _summaryRow('Ruangan', selectedRoom?.name ?? '-'),
          _summaryRow('Waktu', selectedSlot?.displayTime ?? '-'),
          _summaryRow('KTM', selectedKtmFile?.name ?? '-'),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
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
        child: Column(
          children: [
            const AppHeader(
              title: 'Form Peminjaman',
              subtitle: 'Lengkapi data peminjaman ruangan',
              icon: Icons.edit_calendar_rounded,
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Tanggal Peminjaman'),
                    _dateBox(),
                    const SizedBox(height: 18),
                    _sectionTitle('Ruangan'),
                    _roomDropdown(),
                    const SizedBox(height: 18),
                    _sectionTitle('Waktu'),
                    _slotDropdown(),
                    const SizedBox(height: 18),
                    _sectionTitle('Jumlah Peserta'),
                    TextField(
                      controller: participantController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        hint: 'Masukkan jumlah peserta',
                        icon: Icons.people_outline,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle('Keperluan'),
                    TextField(
                      controller: purposeController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        hint: 'Contoh: diskusi kelompok',
                        icon: Icons.description_outlined,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle('Upload KTM'),
                    _ktmUploadBox(),
                    const SizedBox(height: 18),
                    _sectionTitle('Catatan Tambahan'),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        hint: 'Opsional',
                        icon: Icons.notes_rounded,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _summaryCard(),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: primaryRed.withOpacity(0.55),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Kirim Pengajuan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
