import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/features/authentications/controller/hrd_login_controller.dart';
import 'package:job_app/features/authentications/controller/hrd_signup_controller.dart';
import 'package:job_app/features/authentications/controller/jobseeker_login_controller.dart';
import 'package:job_app/features/authentications/controller/jobseeker_signup_controller.dart';
import 'package:job_app/features/authentications/screen/hrd_login_screen.dart';
import 'package:job_app/features/authentications/screen/hrd_registration_screen.dart';
import 'package:job_app/features/authentications/screen/jobseeker_login_screen.dart';
import 'package:job_app/features/authentications/screen/jobseeker_signup_screen.dart';
import 'package:job_app/features/authentications/screen/welcome_screen.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_home_screen.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_navbar.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_profile.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_addjob_screen.dart';
import 'package:job_app/features/hrd_dashboard/controller/hrd_addjob_controller.dart';
import 'package:job_app/features/user_dashboard/screen/jobseeker_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      getPages: [
        GetPage(
          name: WelcomeScreen.id,
          page: () => const WelcomeScreen(),
        ),
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
        GetPage(
          name: JobSeekerLoginScreen.id,
          page: () => const JobSeekerLoginScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => JobSeekerLoginController());
          }),
        ),
        GetPage(
          name: JobSeekerSignupScreen.id,
          page: () => const JobSeekerSignupScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => JobSeekerSignupController());
          }),
        ),
        GetPage(
          name: HrdHomeScreen.id,
          page: () => const HrdHomeScreen(),
        ),
        GetPage(
          name: NavigationMenu.id, // Route ke navbar
          page: () => const NavigationMenu(),
        ),
        GetPage(
          name: HrdProfileScreen.id,
          page: () => const HrdProfileScreen(),
        ),
        GetPage(
          name: AddJobScreen.id,
          page: () => const AddJobScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AddJobController());
          }),
        ),
        GetPage(
          name: JobSeekerNavigationMenu.id,
          page: () => const JobSeekerNavigationMenu(),
        ),
      ],
    );
  }
}
