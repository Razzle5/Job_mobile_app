import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:job_app/features/hrd_dashboard/controllers/hrd_registration_controller.dart';

class HrdRegistScreen extends StatelessWidget{
    const HrdRegistScreen({super.key});

    @override
    Widget build(BuildContext context){
        final controller = Get.put(HrdRegistrationController());

        return Scaffold(
            appBar: AppBar(title: const Text('HRD Registration')),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const SizedBox(height: 32,),

                            SizedBox(
                                width: double.infinity,
                                child: Obx(() => ElevatedButton(
                                    onPressed: controller.isLoading.value ? null : () => controller.registerHrd(AuthMethod.emailPassword), 
                                    child: controller.isLoading.value
                                    ? const CirlularProgressIndicator(color:Color.white)
                                    : const Text('Register & Continue')
                                    ),
                                ),
                            ),

                            const SizedBox(height: 24,),

                            SizedBox(
                                width: double.infinity,
                                child: Obx(
                                    () => OutlinedButton.icon(
                                        icon: Image.asset('assets/images/google_logo.png', height: 20,),
                                        label: const Text('Sign in with google'),
                                        onPressed: controller.isLoading.value ? null : () => controller.registerHrd(AuthMethod.google),
                                        style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 15)),
                                    
                                    ),

                                ),
                            )
                        ],
                    )),
            ),
        );
    }
}

enum AuthMethod {emailPassword, google}