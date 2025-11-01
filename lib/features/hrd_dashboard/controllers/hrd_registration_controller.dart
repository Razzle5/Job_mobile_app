import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthMethod {emailPassword, google}

class HrdRegistrationController extends GetxController {
  // Properti untuk Form dan Loading State
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  

  // Observable untuk status loading tombol
  RxBool isLoading = false.obs;
  
  // Instance Repository
  final AuthRepository _repository = AuthRepository();

  @override
  void onClose() {
    _googleSignIn.signOut();
    email.dispose();
    password.dispose();
    super.onClose();
  }



  // Buat Arahin Alur Authentication
  Future<void> registerHrd(AuthMethod method) async {
    if (method == AuthMethod.emailPassword && !formKey.currentState!.validate()) {
      return; // Stop jika validasi form gagal
    }

    isLoading.value = true;//loading

    try{
      if (method == AuthMethod.google){
        await _registerWithGoogle();
      }else{
        await _registerWithEmailPassword();
      }
    } catch(e){
      Get.snackbar('error', 'Terjadi Kesalahan Server : ${e.toString()}',backgroundColor: Colors.red,colorText:Colors.white);
    } finally{
      isLoading.value = false;//stop loading
    }
  }

  //Logic Email/Password

  Future<void> _registerWithEmailPassword() async{
    final result = await _repository.registerHrd(email.text, password.text);

    if(result['success']){
      final userId = result['data']['user_id'];

      Get.snackbar('Sukses!', 'Akun HRD Berhasil Dibuat.');

      print('DEBUG : Registration Success. User ID : $userId');

    } else{
      //Regist gagal code error server 422
      String errorMessage = result['message'];

      //mengambil pesan error dari laravel 
      if (result['errors'] != null && result ['errors']['email'] != null){
        errorMessage = result['errors']['email'][0];
      }
      Get.snackbar('Gagal Resigtrasi', errorMessage,backgroundColor: Colors.red,colorText: Colors.white);
    }
  }

  //Logic Google Sing-In

  Future<void> _registerWithGoogle() async {
    final GoogleSignInAuthentication? googleAuth = await _handleGoogleSignIn();
    
    if (googleAuth == null || googleAuth.idToken == null) {
      Get.snackbar('Gagal', 'Login Google dibatalkan atau terjadi error.');
      return;
    }

    Get.snackbar('Sukses!', 'Login Google berhasil. Lanjutkan pengisian data perusahaan.');

  }

  //untuk ambil/dapat token dari google
  Future<GoogleSignInAuthentication?> _handleGoogleSignIn() async{
    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      return await googleUser.authentication;
    }catch(e) {
      print('Google Sign In Error : $e');
      return null;
    }
  }
}