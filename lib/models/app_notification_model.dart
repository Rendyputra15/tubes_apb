class AppNotificationModel {
  final int id;
  final String title;
  final String subtitle;
  final String time;
  final String type;
  final bool isRead;
  final String createdAt;

  const AppNotificationModel({
    this.id = 0,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isRead = false,
    this.createdAt = '',
  });

  factory AppNotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final createdAt =
        json['created_at']?.toString() ??
        json['createdAt']?.toString() ??
        '';

    return AppNotificationModel(
      id: _toInt(json['id']),
      title:
          json['title']?.toString() ??
          'Notifikasi',
      subtitle:
          json['message']?.toString() ??
          json['subtitle']?.toString() ??
          '-',
      time: _formatTime(createdAt),
      type: _normalizeType(
        json['type']?.toString() ?? 'info',
      ),
      isRead: _toBool(
        json['is_read'] ??
            json['isRead'] ??
            false,
      ),
      createdAt: createdAt,
    );
  }

  AppNotificationModel copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? time,
    String? type,
    bool? isRead,
    String? createdAt,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
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

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final text =
        value?.toString().toLowerCase();

    return text == 'true' ||
        text == '1';
  }

  static String _normalizeType(
    String type,
  ) {
    switch (type.toLowerCase()) {
      case 'success':
      case 'approved':
      case 'completed':
      case 'confirmed':
        return 'success';

      case 'warning':
      case 'pending':
      case 'waiting':
        return 'warning';

      case 'error':
      case 'danger':
      case 'rejected':
      case 'declined':
        return 'error';

      case 'info':
      default:
        return 'info';
    }
  }

  static String _formatTime(
    String value,
  ) {
    if (value.isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    final localDate = date.toLocal();
    final now = DateTime.now();

    final difference =
        now.difference(localDate);

    if (difference.isNegative) {
      return _formatFullDate(localDate);
    }

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    }

    if (difference.inDays == 1) {
      return 'Kemarin';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    }

    return _formatFullDate(localDate);
  }

  static String _formatFullDate(
    DateTime date,
  ) {
    final day = date.day
        .toString()
        .padLeft(2, '0');

    final month = date.month
        .toString()
        .padLeft(2, '0');

    final hour = date.hour
        .toString()
        .padLeft(2, '0');

    final minute = date.minute
        .toString()
        .padLeft(2, '0');

    return '$day-$month-${date.year} $hour:$minute';
  }
}