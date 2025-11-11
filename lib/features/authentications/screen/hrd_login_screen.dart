import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/common/styles/components.dart';
import 'package:job_app/constants/colors.dart';
import 'package:loading_overlay/loading_overlay.dart';
// Note: HrdRegistrationScreen.id is used for navigating back from HrdLoginScreen
import '../controllers/hrd_login_controller.dart';

class HrdLoginScreen extends StatelessWidget {
  const HrdLoginScreen({super.key});
  static String id = 'hrd_login_screen';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HrdLoginController());

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          body: LoadingOverlay(
            isLoading: controller.isLoading.value,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      const TopScreenImage(screenImageName: 'welcome.png'),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ScreenTitle(title: 'HRD Login'),

                            // 3. TEXT FIELD EMAIL
                            CustomTextField(
                              textField: TextField(
                                // Menggunakan TextField sesuai template
                                controller: controller.email,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(fontSize: 20),
                                decoration: CColors.kTextInputDecoration
                                    .copyWith(hintText: 'Email'),
                              ),
                            ),

                            // 4. TEXT FIELD PASSWORD
                            CustomTextField(
                              textField: TextField(
                                controller: controller.password,
                                obscureText: true,
                                style: const TextStyle(fontSize: 20),
                                decoration: CColors.kTextInputDecoration
                                    .copyWith(hintText: 'Password'),
                              ),
                            ),

                            // 5. BUTTON LOGIN
                            CustomBottomScreen(
                              textButton: 'Login',
                              heroTag: 'login_btn',
                              question: 'Forgot password?',
                              buttonPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.loginHrd();
                              },
                              questionPressed: () {
                                Get.snackbar(
                                  'Fitur',
                                  'Reset Password belum diimplementasikan.',
                                );
                              },
                            ), // <--- PENUTUP CustomBottomScreen
                            // 6. OPSIONAL: Tombol Login Google
                            ElevatedButton(
                              onPressed: controller.loginGoogle,
                              child: const Text('Login with Google'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
