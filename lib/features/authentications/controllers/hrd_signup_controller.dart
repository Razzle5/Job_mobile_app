import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';
import 'package:google_sign_in/google_sign_in.dart' ;

//enum buat bedain otentikasi (email&password/google)
enum AuthMethod {emailPassword,google}

class HrdSignupController extends GetxController{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final GoogleSignIn _googleSignIn = const GoogleSignIn(scopes: ['email']);
  
  RxBool isLoading = false.obs;
  final AuthRepository _repository = AuthRepository();

  @override
  void onClose() {
    _googleSignIn.signOut();
    email.dispose();
    password.dispose();
    super.onClose();
  }

  //Buat Arahin alur Otentikasi
  
  Future<void> registerHrd(AuthMethod method) async {
    if (method == AuthMethod.emailPassword && !formKey.currentState!.validate()) {
      return; 
    }

    isLoading.value = true;

    try {
      if (method == AuthMethod.google) {
        await _registerWithGoogle();
      } else {
        await _registerWithEmailPassword();
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan server: ${e.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  //logic email&password ke api laravel

  Future<void> _registerWithEmailPassword() async {
    final result = await _repository.registerHrd(email.text, password.text);

    if (result['success']) {
      final userId = result['data']['user_id'];
      
      Get.snackbar('Sukses!', 'Akun HRD berhasil dibuat. User ID: $userId');
      // NAVIGASI: Pindah ke CompanyDataScreen
      // Get.off(() => CompanyDataScreen(userId: userId)); 

    } else {
      String errorMessage = result['message'];
      
      if (result['errors'] != null && result['errors']['email'] != null) {
          errorMessage = result['errors']['email'][0];
      }
      
      Get.snackbar('Gagal Registrasi', errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  // logic sign-in google (ambil token)

  Future<void> _registerWithGoogle() async {
    final GoogleSignInAuthentication? googleAuth = await _handleGoogleSignIn();
    
    if (googleAuth == null || googleAuth.idToken == null) {
      Get.snackbar('Gagal', 'Login Google dibatalkan.');
      return;
    }

    // KIRIM TOKEN GOOGLE KE LARAVEL UNTUK VERIFIKASI
    final result = await _repository.loginGoogle(googleAuth.idToken!);
    
    if (result['success']) {
        // Asumsi Laravel mengembalikan user_id setelah verifikasi token sukses
        final userId = result['data']['user_id']; 
        Get.snackbar('Sukses!', 'Login Google berhasil. User ID: $userId');
        // NAVIGASI: Pindah ke CompanyDataScreen
    } else {
        Get.snackbar('Gagal Login Google', result['message'], backgroundColor: Colors.red, colorText: Colors.white);
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