class AvailabilityRoom {
  final int id;
  final String code;
  final String name;
  final int floor;
  final int capacity;
  final String location;
  final List<AvailableSlot> availableSlots;

  const AvailabilityRoom({
    required this.id,
    required this.code,
    required this.name,
    required this.floor,
    required this.capacity,
    required this.location,
    required this.availableSlots,
  });

  factory AvailabilityRoom.fromJson(
    Map<String, dynamic> json,
  ) {
    final floor = _toInt(json['floor']);

    return AvailabilityRoom(
      id: _toInt(json['id']),
      code: json['code']?.toString() ?? '-',
      name: json['name']?.toString() ?? 'Ruangan',
      floor: floor,
      capacity: _toInt(json['capacity']),
      location:
          json['location']?.toString() ??
          'Gedung Kuliah Lantai $floor',
      availableSlots: _parseSlots(
        json['available_slots'] ??
            json['availableSlots'],
      ),
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

  static List<AvailableSlot> _parseSlots(
    dynamic value,
  ) {
    if (value is! List) {
      return [];
    }

    return value.map((item) {
      if (item is Map<String, dynamic>) {
        return AvailableSlot.fromJson(item);
      }

      if (item is Map) {
        return AvailableSlot.fromJson(
          Map<String, dynamic>.from(item),
        );
      }

      return AvailableSlot.fromText(
        item.toString(),
      );
    }).toList();
  }
}

class AvailableSlot {
  final String startTime;
  final String endTime;

  const AvailableSlot({
    required this.startTime,
    required this.endTime,
  });

  factory AvailableSlot.fromJson(
    Map<String, dynamic> json,
  ) {
    return AvailableSlot(
      startTime: _formatTime(
        json['start_time'] ??
            json['startTime'],
      ),
      endTime: _formatTime(
        json['end_time'] ??
            json['endTime'],
      ),
    );
  }

  factory AvailableSlot.fromText(
    String text,
  ) {
    final normalized = text.replaceAll(
      '.',
      ':',
    );

    final parts = normalized.split(' - ');

    return AvailableSlot(
      startTime:
          parts.isNotEmpty ? parts.first : normalized,
      endTime:
          parts.length > 1 ? parts[1] : '',
    );
  }

  String get displayTime {
    if (endTime.isEmpty) {
      return startTime;
    }

    return '$startTime - $endTime';
  }

  static String _formatTime(dynamic value) {
    if (value == null) {
      return '-';
    }

    final text = value.toString();

    if (text.length >= 5) {
      return text.substring(0, 5);
    }

    return text;
  }
}

class AvailabilityResponse {
  final String date;
  final String day;
  final List<AvailabilityRoom> rooms;

  const AvailabilityResponse({
    required this.date,
    required this.day,
    required this.rooms,
  });

  factory AvailabilityResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    final rooms = <AvailabilityRoom>[];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          rooms.add(
            AvailabilityRoom.fromJson(item),
          );
        } else if (item is Map) {
          rooms.add(
            AvailabilityRoom.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return AvailabilityResponse(
      date: json['date']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      rooms: rooms,
    );
  }
}