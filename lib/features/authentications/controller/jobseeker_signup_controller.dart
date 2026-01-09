import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_jobseeker.dart';

class JobSeekerSignupController extends GetxController {
  final RxBool isLoading = false.obs;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final AuthRepositoryJobSeeker _repository = AuthRepositoryJobSeeker();

  Future<void> signup() async {
    // Validasi
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      Get.snackbar('Error', 'Password tidak cocok',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordCtrl.text.length < 8) {
      Get.snackbar('Error', 'Password minimal 8 karakter',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final result =
          await _repository.register(emailCtrl.text.trim(), passwordCtrl.text);

      if (result['success'] == true) {
        isLoading.value = false;
        Get.snackbar('Sukses', 'Registrasi berhasil, silakan login',
            backgroundColor: Colors.green, colorText: Colors.white);
        await Future.delayed(const Duration(milliseconds: 300));
        Get.toNamed('/jobseeker_login');
      } else {
        isLoading.value = false;
        Get.snackbar('Gagal', result['message'] ?? 'Registrasi gagal',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      print('Signup exception: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
