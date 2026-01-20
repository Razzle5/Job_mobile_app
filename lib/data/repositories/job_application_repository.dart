import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_app/constants/api_constants.dart';
import 'package:job_app/data/repositories/auth_repository_jobseeker.dart';

class JobApplicationRepository {
  final AuthRepositoryJobSeeker _authRepo = AuthRepositoryJobSeeker();

  Future<void> applyJob(int jobId) async {
    final token = await _authRepo.getToken();
    final response = await http.post(
      Uri.parse('${ApiConstants.tBaseUrl}/api/job-seeker/apply/$jobId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message'] ??
          'Gagal melamar pekerjaan');
    }
  }
}
