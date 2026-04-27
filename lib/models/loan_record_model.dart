class LoanRecord {
  final String code;
  final String roomName;
  final String dateText;
  final String timeText;
  final int participantCount;
  final String purpose;
  final String studentCardFile;
  final String status;

  LoanRecord({
    required this.code,
    required this.roomName,
    required this.dateText,
    required this.timeText,
    required this.participantCount,
    required this.purpose,
    required this.studentCardFile,
    required this.status,
  });
}