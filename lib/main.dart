import 'package:flutter/material.dart';
import 'package:job_app/features/authentications/screen/hrd_registration_screen.dart';
import 'package:job_app/features/user_dashboard/controllers/navigation_controllers.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NavigationControllers());
    return GetMaterialApp(
      title: 'Job App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const HrdRegistrationScreen(),
      // home: const Center(
      //   child: Text('Testing', style: TextStyle(color: Colors.red,fontSize: 30),),
      // ),
    );
  }
}
