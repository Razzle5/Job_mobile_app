import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:job_app/features/user_dashboard/controllers/navigation_controllers.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationControllers>();

    return Scaffold(
      //bottom navigation bar showed
        bottomNavigationBar: Obx(
          () =>  NavigationBar(
              height: 80,
              
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) => controller.selectedIndex.value = index,
              
              destinations: const[
                  NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
                  NavigationDestination(icon: Icon(Iconsax.activity), label: "My Activity"),
                  NavigationDestination(icon: Icon(Iconsax.profile_circle), label: "Profile"),
              ],
          ),
        ),
        //showed screen based on choice
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

