import 'dart:convert';
import 'dart:async';
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

    print(' fetchJobs() -> GET $url');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 20));

      print(' fetchJobs response: ${response.statusCode}');
      print(
          ' Response body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');

      //  CHECK IF RESPONSE IS HTML (error page)
      if (response.body.contains('<!DOCTYPE') ||
          response.body.contains('<html')) {
        print(' ERROR: Backend returned HTML instead of JSON!');
        print(' Full response body:\n${response.body}');
        return [];
      }

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          print('📦 Response body decoded: $body');

          // 🔥 Handle both "jobs" and "data" keys from different API responses
          final jobListJson = (body['jobs'] ?? body['data']) as List? ?? [];
          print('📋 Jobs count: ${jobListJson.length}');

          if (jobListJson.isEmpty) {
            print('⚠️ No jobs returned from API');
            return [];
          }

          final jobs = <JobModel>[];
          for (int i = 0; i < jobListJson.length; i++) {
            try {
              final jobJson = jobListJson[i] as Map<String, dynamic>;
              print('🔍 Parsing job $i: $jobJson');
              final job = JobModel.fromJson(jobJson);
              jobs.add(job);
              print('✅ Job $i parsed successfully: ${job.title}');
            } catch (e) {
              print('❌ Error parsing job $i: $e');
              print('   Job data: ${jobListJson[i]}');
            }
          }

          print('📦 Total jobs successfully parsed: ${jobs.length}');
          return jobs;
        } catch (e) {
          // Jika parsing gagal, log dan kembalikan list kosong
          print('❌ Error parsing jobs response: $e');
          print('📄 Response body: ${response.body}');
          return [];
        }
      } else {
        // Log error tapi jangan throw - return empty list
        print('❌ fetchJobs non-200 status: ${response.statusCode}');
        print('📄 Response body:\n${response.body}');
        return [];
      }
    } on TimeoutException catch (e) {
      print('⏱️ fetchJobs TIMEOUT after 20s: $e');
      return [];
    } catch (e) {
      // Network error atau timeout - log dan return empty list
      print('❌ fetchJobs exception: $e');
      return [];
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
        try {
          final body = jsonDecode(response.body);
          final jobListJson =
              (body['data'] is List) ? body['data'] as List : [];
          return jobListJson
              .map((jobJson) =>
                  JobModel.fromJson(jobJson as Map<String, dynamic>))
              .toList();
        } catch (e) {
          // Jika parsing gagal, kembalikan list kosong agar UI menampilkan pesan kosong
          print('Error parsing jobs response: $e');
          return [];
        }
      } else {
        // Jangan melempar Exception yang tidak tertangani di UI; log dan kembalikan list kosong
        try {
          final body = jsonDecode(response.body);
          print(
              'getJobsByCompany non-200: ${response.statusCode}, message: ${body['message'] ?? response.body}');
        } catch (_) {
          print(
              'getJobsByCompany non-200: ${response.statusCode}, body: ${response.body}');
        }
        return [];
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
