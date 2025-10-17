import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
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
        body: Obx(() => controller.screen[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
    final Rx<int> selectedIndex = 0.obs;

    final screen = [Container(color:Colors.green),Container(color:Colors.yellow),Container(color:Colors.blue)];
}