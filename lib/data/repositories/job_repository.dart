import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/constants/api_constants.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart'; // 🔥 Tambahkan ini

class JobRepository {
  // ============================================================
  // JOBSEEKER METHODS (Public - No Auth Required)
  // ============================================================

  /// Get ALL jobs (untuk jobseeker)
  Future<List<JobModel>> fetchJobs() async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/jobs');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final jobListJson = body['jobs'] as List;
        return jobListJson
            .map(
                (jobJson) => JobModel.fromJson(jobJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Gagal memuat pekerjaan, Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal koneksi ke server: $e');
    }
  }

  /// Get job detail by ID (untuk jobseeker)
  Future<JobModel?> getJobDetail(int jobId) async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/jobs/$jobId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return JobModel.fromJson(body['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Gagal memuat detail pekerjaan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ============================================================
  // HRD METHODS (Protected - Auth Required)
  // ============================================================

  /// Get jobs by company (HRD hanya lihat lowongan milik company-nya)
  Future<List<JobModel>> getJobsByCompany(String token) async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/hrd/jobs');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final jobListJson = body['data'] as List;
        return jobListJson
            .map(
                (jobJson) => JobModel.fromJson(jobJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Gagal memuat lowongan company, Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Create new job (HRD)
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> jobData) async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/hrd/jobs');

    try {
      // 🔥 Ambil token dari AuthRepository
      final authRepo = AuthRepository();
      final token = await authRepo.getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(jobData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Lowongan berhasil ditambahkan',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menambahkan lowongan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  /// Update job (HRD)
  Future<Map<String, dynamic>> updateJob(
      int jobId, Map<String, dynamic> jobData) async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/hrd/jobs/$jobId');

    try {
      final authRepo = AuthRepository();
      final token = await authRepo.getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(jobData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Lowongan berhasil diupdate',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal update lowongan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  /// Delete job (HRD)
  Future<Map<String, dynamic>> deleteJob(int jobId) async {
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/hrd/jobs/$jobId');

    try {
      final authRepo = AuthRepository();
      final token = await authRepo.getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Lowongan berhasil dihapus',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus lowongan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
