import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _baseUrl = 'http://10.64.81.44:8080/api';

  // ============================================================
  // EXISTING METHODS (Jangan dihapus, ini sudah ada)
  // ============================================================

  Future<Map<String, dynamic>> registerHrd(
      String email, String password) async {
    final url = Uri.parse('$_baseUrl/hrd/register');
    print('AuthRepository.registerHrd -> POST $url');
    print('Payload: {"email": "$email", "password": "***"}');

    try {
      final response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'data': responseBody};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Registration failed',
          'errors': responseBody['errors']
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> loginGoogle(String idToken) async {
    final url = Uri.parse('$_baseUrl/hrd/google-login');
    print('AuthRepository.loginGoogle -> POST $url');

    try {
      final response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'id_token': idToken,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': responseBody};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Authentication failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> loginHrd(String email, String password) async {
    final url = Uri.parse('$_baseUrl/hrd/login');
    print('AuthRepository.loginHrd -> POST $url');
    print('Payload: {"email": "$email", "password": "***"}');

    try {
      final response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseBody};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Login gagal'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // ============================================================
  // 🔥 NEW METHODS: Token Management
  // ============================================================

  /// Simpan token setelah login berhasil
  Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString('hrd_token', token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  /// Ambil token dari storage
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('hrd_token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Hapus token (untuk logout)
  Future<bool> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove('hrd_token');
    } catch (e) {
      print('Error clearing token: $e');
      return false;
    }
  }

  /// Cek apakah user sudah login
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Simpan data user (opsional, jika mau simpan email, name, dll)
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('hrd_email', userData['email'] ?? '');
      await prefs.setString('hrd_name', userData['name'] ?? '');
      await prefs.setInt('hrd_company_id', userData['company_id'] ?? 0);
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  /// Ambil data user
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'email': prefs.getString('hrd_email'),
        'name': prefs.getString('hrd_name'),
        'company_id': prefs.getInt('hrd_company_id'),
      };
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Ambil profile HRD (user + company) dari API
  Future<Map<String, dynamic>> getHrdProfile() async {
    final url = Uri.parse('$_baseUrl/hrd/profile');
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': body['data']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat profile'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /// Update atau create company profile untuk HRD
  Future<Map<String, dynamic>> updateHrdProfile(
      Map<String, dynamic> payload) async {
    final url = Uri.parse('$_baseUrl/hrd/profile');
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': body['data']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal menyimpan profile'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /// Logout (hapus semua data)
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('hrd_token');
      await prefs.remove('hrd_email');
      await prefs.remove('hrd_name');
      await prefs.remove('hrd_company_id');
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }
}
