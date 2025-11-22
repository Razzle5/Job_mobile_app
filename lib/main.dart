import 'package:flutter/material.dart';
import 'package:job_app/features/authentications/screen/hrd_registration_screen.dart';
import 'package:job_app/features/user_dashboard/controllers/navigation_controllers.dart';
import 'package:get/get.dart';
import 'package:job_app/features/authentications/screen/hrd_login_screen.dart';
import 'package:job_app/features/authentications/controllers/hrd_login_controller.dart';
import 'package:job_app/features/authentications/controllers/hrd_signup_controller.dart';

void main() {
  Get.lazyPut(() => HrdLoginController(), fenix: true);
  Get.lazyPut(() => HrdSignupController(), fenix: true);
  Get.put(NavigationControllers());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        initialBinding: AppBindings(),
      title: 'NextStep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute:HrdLoginScreen.id,
      getPages: [
        GetPage(name: HrdRegistrationScreen.id, page: ()=> HrdRegistrationScreen(),),
        GetPage(name: HrdLoginScreen.id, page: ()=>  HrdLoginScreen(),)

      ],
    );
  }
}
