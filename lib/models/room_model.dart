class Room {
  final int id;
  final String code;

  final String name;
  final int capacity;
  final int floor;

  final String status;
  final String time;
  final String location;
  final String imageUrl;
  final List<String> facilities;
  final String description;

  final bool isActive;

  // Jadwal tersedia berdasarkan hari.
  final Map<String, List<String>> availableSchedules;

  const Room({
    required this.id,
    required this.code,
    required this.name,
    required this.capacity,
    required this.floor, 
    required this.status,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.facilities,
    required this.description,
    required this.isActive,
    required this.availableSchedules,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    final floor = _toInt(json['floor']);

    return Room(
      id: _toInt(json['id']),
      code: json['code']?.toString() ?? '-',
      name: json['name']?.toString() ?? 'Ruangan',
      capacity: _toInt(json['capacity']),
      floor: floor,

      status: json['status']?.toString() ?? 'Tersedia',
      time: json['time']?.toString() ?? '-',

      location:
          json['location']?.toString() ??
          'Gedung Kuliah Lantai $floor',

      imageUrl:
          json['image_url']?.toString() ??
          json['imageUrl']?.toString() ??
          '',

      facilities: _parseFacilities(
        json['facilities'],
      ),

      description:
          json['description']?.toString() ??
          'Ruangan akademik untuk kegiatan pembelajaran.',

      isActive: _toBool(
        json['is_active'] ?? true,
      ),

      availableSchedules:
          _parseAvailableSchedules(
        json['available_schedules'] ??
            json['availableSchedules'],
      ),
    );
  }

  Room copyWith({
    int? id,
    String? code,
    String? name,
    int? capacity,
    int? floor,
    String? status,
    String? time,
    String? location,
    String? imageUrl,
    List<String>? facilities,
    String? description,
    bool? isActive,
    Map<String, List<String>>?
        availableSchedules,
  }) {
    return Room(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      floor: floor ?? this.floor,
      status: status ?? this.status,
      time: time ?? this.time,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      facilities:
          facilities ?? this.facilities,
      description:
          description ?? this.description,
      isActive: isActive ?? this.isActive,
      availableSchedules:
          availableSchedules ??
          this.availableSchedules,
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
        text == '1' ||
        text == 'active';
  }

  static List<String> _parseFacilities(
    dynamic value,
  ) {
    if (value is List) {
      return value
          .map(
            (item) => item.toString(),
          )
          .toList();
    }

    return [];
  }

  static Map<String, List<String>>
      _parseAvailableSchedules(
    dynamic value,
  ) {
    if (value is! Map) {
      return {};
    }

    final result =
        <String, List<String>>{};

    value.forEach((key, schedules) {
      if (schedules is List) {
        result[key.toString()] =
            schedules
                .map(
                  (item) =>
                      item.toString(),
                )
                .toList();
      }
    });

    return result;
  }
}