import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:job_app/constants/enums.dart';
import 'package:job_app/features/authentications/controllers/hrd_signup_controller.dart';
import 'package:job_app/features/authentications/screen/hrd_login_screen.dart';

class HrdRegistrationScreen extends StatelessWidget {
  const HrdRegistrationScreen({super.key});
  static const String id = '/hrd_registration_screen';

  @override
  Widget build(BuildContext context) {
  final HrdSignupController controller = Get.put(HrdSignupController());

    // accsess controller

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
                        //HEADER/TITLE
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

                        // TEXT FIELD EMAIL
                        TextFormField(
                          controller: controller.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? 'Email wajib diisi.' : null,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // TEXT FIELD PASSWORD
                        TextFormField(
                          controller: controller.password,
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? 'Password wajib diisi.' : null,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),

                        //  TEXT FIELD CONFIRM PASSWORD
                        TextFormField(
                          obscureText: true,
                          onChanged: (value) {
                            controller.confirmPassword = value;
                          },
                          // password confirm validation
                          validator: (value) =>
                              (value != controller.password.text)
                              ? 'Password tidak cocok.'
                              : null,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 40),

                        //  sign up button
                        ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.registerHrd(
                                  AuthMethod.emailPassword,
                                ),
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

                        // login destination button
                        TextButton(
                          onPressed: () {
                               controller.isLoading.value = false;
                                Get.back();
                          },
                          child: const Text('Have an account? Login Now'),
                        ),

                        const SizedBox(height: 20),

                        // Google Sign-in button
                        ElevatedButton.icon(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.registerHrd(AuthMethod.google),
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
