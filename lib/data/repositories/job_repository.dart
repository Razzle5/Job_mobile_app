import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/constants/api_constants.dart';

class JobRepository{
  Future<List<JobModel>> fetchJobs() async{
    final url = Uri.parse('${ApiConstants.tBaseUrl}/api/jobs');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200){
        final body = jsonDecode(response.body);
        final jobListJson = body['jobs'] as List;
        return jobListJson
          .map((jobJson) => JobModel.fromJson(jobJson as Map<String, dynamic>))
          .toList();
      } else {
        throw Exception('Gagal memuat pekerjaan, Status code : ${response.statusCode}');
      }
    } catch (e){
      throw Exception('Gagal koneksi ke server: $e');
    }
  }
}