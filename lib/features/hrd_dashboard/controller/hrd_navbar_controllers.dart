import 'package:get/get.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_home_screen.dart';

class NavigationControllers extends GetxController {
  final selectedIndex = 0.obs;

  final screens = const [
    HrdHomeScreen(),
  ];
}
