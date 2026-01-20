import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_app/data/models/application_model.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';

class HrdRepository {
  static const String _baseUrl = 'http://192.168.18.12:8080/api';
  final AuthRepository _authRepo = AuthRepository();

  /// Ambil semua lamaran untuk HRD Activity
  Future<List<ApplicationModel>> fetchApplications() async {
    final token = await _authRepo.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token HRD tidak ditemukan, silakan login ulang');
    }

    final url = Uri.parse('$_baseUrl/hrd/applications');
    print('HrdRepository.fetchApplications -> GET $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => ApplicationModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat aplikasi: ${response.body}');
    }
  }
}
