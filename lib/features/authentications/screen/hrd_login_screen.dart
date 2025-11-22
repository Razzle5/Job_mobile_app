import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:loading_overlay/loading_overlay.dart';
import 'hrd_registration_screen.dart';
import 'package:job_app/features/authentications/controllers/hrd_login_controller.dart';


class HrdLoginScreen extends StatelessWidget { 
  const HrdLoginScreen({super.key});
  static const String id = '/hrd_login_screen';

  @override
  Widget build(BuildContext context) {
  final HrdLoginController controller = Get.put(HrdLoginController());

    return PopScope( 
      canPop: true, 
      onPopInvokedWithResult: (didPop,result) {
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
                  key: controller.formKey, // Hubungkan GlobalKey
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        
                        // HEADER/TITLE
                        const Center(child: Text('HRD LOGIN', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent))),
                        const SizedBox(height: 50),
                        
                        // 3. TEXT FIELD EMAIL
                        TextFormField( 
                          controller: controller.email, 
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value!.isEmpty ? 'Email wajib diisi.' : null,
                          decoration: const InputDecoration(hintText: 'Email', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 15),
                        
                        // 4. TEXT FIELD PASSWORD
                        TextFormField(
                          controller: controller.password, 
                          obscureText: true,
                          validator: (value) => value!.isEmpty ? 'Password wajib diisi.' : null,
                          decoration: const InputDecoration(hintText: 'Password', border: OutlineInputBorder()),
                        ),
                        
                        const SizedBox(height: 40),

                        // 5. BUTTON LOGIN
                        ElevatedButton(
                            onPressed: controller.isLoading.value ? null : controller.loginHrd,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.deepPurple 
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // 6. Tombol ke Sign Up
                        TextButton(
                            onPressed: () {
                                              Get.toNamed(HrdRegistrationScreen.id);
                                          }, 
                            child: const Text("Don't have an account? Sign Up"),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        ElevatedButton.icon(
                            onPressed: controller.isLoading.value ? null : controller.loginGoogle,
                            icon: const Icon(Icons.g_mobiledata_outlined, color: Colors.blue),
                            label: const Text('Login with Google'),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.grey)
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