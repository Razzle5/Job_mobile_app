import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_jobseeker.dart';

class JobSeekerLoginController extends GetxController {
  final RxBool isLoading = false.obs;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final AuthRepositoryJobSeeker _repository = AuthRepositoryJobSeeker();

  Future<void> login() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final result =
          await _repository.login(emailCtrl.text.trim(), passwordCtrl.text);

      print('Login result: $result');

      if (result['success'] == true) {
        isLoading.value = false;
        Get.snackbar('Sukses', 'Login berhasil',
            backgroundColor: Colors.green, colorText: Colors.white);
        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed('/jobseeker_navbar');
      } else {
        isLoading.value = false;
        Get.snackbar('Gagal', result['message'] ?? 'Login gagal',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      print('Login exception: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
