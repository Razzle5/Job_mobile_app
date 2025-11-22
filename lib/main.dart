import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/features/authentications/controllers/hrd_login_controller.dart';
import 'package:job_app/features/authentications/controllers/hrd_signup_controller.dart';
import 'package:job_app/features/authentications/screen/hrd_login_screen.dart';
import 'package:job_app/features/authentications/screen/hrd_registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HrdLoginScreen.id,
      getPages: [
        GetPage(
          name: HrdLoginScreen.id, 
          page: () => const HrdLoginScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => HrdLoginController());
          }),
        ),
        GetPage(
          name: HrdRegistrationScreen.id, 
          page: () => const HrdRegistrationScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => HrdSignupController());
          }),
        ),
      ],
    );
  }
}