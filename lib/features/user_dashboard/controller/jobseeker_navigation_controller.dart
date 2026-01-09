import 'package:get/get.dart';
import 'package:job_app/features/user_dashboard/screen/jobseeker_home_screen.dart';
import 'package:job_app/features/user_dashboard/screen/jobseeker_activity_screen.dart';
import 'package:job_app/features/user_dashboard/screen/jobseeker_profile_screen.dart';

class JobSeekerNavigationController extends GetxController {
  final selectedIndex = 0.obs;

  final screens = const [
    JobSeekerHomeScreen(),
    JobSeekerActivityScreen(),
    JobSeekerProfileScreen(),
  ];
}
