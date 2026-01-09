import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';
import 'package:job_app/constants/enums.dart';
import 'package:job_app/features/authentications/screen/hrd_login_screen.dart';

class HrdSignupController extends GetxController {
  // ================= STATE & CONTROLLERS =================
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  late final GoogleSignIn _googleSignIn;

  /// diisi dari TextFormField confirm password
  late String confirmPassword;

  final RxBool isLoading = false.obs;
  final AuthRepository _repository = AuthRepository();

  // ================= LIFECYCLE =================
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

  // ================= VALIDATOR =================
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // ================= REGISTER =================
  Future<void> registerHrd(AuthMethod method) async {
    // --- VALIDASI FORM ---
    if (method == AuthMethod.emailPassword) {
      if (!formKey.currentState!.validate()) return;

      if (password.text != confirmPassword) {
        Get.snackbar(
          'Gagal',
          'Konfirmasi password tidak cocok',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    // --- START LOADING ---
    isLoading.value = true;

    try {
      // ================= GOOGLE =================
      if (method == AuthMethod.google) {
        isLoading.value = false;
        final googleAuth = await _handleGoogleSignIn();

        if (googleAuth == null) {
          Get.snackbar(
            'Info',
            'Login Google dibatalkan',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        // TODO: kirim token ke backend jika mau
        Get.snackbar(
          'Info',
          'Register Google belum diimplementasikan',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // ================= EMAIL / PASSWORD =================
      debugPrint('🔄 Calling registerHrd API...');
      final result = await _repository.registerHrd(
        email.text.trim(),
        password.text,
      );
      debugPrint('✅ API Response: $result');

      // 🔥 STOP LOADING SEBELUM NAVIGASI
      isLoading.value = false;
      debugPrint('⏹️ Loading stopped');

      if (result['success'] == true) {
        debugPrint('✅ Registration success!');

        // 🔥 METODE 1: Navigasi langsung (paling sederhana)
        Get.back(); // Kembali ke halaman sebelumnya (login)

        // Tampilkan snackbar setelah navigasi
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'Sukses',
            'Akun HRD berhasil dibuat',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        });
      } else {
        debugPrint('❌ Registration failed: ${result['message']}');
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Registrasi gagal',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('💥 Error: $e');
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ================= GOOGLE SIGN IN =================
  Future<GoogleSignInAuthentication?> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user == null) return null;
      return await user.authentication;
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      return null;
    }
  }
}
