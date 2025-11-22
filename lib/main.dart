import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/config/app_bindings.dart';
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
      initialBinding: AppBindings(),
      initialRoute: HrdLoginScreen.id,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: HrdLoginScreen.id, page: () => const HrdLoginScreen()),
        GetPage(name: HrdRegistrationScreen.id, page: () => const HrdRegistrationScreen()),
      ],
    );
  }
}
