import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_app/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryJobSeeker {
  // ============================================================
  // REGISTER
  // ============================================================
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/jobseeker/register');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      print('Register Error: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // ============================================================
  // LOGIN (EMAIL & PASSWORD)
  // ============================================================
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/jobseeker/login');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🔥 SIMPAN TOKEN dengan safe access
        final dataObj = data['data'] as Map<String, dynamic>?;
        if (dataObj != null) {
          final token = dataObj['token'] as String?;
          if (token != null && token.isNotEmpty) {
            await saveToken(token);
            // Simpan user data
            await saveUserData({
              'user_id': dataObj['user_id'],
              'email': dataObj['email'],
              'role': dataObj['role'],
            });
          }
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('Login Error: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // ============================================================
  // LOGIN GOOGLE
  // ============================================================
  Future<Map<String, dynamic>> loginGoogle(String idToken) async {
    final url =
        Uri.parse('${ApiConstants.tBaseUrl}/api/jobseeker/google-login');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'id_token': idToken,
            }),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🔥 SIMPAN TOKEN dengan safe access
        final dataObj = data['data'] as Map<String, dynamic>?;
        if (dataObj != null) {
          final token = dataObj['token'] as String?;
          if (token != null && token.isNotEmpty) {
            await saveToken(token);
            // Simpan user data
            await saveUserData({
              'user_id': dataObj['user_id'],
              'email': dataObj['email'],
              'role': dataObj['role'],
            });
          }
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login Google berhasil',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login Google gagal',
        };
      }
    } catch (e) {
      print('Google Login Error: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // ============================================================
  // TOKEN MANAGEMENT
  // ============================================================

  /// Simpan token ke SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jobseeker_token', token);
  }

  /// Ambil token dari SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jobseeker_token');
  }

  /// Hapus token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jobseeker_token');
  }

  /// Cek apakah user sudah login
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ============================================================
  // USER DATA MANAGEMENT
  // ============================================================

  /// Simpan user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jobseeker_user_id', userData['user_id'].toString());
    await prefs.setString('jobseeker_email', userData['email'] ?? '');
    await prefs.setString('jobseeker_role', userData['role'] ?? '');
  }

  /// Ambil user data
  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getString('jobseeker_user_id'),
      'email': prefs.getString('jobseeker_email'),
      'role': prefs.getString('jobseeker_role'),
    };
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jobseeker_token');
    await prefs.remove('jobseeker_user_id');
    await prefs.remove('jobseeker_email');
    await prefs.remove('jobseeker_role');
  }
}
