import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/data/repositories/job_repository.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';

class HrdJobListController extends GetxController {
  final RxList<JobModel> jobs = <JobModel>[].obs;
  final RxBool isLoading = false.obs;

  final JobRepository _repository = JobRepository();
  final AuthRepository _authRepo = AuthRepository();

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  Future<void> loadJobs() async {
    isLoading.value = true;
    try {
      final token = await _authRepo.getToken();
      if (token == null || token.isEmpty) {
        jobs.clear();
        isLoading.value = false;
        return;
      }

      final list = await _repository.getJobsByCompany(token);
      jobs.assignAll(list);
    } catch (e) {
      jobs.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteJob(int jobId) async {
    isLoading.value = true;
    try {
      final result = await _repository.deleteJob(jobId);
      if (result['success'] == true) {
        // Remove job dari list
        jobs.removeWhere((job) => job.id == jobId);
        Get.snackbar('Sukses', 'Lowongan berhasil dihapus',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', result['message'] ?? 'Gagal menghapus lowongan',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
