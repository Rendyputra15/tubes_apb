import 'package:flutter/material.dart';
import 'package:tubes_apb/models/availability_model.dart';
import 'package:tubes_apb/services/api_service.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() =>
      _SchedulePageState();
}

class _SchedulePageState
    extends State<SchedulePage> {
  static const Color primaryRed =
      Color(0xFFD32F2F);

  static const Color titleRed =
      Color(0xFFE51C23);

  static const Color softRed =
      Color(0xFFFFE3E3);

  String selectedFloor = 'Semua';

  DateTime selectedDate = DateTime.now();

  late Future<AvailabilityResponse>
      availabilityFuture;

  final List<String> floors = const [
    'Semua',
    'Lantai 1',
    'Lantai 2',
  ];

  @override
  void initState() {
    super.initState();

    availabilityFuture =
        ApiService.instance.getAvailability(
      selectedDate,
    );
  }

  Future<void> _loadAvailability() async {
    final newFuture =
        ApiService.instance.getAvailability(
      selectedDate,
    );

    setState(() {
      availabilityFuture = newFuture;
    });

    await newFuture;
  }

  void _retryLoad() {
    setState(() {
      availabilityFuture =
          ApiService.instance.getAvailability(
        selectedDate,
      );
    });
  }

  Future<void> _selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (result == null) {
      return;
    }

    setState(() {
      selectedDate = result;

      availabilityFuture =
          ApiService.instance.getAvailability(
        selectedDate,
      );
    });
  }

  List<AvailabilityRoom> _filterRooms(
    List<AvailabilityRoom> rooms,
  ) {
    switch (selectedFloor) {
      case 'Lantai 1':
        return rooms
            .where(
              (room) => room.floor == 1,
            )
            .toList();

      case 'Lantai 2':
        return rooms
            .where(
              (room) => room.floor == 2,
            )
            .toList();

      default:
        return rooms;
    }
  }

  String _formatSelectedDate() {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${selectedDate.day} '
        '${monthNames[selectedDate.month - 1]} '
        '${selectedDate.year}';
  }

  String _translateDay(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 'Senin';

      case 'tuesday':
        return 'Selasa';

      case 'wednesday':
        return 'Rabu';

      case 'thursday':
        return 'Kamis';

      case 'friday':
        return 'Jumat';

      case 'saturday':
        return 'Sabtu';

      case 'sunday':
        return 'Minggu';

      default:
        return day;
    }
  }

  Widget _floorChip(String label) {
    final active =
        selectedFloor == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFloor = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),
        margin:
            const EdgeInsets.only(right: 9),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              active ? titleRed : Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: active
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
          label,
          style: TextStyle(
            color: active
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _dateSelector() {
    return InkWell(
      onTap: _selectDate,
      borderRadius:
          BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color:
                titleRed.withOpacity(0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.045,
              ),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: softRed,
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: titleRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanggal yang dipilih',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatSelectedDate(),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit_calendar_rounded,
              color: titleRed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotCard(
    AvailableSlot slot,
    int index,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6F6),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: titleRed.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFFD32F2F),
                  Color(0xFFF44336),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.access_time_filled_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesi ${index + 1}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  slot.displayTime,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w900,
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
              color:
                  Colors.green.withOpacity(
                0.10,
              ),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Text(
              'Kosong',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomCard(
    AvailabilityRoom room,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.045,
            ),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
                child: const Icon(
                  Icons.meeting_room_rounded,
                  color: titleRed,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${room.location} • Kapasitas ${room.capacity}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
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
                  color:
                      Colors.green.withOpacity(
                    0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Text(
                  '${room.availableSlots.length} sesi',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (room.availableSlots.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                16,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Text(
                'Tidak ada waktu kosong pada tanggal ini.',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            )
          else
            Column(
              children: room.availableSlots
                  .asMap()
                  .entries
                  .map(
                    (entry) => _slotCard(
                      entry.value,
                      entry.key,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _loadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: primaryRed,
      ),
    );
  }

  Widget _errorState(Object? error) {
    final message = error is ApiException
        ? error.message
        : 'Terjadi kesalahan saat mengambil jadwal.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 14),
            const Text(
              'Gagal memuat jadwal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
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
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
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
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 14),
            const Text(
              'Tidak ada ruangan tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Tidak ada jadwal kosong untuk tanggal ${_formatSelectedDate()}.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Jadwal Ruangan',
              subtitle:
                  'Lihat ketersediaan ruangan berdasarkan tanggal',
              icon:
                  Icons.calendar_month_rounded,
              showBackButton: true,
            ),
            const SizedBox(height: 16),
            _dateSelector(),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                scrollDirection:
                    Axis.horizontal,
                children: floors
                    .map(_floorChip)
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: FutureBuilder<
                  AvailabilityResponse>(
                future: availabilityFuture,
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _loadingState();
                  }

                  if (snapshot.hasError) {
                    return _errorState(
                      snapshot.error,
                    );
                  }

                  final response =
                      snapshot.data;

                  if (response == null) {
                    return _emptyState();
                  }

                  final rooms = _filterRooms(
                    response.rooms,
                  );

                  if (rooms.isEmpty) {
                    return _emptyState();
                  }

                  final translatedDay =
                      _translateDay(
                    response.day,
                  );

                  return RefreshIndicator(
                    color: primaryRed,
                    onRefresh:
                        _loadAvailability,
                    child: ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        20,
                      ),
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),
                          padding:
                              const EdgeInsets.all(
                            13,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFFFF6F6,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: titleRed,
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              Expanded(
                                child: Text(
                                  '$translatedDay, ${_formatSelectedDate()} • ${rooms.length} ruangan',
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...rooms.map(_roomCard),
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