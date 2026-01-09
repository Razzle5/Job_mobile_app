import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class JobSeekerController extends GetxController {
  final isLoading = false.obs;

  // 🔥 INI YANG KURANG
  final RxMap<String, dynamic> jobSeeker = <String, dynamic>{}.obs;

  /// ================= SUBMIT DATA =================
  Future<bool> submit({
    required Map<String, String> data,
    required PlatformFile cv,
  }) async {
    try {
      isLoading.value = true;

      final uri = Uri.parse('http://10.64.81.44:8080/api/job-seeker');
      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll(data);
      request.files.add(
        await http.MultipartFile.fromPath(
          'cv',
          cv.path!,
          filename: cv.name,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        // 🔥 SIMPAN DATA KE STATE
        jobSeeker.assignAll(jsonDecode(responseBody)['data']);
        return true;
      } else {
        debugPrint(responseBody);
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= GET PROFILE =================
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('http://10.64.81.44:8080/api/job-seeker/profile'),
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        jobSeeker.assignAll(jsonDecode(response.body)['data']);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
