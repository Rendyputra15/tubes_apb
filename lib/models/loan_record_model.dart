class LoanRecord {
  final int id;
  final String code;
  final int roomId;
  final String roomName;
  final String dateText;
  final String timeText;
  final String startTime;
  final String endTime;
  final int participantCount;
  final String purpose;
  final String note;
  final String studentCardFile;
  final String status;
  final String rejectionReason;
  final String createdAt;

  const LoanRecord({
    this.id = 0,
    required this.code,
    this.roomId = 0,
    required this.roomName,
    required this.dateText,
    required this.timeText,
    this.startTime = '',
    this.endTime = '',
    required this.participantCount,
    required this.purpose,
    this.note = '',
    this.studentCardFile = '-',
    required this.status,
    this.rejectionReason = '',
    this.createdAt = '',
  });

  factory LoanRecord.fromJson(
    Map<String, dynamic> json,
  ) {
    final roomData = json['room'];

    Map<String, dynamic> room = {};

    if (roomData is Map<String, dynamic>) {
      room = roomData;
    } else if (roomData is Map) {
      room = Map<String, dynamic>.from(roomData);
    }

    final startTime = _formatTime(
      json['start_time'] ?? json['startTime'],
    );

    final endTime = _formatTime(
      json['end_time'] ?? json['endTime'],
    );

    final rawStatus =
        json['status']?.toString() ?? 'pending';

    return LoanRecord(
      id: _toInt(json['id']),
      code:
          json['code']?.toString() ??
          json['booking_code']?.toString() ??
          json['bookingCode']?.toString() ??
          '#PNJ-${json['id'] ?? '-'}',
      roomId:
          _toInt(
            json['room_id'] ??
                json['roomId'] ??
                room['id'],
          ),
      roomName:
          room['name']?.toString() ??
          json['room_name']?.toString() ??
          json['roomName']?.toString() ??
          'Ruangan',
      dateText: _formatDate(
        json['booking_date'] ??
            json['bookingDate'] ??
            json['date'],
      ),
      timeText: _buildTimeText(
        startTime,
        endTime,
      ),
      startTime: startTime,
      endTime: endTime,
      participantCount: _toInt(
        json['participant_count'] ??
            json['participantCount'],
      ),
      purpose:
          json['purpose']?.toString() ??
          json['description']?.toString() ??
          '-',
      note:
          json['note']?.toString() ??
          json['notes']?.toString() ??
          '',
      studentCardFile:
          json['student_card_file']?.toString() ??
          json['studentCardFile']?.toString() ??
          '-',
      status: normalizeStatus(rawStatus),
      rejectionReason:
          json['rejection_reason']?.toString() ??
          json['rejectionReason']?.toString() ??
          '',
      createdAt:
          json['created_at']?.toString() ??
          json['createdAt']?.toString() ??
          '',
    );
  }

  static String normalizeStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'waiting':
      case 'menunggu':
        return 'Menunggu';

      case 'approved':
      case 'confirmed':
      case 'accepted':
      case 'dikonfirmasi':
      case 'disetujui':
        return 'Dikonfirmasi';

      case 'rejected':
      case 'declined':
      case 'ditolak':
        return 'Ditolak';

      case 'completed':
      case 'finished':
      case 'done':
      case 'selesai':
        return 'Selesai';

      case 'cancelled':
      case 'canceled':
      case 'dibatalkan':
        return 'Dibatalkan';

      default:
        return status;
    }
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static String _formatTime(dynamic value) {
    if (value == null) {
      return '';
    }

    final text = value.toString();

    if (text.length >= 5) {
      return text.substring(0, 5);
    }

    return text;
  }

  static String _buildTimeText(
    String start,
    String end,
  ) {
    if (start.isEmpty && end.isEmpty) {
      return '-';
    }

    if (end.isEmpty) {
      return start;
    }

    return '$start - $end';
  }

  static String _formatDate(dynamic value) {
    if (value == null) {
      return '-';
    }

    final text = value.toString();

    final date = DateTime.tryParse(text);

    if (date == null) {
      return text;
    }

    final day = date.day
        .toString()
        .padLeft(2, '0');

    final month = date.month
        .toString()
        .padLeft(2, '0');

    return '$day-$month-${date.year}';
  }
}