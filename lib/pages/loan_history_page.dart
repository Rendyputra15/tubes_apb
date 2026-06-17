import 'package:flutter/material.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'package:tubes_apb/services/api_service.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class LoanHistoryPage
    extends StatefulWidget {
  const LoanHistoryPage({
    super.key,
  });

  @override
  State<LoanHistoryPage> createState() =>
      _LoanHistoryPageState();
}

class _LoanHistoryPageState
    extends State<LoanHistoryPage> {
  static const Color primaryRed =
      Color(0xFFD32F2F);

  static const Color titleRed =
      Color(0xFFE51C23);

  static const Color softRed =
      Color(0xFFFFE3E3);

  String selectedTab = 'Semua';

  late Future<List<LoanRecord>>
      bookingsFuture;

  final List<String> tabs = const [
    'Semua',
    'Menunggu',
    'Dikonfirmasi',
    'Ditolak',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();

    bookingsFuture =
        ApiService.instance.getBookings();
  }

  Future<void> _refreshBookings() async {
    final newFuture =
        ApiService.instance.getBookings();

    setState(() {
      bookingsFuture = newFuture;
    });

    await newFuture;
  }

  void _retryLoad() {
    setState(() {
      bookingsFuture =
          ApiService.instance.getBookings();
    });
  }

  List<LoanRecord> _filterBookings(
    List<LoanRecord> bookings,
  ) {
    if (selectedTab == 'Semua') {
      return bookings;
    }

    return bookings
        .where(
          (booking) =>
              booking.status ==
              selectedTab,
        )
        .toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;

      case 'Dikonfirmasi':
        return Colors.green;

      case 'Ditolak':
        return primaryRed;

      case 'Selesai':
        return Colors.blue;

      case 'Dibatalkan':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Menunggu':
        return Icons.hourglass_top_rounded;

      case 'Dikonfirmasi':
        return Icons.check_circle_rounded;

      case 'Ditolak':
        return Icons.cancel_rounded;

      case 'Selesai':
        return Icons.task_alt_rounded;

      case 'Dibatalkan':
        return Icons.block_rounded;

      default:
        return Icons.info_rounded;
    }
  }

  String _statusDescription(
    String status,
  ) {
    switch (status) {
      case 'Menunggu':
        return 'Pengajuan masih menunggu verifikasi dari admin.';

      case 'Dikonfirmasi':
        return 'Pengajuan sudah disetujui. Gunakan ruangan sesuai jadwal.';

      case 'Ditolak':
        return 'Pengajuan peminjaman ditolak oleh admin.';

      case 'Selesai':
        return 'Peminjaman ruangan sudah selesai.';

      case 'Dibatalkan':
        return 'Pengajuan peminjaman telah dibatalkan.';

      default:
        return 'Status peminjaman belum tersedia.';
    }
  }

  Widget _tabChip(String text) {
    final selected =
        selectedTab == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = text;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),
        margin: const EdgeInsets.only(
          right: 9,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              selected ? titleRed : Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? titleRed
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.04,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(
    List<LoanRecord> bookings,
  ) {
    final total = bookings.length;

    final waiting = bookings
        .where(
          (item) =>
              item.status == 'Menunggu',
        )
        .length;

    final approved = bookings
        .where(
          (item) =>
              item.status ==
              'Dikonfirmasi',
        )
        .length;

    final done = bookings
        .where(
          (item) =>
              item.status == 'Selesai',
        )
        .length;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        6,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD32F2F),
            Color(0xFFF44336),
          ],
        ),
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(
              0.22,
            ),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.18,
              ),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: Colors.white,
              size: 31,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Peminjaman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$total total • $waiting menunggu • $approved dikonfirmasi • $done selesai',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingCard(
    LoanRecord booking,
  ) {
    final color =
        _statusColor(booking.status);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showBookingDetail(booking);
        },
        borderRadius:
            BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(
                        0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: Icon(
                      _statusIcon(
                        booking.status,
                      ),
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          booking.roomName,
                          style:
                              const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          booking.code,
                          style: TextStyle(
                            color:
                                Colors.grey[600],
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(
                        0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _smallInfo(
                      icon: Icons
                          .calendar_month_rounded,
                      label: 'Tanggal',
                      value:
                          booking.dateText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _smallInfo(
                      icon: Icons
                          .access_time_rounded,
                      label: 'Waktu',
                      value:
                          booking.timeText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _smallInfo(
                icon:
                    Icons.description_rounded,
                label: 'Keperluan',
                value: booking.purpose,
              ),
              const SizedBox(height: 12),
              Align(
                alignment:
                    Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    _showBookingDetail(
                      booking,
                    );
                  },
                  icon: const Icon(
                    Icons
                        .visibility_outlined,
                    size: 18,
                  ),
                  label:
                      const Text('Lihat Detail'),
                  style: TextButton.styleFrom(
                    foregroundColor: titleRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: titleRed,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color:
                  color.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color:
                        Colors.grey[600],
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetail(
    LoanRecord booking,
  ) {
    final color =
        _statusColor(booking.status);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          builder: (
            context,
            scrollController,
          ) {
            return Container(
              decoration:
                  const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: ListView(
                controller:
                    scrollController,
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  28,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.grey[300],
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),
                    decoration: BoxDecoration(
                      color:
                          color.withOpacity(
                        0.10,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _statusIcon(
                            booking.status,
                          ),
                          color: color,
                          size: 54,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Detail Peminjaman',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          booking.roomName,
                          style: TextStyle(
                            color:
                                Colors.grey[700],
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration:
                              BoxDecoration(
                            color: color
                                .withOpacity(
                              0.15,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                          ),
                          child: Text(
                            booking.status,
                            style: TextStyle(
                              color: color,
                              fontWeight:
                                  FontWeight
                                      .w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding:
                        const EdgeInsets.all(
                      15,
                    ),
                    decoration: BoxDecoration(
                      color: softRed,
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Text(
                      _statusDescription(
                        booking.status,
                      ),
                      style: const TextStyle(
                        height: 1.5,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _detailRow(
                    icon: Icons
                        .confirmation_number_rounded,
                    label:
                        'Kode Peminjaman',
                    value: booking.code,
                    color: titleRed,
                  ),
                  _detailRow(
                    icon: Icons
                        .meeting_room_rounded,
                    label: 'Ruangan',
                    value:
                        booking.roomName,
                    color:
                        Colors.deepPurple,
                  ),
                  _detailRow(
                    icon: Icons
                        .calendar_month_rounded,
                    label: 'Tanggal',
                    value:
                        booking.dateText,
                    color: Colors.blue,
                  ),
                  _detailRow(
                    icon: Icons
                        .access_time_rounded,
                    label: 'Waktu',
                    value:
                        booking.timeText,
                    color: Colors.orange,
                  ),
                  _detailRow(
                    icon:
                        Icons.groups_rounded,
                    label:
                        'Jumlah Peserta',
                    value:
                        '${booking.participantCount} orang',
                    color: Colors.green,
                  ),
                  _detailRow(
                    icon: Icons
                        .description_rounded,
                    label: 'Keperluan',
                    value:
                        booking.purpose,
                    color: titleRed,
                  ),
                  if (booking
                      .note.isNotEmpty)
                    _detailRow(
                      icon:
                          Icons.notes_rounded,
                      label: 'Catatan',
                      value:
                          booking.note,
                      color: Colors.teal,
                    ),
                  if (booking
                      .rejectionReason
                      .isNotEmpty)
                    _detailRow(
                      icon: Icons
                          .report_problem_rounded,
                      label:
                          'Alasan Penolakan',
                      value: booking
                          .rejectionReason,
                      color: primaryRed,
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            titleRed,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _loadingState() {
    return const Center(
      child:
          CircularProgressIndicator(
        color: primaryRed,
      ),
    );
  }

  Widget _errorState(Object? error) {
    final message =
        error is ApiException
            ? error.message
            : 'Terjadi kesalahan saat mengambil riwayat.';

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(28),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 14),
            const Text(
              'Gagal memuat riwayat',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _retryLoad,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
                  const Text('Coba Lagi'),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryRed,
                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(28),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .history_toggle_off_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 14),
            const Text(
              'Riwayat masih kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              selectedTab == 'Semua'
                  ? 'Belum ada pengajuan peminjaman ruangan.'
                  : 'Tidak ada peminjaman dengan status $selectedTab.',
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title:
                  'Riwayat Peminjaman',
              subtitle:
                  'Lihat seluruh pengajuan peminjaman ruangan',
              icon:
                  Icons.history_rounded,
              showBackButton: true,
            ),
            Expanded(
              child: FutureBuilder<
                  List<LoanRecord>>(
                future: bookingsFuture,
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot
                          .connectionState ==
                      ConnectionState
                          .waiting) {
                    return _loadingState();
                  }

                  if (snapshot.hasError) {
                    return _errorState(
                      snapshot.error,
                    );
                  }

                  final bookings =
                      snapshot.data ?? [];

                  final filtered =
                      _filterBookings(
                    bookings,
                  );

                  return Column(
                    children: [
                      _summaryCard(
                        bookings,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 46,
                        child: ListView(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 16,
                          ),
                          scrollDirection:
                              Axis.horizontal,
                          children: tabs
                              .map(
                                _tabChip,
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Expanded(
                        child:
                            filtered.isEmpty
                                ? _emptyState()
                                : RefreshIndicator(
                                    color:
                                        primaryRed,
                                    onRefresh:
                                        _refreshBookings,
                                    child:
                                        ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding:
                                          const EdgeInsets.fromLTRB(
                                        16,
                                        0,
                                        16,
                                        20,
                                      ),
                                      itemCount:
                                          filtered.length,
                                      itemBuilder:
                                          (
                                        context,
                                        index,
                                      ) {
                                        return _bookingCard(
                                          filtered[
                                              index],
                                        );
                                      },
                                    ),
                                  ),
                      ),
                    ],
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