import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_apb/models/app_notification_model.dart';
import 'package:tubes_apb/models/availability_model.dart';
import 'package:tubes_apb/models/loan_record_model.dart';
import 'package:tubes_apb/models/room_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiException({required this.message, this.statusCode, this.errors});

  @override
  String toString() => message;
}
// 192.168.18.167  
class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String baseUrl = 'http://127.0.0.1:8080/api';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  static const String _userKey = 'auth_user';

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<Map<String, dynamic>?> getSavedUser() async {
    final userJson = await _storage.read(key: _userKey);

    if (userJson == null || userJson.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(userJson);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }

  Future<Map<String, String>> _headers({
    bool requiresAuthentication = true,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (requiresAuthentication) {
      final token = await getToken();

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<Map<String, String>> _multipartHeaders() async {
    final headers = <String, String>{'Accept': 'application/json'};

    final token = await getToken();

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: await _headers(requiresAuthentication: false),
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        final token = body['token'];
        final user = body['user'];

        if (token is! String || token.isEmpty) {
          throw const ApiException(message: 'Token login tidak ditemukan.');
        }

        await _storage.write(key: _tokenKey, value: token);

        if (user is Map<String, dynamic>) {
          await _storage.write(key: _userKey, value: jsonEncode(user));
        } else if (user is Map) {
          await _storage.write(
            key: _userKey,
            value: jsonEncode(Map<String, dynamic>.from(user)),
          );
        }

        return body;
      }

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
        errors: _getValidationErrors(body),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(message: 'Tidak dapat terhubung ke server.');
    }
  }

  Future<List<Room>> getRooms({int? floor}) async {
    try {
      final queryParameters = <String, String>{};

      if (floor != null) {
        queryParameters['floor'] = floor.toString();
      }

      final uri = Uri.parse('$baseUrl/rooms').replace(
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );

      final response = await http
          .get(uri, headers: await _headers())
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        final data = body['data'];

        if (data is! List) {
          return [];
        }

        return data
            .whereType<Map>()
            .map((item) => Room.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(message: 'Tidak dapat mengambil data ruangan.');
    }
  }

  Future<AvailabilityResponse> getAvailability(DateTime date) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/availability',
      ).replace(queryParameters: {'date': _formatDate(date)});

      final response = await http
          .get(uri, headers: await _headers())
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        return AvailabilityResponse.fromJson(body);
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Tidak dapat mengambil jadwal ruangan.',
      );
    }
  }

  Future<List<AvailableSlot>> getAvailableSlots({
    required int roomId,
    required DateTime date,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/rooms/$roomId/available-slots',
      ).replace(queryParameters: {'date': _formatDate(date)});

      final response = await http
          .get(uri, headers: await _headers())
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        final rawData =
            body['available_slots'] ?? body['data'] ?? body['slots'];

        if (rawData is! List) {
          return [];
        }

        return rawData.map((item) {
          if (item is Map<String, dynamic>) {
            return AvailableSlot.fromJson(item);
          }

          if (item is Map) {
            return AvailableSlot.fromJson(Map<String, dynamic>.from(item));
          }

          return AvailableSlot.fromText(item.toString());
        }).toList();
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(message: 'Tidak dapat mengambil slot waktu.');
    }
  }

  Future<Map<String, dynamic>> createBooking({
    required int roomId,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required int participantCount,
    required String purpose,
    String? note,
    Uint8List? studentCardBytes,
    String? studentCardFileName,
  }) async {
    if (studentCardBytes != null &&
        studentCardFileName != null &&
        studentCardFileName.isNotEmpty) {
      return _createBookingWithFile(
        roomId: roomId,
        bookingDate: bookingDate,
        startTime: startTime,
        endTime: endTime,
        participantCount: participantCount,
        purpose: purpose,
        note: note,
        studentCardBytes: studentCardBytes,
        studentCardFileName: studentCardFileName,
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/bookings'),
            headers: await _headers(),
            body: jsonEncode({
              'room_id': roomId,
              'booking_date': _formatDate(bookingDate),
              'start_time': startTime,
              'end_time': endTime,
              'participant_count': participantCount,
              'purpose': purpose,
              'note': note?.trim().isEmpty == true ? null : note?.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
        errors: _getValidationErrors(body),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(message: 'Tidak dapat mengirim pengajuan.');
    }
  }

  Future<Map<String, dynamic>> _createBookingWithFile({
    required int roomId,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required int participantCount,
    required String purpose,
    String? note,
    required Uint8List studentCardBytes,
    required String studentCardFileName,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/bookings'),
      );

      request.headers.addAll(await _multipartHeaders());

      request.fields['room_id'] = roomId.toString();
      request.fields['booking_date'] = _formatDate(bookingDate);
      request.fields['start_time'] = startTime;
      request.fields['end_time'] = endTime;
      request.fields['participant_count'] = participantCount.toString();
      request.fields['purpose'] = purpose;

      if (note != null && note.trim().isNotEmpty) {
        request.fields['note'] = note.trim();
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'student_card_file',
          studentCardBytes,
          filename: studentCardFileName,
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 20),
      );

      final responseBody = await streamedResponse.stream.bytesToString();

      final body = _decodeResponse(responseBody);

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        return body;
      }

      await _handleUnauthorized(streamedResponse.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: streamedResponse.statusCode,
        errors: _getValidationErrors(body),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Tidak dapat mengirim pengajuan beserta file KTM.',
      );
    }
  }

  Future<List<LoanRecord>> getBookings() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bookings'), headers: await _headers())
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        dynamic rawData = body['data'] ?? body['bookings'];

        if (rawData is Map) {
          rawData = rawData['data'] ?? rawData['bookings'];
        }

        if (rawData is! List) {
          return [];
        }

        return rawData
            .whereType<Map>()
            .map((item) => LoanRecord.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Tidak dapat mengambil riwayat peminjaman.',
      );
    }
  }

  Future<List<AppNotificationModel>> getNotifications() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/notifications'), headers: await _headers())
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        dynamic rawData = body['data'] ?? body['notifications'];

        if (rawData is Map) {
          rawData = rawData['data'] ?? rawData['notifications'];
        }

        if (rawData is! List) {
          return [];
        }

        return rawData
            .whereType<Map>()
            .map(
              (item) => AppNotificationModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(message: 'Tidak dapat mengambil notifikasi.');
    }
  }

  Future<AppNotificationModel> markNotificationAsRead(
    int notificationId,
  ) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/notifications/$notificationId/read'),
            headers: await _headers(),
          )
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        final data = body['data'];

        if (data is Map<String, dynamic>) {
          return AppNotificationModel.fromJson(data);
        }

        if (data is Map) {
          return AppNotificationModel.fromJson(Map<String, dynamic>.from(data));
        }

        throw const ApiException(message: 'Data notifikasi tidak valid.');
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Tidak dapat menandai notifikasi sebagai dibaca.',
      );
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/profile'), headers: await _headers())
          .timeout(const Duration(seconds: 15));

      final body = _decodeResponse(response.body);

      if (response.statusCode == 200) {
        final data = body['data'] ?? body['user'];

        if (data is Map<String, dynamic>) {
          return data;
        }

        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }

        return body;
      }

      await _handleUnauthorized(response.statusCode);

      throw ApiException(
        message: _getErrorMessage(body),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(message: 'Tidak dapat mengambil profil.');
    }
  }

  Future<void> logout() async {
    try {
      final token = await getToken();

      if (token != null && token.isNotEmpty) {
        await http
            .post(Uri.parse('$baseUrl/logout'), headers: await _headers())
            .timeout(const Duration(seconds: 15));
      }
    } catch (_) {
      // Token lokal tetap dihapus.
    } finally {
      await clearSession();
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);

    await _storage.delete(key: _userKey);
  }

  Future<void> _handleUnauthorized(int statusCode) async {
    if (statusCode == 401) {
      await clearSession();

      throw const ApiException(
        message: 'Sesi login telah berakhir. Silakan login kembali.',
        statusCode: 401,
      );
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Map<String, dynamic> _decodeResponse(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }

      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{'message': 'Response server tidak valid.'};
    }
  }

  String _getErrorMessage(Map<String, dynamic> body) {
    final message = body['message'];

    if (message is String && message.isNotEmpty) {
      return message;
    }

    final errors = _getValidationErrors(body);

    if (errors != null && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }

      return firstError.toString();
    }

    return 'Terjadi kesalahan saat memproses permintaan.';
  }

  Map<String, dynamic>? _getValidationErrors(Map<String, dynamic> body) {
    final errors = body['errors'];

    if (errors is Map<String, dynamic>) {
      return errors;
    }

    if (errors is Map) {
      return Map<String, dynamic>.from(errors);
    }

    return null;
  }
}
