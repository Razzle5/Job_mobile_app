import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart'; // Sesuaikan path jika perlu
import 'package:google_sign_in/google_sign_in.dart';


class HrdLoginController extends GetxController {
  // Properti untuk Form dan Loading State
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
    _googleSignIn.signOut();
    email.dispose();
    password.dispose();
    super.onClose();
  }

  // 1. LOGIC LOGIN EMAIL/PASSWORD

  Future<void> loginHrd() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar(
        'Gagal!',
        'Email dan Password wajib diisi.',
        backgroundColor: Colors.yellow.shade800,
        colorText: Colors.black,
      );
      return;
    }
    if (password.text.length < 8) {
      Get.snackbar(
        'Gagal!',
        'Password minimal 8 huruf atau angka',
        backgroundColor: Colors.yellowAccent,
        colorText: Colors.black,
      );
      return;
    }
    try {
      final result = await _repository.loginHrd(email.text, password.text);
      // bool loginSuccess = true;

      if (result['success']) {
        final userId = result['data']['user_id'];

        Get.snackbar('Sukses!', 'Login berhasil. Selamat datang!');
        Get.offAllNamed('/hrd/dashboard');
        return;
      } else {
        Get.snackbar(
          'Gagal Login',
          'Email atau password salah.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Koneksi',
        'Gagal terhubung ke server: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //logic login google
  Future<void> loginGoogle() async {
    Get.snackbar(
      'Fitur',
      'Fitur Login Google belum diimplementasikan.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
