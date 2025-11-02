import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Wajib: Import GetX
import 'package:job_app/common/styles/components.dart'; // Asumsi komponen Alert
import 'package:job_app/constants/colors.dart';
import 'package:loading_overlay/loading_overlay.dart'; // Untuk Loading
import 'package:job_app/features/authentications/controllers/hrd_signup_controller.dart';
import 'package:job_app/features/authentications/screen/hrd_login_screen.dart';


class HrdRegistrationScreen extends StatelessWidget { 
  const HrdRegistrationScreen({super.key});
  static String id = 'hrd_registration_screen'; // ID screen

  @override
  Widget build(BuildContext context) {
    // 1. Inisialisasi/Akses Controller GetX
    final controller = Get.put(HrdSignupController());

    return WillPopScope(
      onWillPop: () async {
        // Asumsi ini navigasi kembali ke Home atau Login
        Navigator.pop(context); 
        return true;
      },
      // 2. Gunakan Obx untuk LoadingOverlay (Menggantikan _saving)
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          body: LoadingOverlay(
            isLoading: controller.isLoading.value, // Gunakan state GetX
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TopScreenImage(screenImageName: 'signup.png'),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ScreenTitle(title: 'HRD Sign Up'),
                            
                            // 3. TEXT FIELD EMAIL
                            CustomTextField(
                              textField: TextField(
                                controller: controller.email, // Hubungkan ke Controller
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(fontSize: 20),
                                decoration: CColors.kTextInputDecoration.copyWith(
                                  hintText: 'Email',
                                ),
                              ),
                            ),
                            
                            // 4. TEXT FIELD PASSWORD
                            CustomTextField(
                              textField: TextField(
                                controller: controller.password, 
                                obscureText: true,
                                style: const TextStyle(fontSize: 20),
                                decoration: CColors.kTextInputDecoration.copyWith(
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                            
                            // 5. TEXT FIELD CONFIRM PASSWORD
                            // Note: Validasi konfirmasi password dilakukan di Controller/Logic.
                            CustomTextField(
                              textField: TextField(
                                obscureText: true,
                                // Gunakan onChanged untuk mengambil nilai konfirmasi password
                                onChanged: (value) {
                                  // Nanti Anda bisa menyimpan ini di variabel RX di Controller
                                  // atau membandingkannya saat tombol ditekan.
                                  controller.confirmPassword = value; 
                                },
                                style: const TextStyle(fontSize: 20),
                                decoration: CColors.kTextInputDecoration.copyWith(
                                  hintText: 'Confirm Password',
                                ),
                              ),
                            ),
                            
                            // 6. BUTTON SIGN UP (Menggantikan CustomBottomScreen)
                            CustomBottomScreen(
                              textButton: 'Sign Up',
                              heroTag: 'signup_btn',
                              question: 'Have an account?',
                              
                              // HUBUNGKAN DENGAN CONTROLLER LARAVEL API
                              buttonPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                // Panggil fungsi registrasi Email/Password
                                controller.registerHrd(AuthMethod.emailPassword);
                              },
                              
                              // Tombol yang mengarah ke halaman Login
                              questionPressed: () async {
                                Navigator.pushNamed(context, HrdLoginScreen.id); 
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Catatan: Hapus state class _SignUpScreenState yang lama.
// Semua variabel (email, password) di handle oleh Controller.
