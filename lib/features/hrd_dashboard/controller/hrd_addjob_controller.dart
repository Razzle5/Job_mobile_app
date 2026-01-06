import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/job_repository.dart';

class AddJobController extends GetxController {
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Text Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  
  // Observable variables
  final RxString selectedType = 'Full-time'.obs;
  final RxBool isLoading = false.obs;
  
  // Repository
  final JobRepository _repository = JobRepository();

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    salaryController.dispose();
    super.onClose();
  }

  Future<void> submitJob() async {
    // Validasi form
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Data yang dikirim ke backend
      final jobData = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'location': locationController.text.trim(),
        'salary': salaryController.text.trim(),
        'type': selectedType.value,
        // company_id akan otomatis diambil dari backend (dari session HRD)
      };

      debugPrint('📤 Sending job data: $jobData');

      // Panggil API
      final result = await _repository.createJob(jobData);

      isLoading.value = false;

      if (result['success'] == true) {
        // Kembali ke halaman sebelumnya
        Get.back();
        
        // Tampilkan success message
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'Sukses',
            'Lowongan berhasil ditambahkan',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        });
      } else {
        // Tampilkan error message
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal menambahkan lowongan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}