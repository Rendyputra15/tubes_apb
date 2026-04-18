import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tubes_apb/models/room_model.dart';
import 'package:tubes_apb/widgets/app_header.dart';
import 'booking_success_page.dart';

class BookingPage extends StatefulWidget {
  final Room room;

  const BookingPage({
    super.key,
    required this.room,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  bool isKtpUploaded = false;
  String? ktpFileName;

  @override
  void dispose() {
    whatsappController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  Future<void> pickKtpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        isKtpUploaded = true;
        ktpFileName = result.files.first.name;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File terpilih: $ktpFileName'),
        ),
      );
    }
  }

  void handleBooking() {
    if (whatsappController.text.trim().isEmpty ||
        purposeController.text.trim().isEmpty ||
        !isKtpUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data wajib diisi termasuk upload KTP.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSuccessPage(
          roomName: widget.room.name,
          capacity: widget.room.capacity,
          scheduleInfo: widget.room.time,
          whatsapp: whatsappController.text.trim(),
          purpose: purposeController.text.trim(),
          ktpFileName: ktpFileName ?? '-',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(
                title: 'Booking',
                subtitle: 'Lengkapi data peminjaman ruangan',
                icon: Icons.book_online_rounded,
                showBackButton: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFF1E88E5),
                            child: Icon(
                              Icons.meeting_room,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.room.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('Kapasitas: ${widget.room.capacity} orang'),
                                const SizedBox(height: 4),
                                Text(widget.room.time),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Nomor WhatsApp',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: whatsappController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nomor WhatsApp aktif',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Keperluan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: purposeController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Diskusi kelompok / rapat tugas besar',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Upload KTP',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            isKtpUploaded
                                ? Icons.check_circle
                                : Icons.upload_file,
                            size: 42,
                            color: isKtpUploaded ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isKtpUploaded
                                ? 'File KTP berhasil dipilih'
                                : 'Pilih file foto KTP dari penyimpanan',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (ktpFileName != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              ktpFileName!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          OutlinedButton(
                            onPressed: pickKtpFile,
                            child: const Text('Upload File KTP'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: handleBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Konfirmasi Booking',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}