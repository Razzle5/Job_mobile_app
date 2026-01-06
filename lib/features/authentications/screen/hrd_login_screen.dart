import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/features/authentications/controllers/hrd_login_controller.dart';
import 'hrd_registration_screen.dart';

class HrdLoginScreen extends StatelessWidget {
  const HrdLoginScreen({super.key});
  static const String id = '/hrd_login_screen';

  @override
  Widget build(BuildContext context) {
    final HrdLoginController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'HRD LOGIN',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  TextFormField(
                    controller: controller.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email wajib diisi'
                        : null,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: controller.password,
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Password wajib diisi'
                        : null,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🔥 LOGIN BUTTON (AMAN)
                  Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                await controller.loginHrd();
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      )),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Get.toNamed(HrdRegistrationScreen.id);
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: controller.loginGoogle,
                    icon: const Icon(Icons.g_mobiledata_outlined,
                        color: Colors.blue),
                    label: const Text('Login with Google'),
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
    );
  }
}
