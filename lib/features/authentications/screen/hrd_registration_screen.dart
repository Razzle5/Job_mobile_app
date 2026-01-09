import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:job_app/constants/enums.dart';
import 'package:job_app/features/authentications/controller/hrd_signup_controller.dart';

class HrdRegistrationScreen extends StatelessWidget {
  const HrdRegistrationScreen({super.key});
  static const String id = '/hrd_registration_screen';

  @override
  Widget build(BuildContext context) {
    final HrdSignupController controller = Get.put(HrdSignupController());

    return PopScope(
      canPop: true,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ================= HEADER =================
                        const Center(
                          child: Text(
                            'HRD Sign Up',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // ================= EMAIL =================
                        TextFormField(
                          controller: controller.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email wajib diisi';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // ================= PASSWORD =================
                        TextFormField(
                          controller: controller.password,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password wajib diisi';
                            }
                            if (value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // ================= CONFIRM PASSWORD =================
                        TextFormField(
                          obscureText: true,
                          onChanged: (value) {
                            controller.confirmPassword = value;
                          },
                          validator: (value) {
                            if (value != controller.password.text) {
                              return 'Password tidak cocok';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ================= SIGN UP BUTTON =================
                        ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  controller.registerHrd(
                                    AuthMethod.emailPassword,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 10),

                        // ================= LOGIN REDIRECT =================
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Have an account? Login Now'),
                        ),

                        const SizedBox(height: 20),

                        // ================= GOOGLE SIGN UP =================
                        ElevatedButton.icon(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  controller.registerHrd(
                                    AuthMethod.google,
                                  );
                                },
                          icon: const Icon(
                            Icons.g_mobiledata_outlined,
                            color: Colors.blue,
                          ),
                          label: const Text('Sign up with Google'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey),
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
      ),
    );
  }
}
