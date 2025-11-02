import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  // Ganti dengan IP 10.0.2.2 kalo gunain Android Emulator
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; 

  // Register dengan Email dan Password (Memanggil /hrd/register)
  Future<Map<String, dynamic>> registerHrd(String email, String password) async {
    final url = Uri.parse('$_baseUrl/hrd/register');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    

    // Mengembalikan respons untuk diproses oleh Controller
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'data': responseBody};
    } else {
      return {'success': false, 'message': responseBody['message'] ?? 'Registration failed', 'errors': responseBody['errors']};
    }
  }

  // Login dengan Google Token (Memanggil /hrd/google-login)
  Future<Map<String, dynamic>> loginGoogle(String idToken) async {
    final url = Uri.parse('$_baseUrl/hrd/google-login'); 

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_token': idToken, 
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': responseBody};
    } else {
      return {'success': false, 'message': responseBody['message'] ?? 'Authentication failed'};
    }
  }
    Future<Map<String, dynamic>> loginHrd(String email, String password) async {
    final url = Uri.parse('$_baseUrl/hrd/login'); // <-- Endpoint Login

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': responseBody};
    } else {
      // 401 Unauthorized atau 422 Validasi
      return {'success': false, 'message': responseBody['message'] ?? 'Login gagal'};
    }
  }
}