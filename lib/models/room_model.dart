class Room {
  final String name;
  final int capacity;
  final String status;
  final String time;
  final String location;
  final String imageUrl;
  final List<String> facilities;
  final String description;

  // Jadwal tersedia berdasarkan hari
  final Map<String, List<String>> availableSchedules;

  Room({
    required this.name,
    required this.capacity,
    required this.status,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.facilities,
    required this.description,
    required this.availableSchedules,
  });
}