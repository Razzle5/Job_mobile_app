import 'package:flutter/material.dart';
import 'package:job_app/features/authentications/screen/hrd_registration_screen.dart';
import 'package:job_app/features/user_dashboard/controllers/navigation_controllers.dart';
import 'package:get/get.dart';

void main() {
  // PINDAHKAN Get.put() KE SINI (di luar widget tree)
  Get.put(NavigationControllers()); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // HAPUS Get.put(NavigationControllers()) DARI SINI!
    
    // Ini sekarang sudah aman
    return GetMaterialApp( 
      title: 'Job App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const HrdRegistrationScreen(), 
    );
  }
}