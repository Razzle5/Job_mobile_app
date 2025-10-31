import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository.dart'; // Sesuaikan path

class HrdRegistrationController extends GetxController {
  // Properti untuk Form dan Loading State
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  
  // Observable untuk status loading tombol
  RxBool isLoading = false.obs;
  
  // Instance Repository
  final AuthRepository _repository = AuthRepository();

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }

  // Fungsi utama untuk menangani registrasi
  Future<void> registerHrd() async {
    if (!formKey.currentState!.validate()) {
      return; // Stop jika validasi form gagal
    }

    isLoading.value = true; // Mulai loading

    try {
      final result = await _repository.registerHrd(email.text, password.text);

      if (result['success']) {
        // registrasi SUKSES (Code 201)
        
        final userId = result['data']['user_id'];
        
        Get.snackbar('Sukses!', 'Akun HRD berhasil dibuat. Lanjutkan pengisian data perusahaan.');

      } else {
        // (Code 422 atau Error Server)
        String errorMessage = result['message'];
        
        // Cek jika ada error validasi spesifik dari Laravel
        if (result['errors'] != null && result['errors']['email'] != null) {
             errorMessage = result['errors']['email'][0]; // Ambil pesan error email
        }
        
        Get.snackbar('Gagal Registrasi', errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error Koneksi', 'Gagal terhubung ke server. Cek koneksi API Anda.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false; // Akhiri loading
    }
  }
}