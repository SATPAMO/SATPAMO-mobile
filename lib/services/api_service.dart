import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mahasiswa.dart';
import '../models/attendance_result.dart';

class ApiService {
  static const String _envUrl = String.fromEnvironment('API_BASE_URL');

  /// IP Wi-Fi laptop (adapter "Wi-Fi 2"). Bukan IP VMware (192.168.44.1).
  /// HP fisik di Wi-Fi yang sama memakai URL ini jika USB reverse tidak aktif.
  static const String lanUrl = 'http://10.200.22.103:3001';

  static String baseUrl = _initialBaseUrl();
  static String? _authToken;

  static String _stripSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  static String _initialBaseUrl() {
    if (_envUrl.isNotEmpty) return _stripSlash(_envUrl);
    if (kIsWeb) return 'http://127.0.0.1:3001';
    if (defaultTargetPlatform == TargetPlatform.android) {
      // HP USB: adb reverse tcp:3001 tcp:3001 → 127.0.0.1 di HP = laptop
      return 'http://127.0.0.1:3001';
    }
    return 'http://127.0.0.1:3001';
  }

  static List<String> candidateUrls() {
    final urls = <String>[];
    void add(String url) {
      final trimmed = _stripSlash(url.trim());
      if (trimmed.isEmpty || urls.contains(trimmed)) return;
      urls.add(trimmed);
    }

    add(_envUrl);
    add(baseUrl);
    add('http://127.0.0.1:3001');
    add('http://localhost:3001');
    if (defaultTargetPlatform == TargetPlatform.android) {
      add('http://10.0.2.2:3001');
    }
    add(lanUrl);
    return urls;
  }

  // ─── Auth helpers ────────────────────────────────────────────────────────────

  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('token');
    debugPrint(
      '[ApiService] Token loaded: ${_authToken != null ? 'yes' : 'no'}',
    );
  }

  static Future<void> saveToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> clearToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static bool get isLoggedIn => _authToken != null;

  // ─── Auth API ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    Object? lastError;

    for (final candidate in candidateUrls()) {
      try {
        final uri = Uri.parse('$candidate/api/auth/login');
        final response = await http
            .post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'identifier': identifier,
                'password': password,
              }),
            )
            .timeout(const Duration(seconds: 10));

        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (response.statusCode == 200 && data['success'] == true) {
          baseUrl = candidate;
          final token = data['data']?['token'] as String?;
          if (token != null) await saveToken(token);
          
          final user = data['data']?['user'] ?? data['data']?['mahasiswa'] ?? data['data'];
          if (user != null) {
            final prefs = await SharedPreferences.getInstance();
            final userId = (user['id'] ?? user['_id'] ?? '') as String;
            if (userId.isNotEmpty) {
              await prefs.setString('userId', userId);
            }
            if (user['name'] != null) {
              await prefs.setString('userName', user['name'] as String);
            }
            if (user['email'] != null) {
              await prefs.setString('userEmail', user['email'] as String);
            } else if (identifier.contains('@')) {
              await prefs.setString('userEmail', identifier);
            }
            if (user['nim'] != null) {
              await prefs.setString('userNim', user['nim'] as String);
            } else if (!identifier.contains('@')) {
              await prefs.setString('userNim', identifier);
            }
          }
          
          debugPrint('[ApiService] Login mahasiswa berhasil via $candidate');
          return {'success': true, 'data': data['data']};
        } else {
          // Return error dari server
          final message = data['message'];
          final validationMsg = data['errors'] as List?;
          return {
            'success': false,
            'message':
                message ??
                (validationMsg is List && validationMsg.isNotEmpty
                    ? validationMsg.first['msg'] as String?
                    : null) ??
                'Email/NIM atau password salah.',
          };
        }
      } catch (e) {
        lastError = e;
        debugPrint('[ApiService] Login gagal di $candidate: $e');
      }
    }

    return {
      'success': false,
      'message': 'Tidak dapat terhubung ke server.\n${lastError ?? ''}',
    };
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    if (_authToken == null) {
      return {'success': false, 'message': 'Belum login.'};
    }
    try {
      final uri = Uri.parse('$baseUrl/api/auth/me');
      final response = await http
          .get(uri, headers: _defaultHeaders)
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } catch (e) {
      debugPrint('[ApiService] getCurrentUser error: $e');
      return {'success': false, 'message': 'Gagal mengambil data user.'};
    }
  }

  // ─── Mahasiswa API ───────────────────────────────────────────────────────────

  /// Ambil daftar mahasiswa dengan auto-fallback jika URL pertama gagal
  static Future<List<Mahasiswa>> getPublicMahasiswas() async {
    Object? lastError;

    for (final candidate in candidateUrls()) {
      try {
        debugPrint('[ApiService] Mencoba koneksi ke $candidate ...');
        final res = await _fetchFromUrl(candidate);
        if (res != null) {
          baseUrl = candidate;
          debugPrint('[ApiService] Berhasil terhubung ke: $baseUrl');
          return res;
        }
        debugPrint('[ApiService] $candidate merespons tapi data tidak valid');
      } catch (e) {
        lastError = e;
        debugPrint('[ApiService] Gagal di $candidate: $e');
      }
    }

    throw Exception(
      'Tidak dapat terhubung ke backend di port 3001.\n'
      'HP USB: jalankan  adb reverse tcp:3001 tcp:3001\n'
      'HP Wi-Fi: set URL ke $lanUrl\n'
      '${lastError ?? ''}',
    );
  }

  static Future<List<Mahasiswa>?> _fetchFromUrl(String url) async {
    final uri = Uri.parse('$url/api/mahasiswa/public');
    final response = await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((item) => Mahasiswa.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return null;
  }

  // ─── Attendance API ──────────────────────────────────────────────────────────

  /// Submit presensi selfie + GPS ke backend
  static Future<AttendanceResult> submitCheckIn({
    required String mahasiswaId,
    required String photoBase64,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    final uri = Uri.parse('$baseUrl/api/attendance/check-in');
    try {
      final formattedPhoto = photoBase64.startsWith('data:')
          ? photoBase64
          : 'data:image/jpeg;base64,$photoBase64';

      final body = jsonEncode({
        'mahasiswaId': mahasiswaId,
        'photo': formattedPhoto,
        'latitude': latitude,
        'longitude': longitude,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });

      final response = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendanceResult.fromJson(data);
      } else {
        final errorMsg = data['message'] ?? 'Gagal memproses presensi.';
        throw Exception(errorMsg);
      }
    } catch (e) {
      debugPrint('[ApiService] submitCheckIn error: $e');
      rethrow;
    }
  }
}
