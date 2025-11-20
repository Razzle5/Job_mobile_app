import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_app/constants/enums.dart';

class HrdSignupController extends GetxController {
  // --- PROPERTI STATE DAN CONTROLLERS ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  late final GoogleSignIn _googleSignIn;

  late String
  confirmPassword; 

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

  static String? validatePassword(String? password) {
    if (password == null) {
      return 'Password harus di isi';
    }
    if (password.length < 8) {
      return 'Password minimal 8 character';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'password harus mengandung setidaknya 1 angka';
    }
    return null;
  }

  Future<void> registerHrd(AuthMethod method) async {

    if (method == AuthMethod.emailPassword) {
      if (!formKey.currentState!.validate() ||
          password.text != confirmPassword) {
        if (password.text != confirmPassword) {
          Get.snackbar(
            'Gagal!',
            'Konfirmasi password tidak cocok.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        return;
      }
    }
    //logic api call
    isLoading.value = true;

    try {
      if (method == AuthMethod.google) {
        await _registerWithGoogle();
      } else {
        await _registerWithEmailPassword();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan server: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> _registerWithEmailPassword() async {
    final result = await _repository.registerHrd(email.text, password.text);

    if (result['success']) {
      final userId = result['data']['user_id'];

      Get.snackbar('Sukses!', 'Akun HRD berhasil dibuat. ID: $userId');

      Get.offAllNamed('/hrd/login');
    } else {
      String errorMessage = result['message'];

      if (result['errors'] != null && result['errors']['email'] != null) {
        errorMessage = result['errors']['email'][0];
      }

      Get.snackbar(
        'Gagal Registrasi',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _registerWithGoogle() async {
    final GoogleSignInAuthentication? googleAuth = await _handleGoogleSignIn();

    if (googleAuth == null || googleAuth.idToken == null) {
      Get.snackbar('Gagal', 'Login Google dibatalkan.');
      return;
    }

    final result = await _repository.loginGoogle(googleAuth.idToken!);

    if (result['success']) {
      final userId = result['data']['user_id'];
      Get.snackbar('Sukses!', 'Login Google berhasil. ID: $userId');
    } else {
      Get.snackbar(
        'Gagal Login Google',
        result['message'],
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<GoogleSignInAuthentication?> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      return await googleUser.authentication;
    } catch (e) {
      print('Google Sign In Error: $e');
      return null;
    }
  }
}
