// FILE: features/authentications/controller/hrd_login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_navbar.dart';

class HrdLoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  late final GoogleSignIn _googleSignIn;

  RxBool isLoading = false.obs;
  final AuthRepository _repository = AuthRepository();

  @override
  void onInit() {
    _googleSignIn = GoogleSignIn(scopes: ['email']);
    super.onInit();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }

  // ================= LOGIN EMAIL / PASSWORD =================

  Future<void> loginHrd() async {
    if (!formKey.currentState!.validate()) return;

    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Email dan password wajib diisi',
        backgroundColor: Colors.orange,
      );
      return;
    }

    if (password.text.length < 8) {
      Get.snackbar(
        'Gagal',
        'Password minimal 8 karakter',
        backgroundColor: Colors.orange,
      );
      return;
    }

    try {
      isLoading.value = true;

      final result = await _repository.loginHrd(
        email.text.trim(),
        password.text.trim(),
      );

      isLoading.value = false;

      if (result['success'] == true) {
        // 🔥 SIMPAN TOKEN (INI YANG BARU!)
        final token = result['data']['data']['token'];
        await _repository.saveToken(token);

        debugPrint('Token saved: ${token.substring(0, 20)}...');

        // 🔥 SIMPAN USER DATA (opsional, jika backend return user info)
        if (result['data']['user'] != null) {
          await _repository.saveUserData(result['data']['user']);
          debugPrint('User data saved');
        }

        // Navigate ke navbar (dengan home screen)
        Get.offAllNamed(NavigationMenu.id);

        // Snackbar setelah navigasi
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'Sukses',
            'Login HRD berhasil',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        });
      } else {
        Get.snackbar(
          'Login gagal',
          result['message'] ?? 'Email atau password salah',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Login error: $e');
      Get.snackbar(
        'Error',
        'Gagal terhubung ke server',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ================= LOGIN GOOGLE =================

  Future<void> loginGoogle() async {
    Get.snackbar(
      'Info',
      'Login Google belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    try {
      await _repository.logout();
      debugPrint('Logged out successfully');

      Get.offAllNamed('/login'); // Kembali ke login screen

      Get.snackbar(
        'Sukses',
        'Logout berhasil',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      Get.snackbar(
        'Error',
        'Gagal logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
