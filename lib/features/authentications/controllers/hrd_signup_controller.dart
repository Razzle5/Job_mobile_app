import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart'; 
import 'package:google_sign_in/google_sign_in.dart'; 

// Enum untuk membedakan metode otentikasi
enum AuthMethod {emailPassword, google}

class HrdSignupController extends GetxController {
  // --- PROPERTI STATE DAN CONTROLLERS ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  
  // Perbaikan Constructor: Gunakan constructor default tanpa 'const'
  // (Ini bekerja untuk versi google_sign_in 6.2.1)
  late final GoogleSignIn _googleSignIn; 
  
  late String confirmPassword; // Digunakan untuk menyimpan nilai konfirmasi password
  
  RxBool isLoading = false.obs;
  final AuthRepository _repository = AuthRepository();

  @override
  void onInit() {
      // Inisialisasi GoogleSignIn di onInit
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

  // =======================================================
  // FUNGSI UTAMA: MENGARAHKAN ALUR OTENTIKASI
  // =======================================================
  
  Future<void> registerHrd(AuthMethod method) async {
    // 1. Validasi form HANYA jika menggunakan Email/Password
    if (method == AuthMethod.emailPassword) {
        // Validasi TextFormFields dan juga validasi password manual
        if (!formKey.currentState!.validate() || password.text != confirmPassword) {
            if (password.text != confirmPassword) {
                 Get.snackbar('Gagal!', 'Konfirmasi password tidak cocok.', backgroundColor: Colors.red, colorText: Colors.white);
            }
            return; 
        }
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

  // Logic internal lainnya...
  Future<void> _registerWithEmailPassword() async {
    final result = await _repository.registerHrd(email.text, password.text);

    if (result['success']) {
      final userId = result['data']['user_id'];
      
      Get.snackbar('Sukses!', 'Akun HRD berhasil dibuat. ID: $userId');
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