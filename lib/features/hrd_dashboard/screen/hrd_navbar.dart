import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:job_app/features/hrd_dashboard/controller/hrd_navbar_controllers.dart';
import 'package:job_app/features/hrd_dashboard/controller/hrd_job_list_controller.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_addjob_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  static const String id = '/hrd_navbar';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HrdNavigationControllers());

    return Scaffold(
      //bottom navigation bar showed
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(
                icon: Icon(Iconsax.activity), label: "My Activity"),
            NavigationDestination(
                icon: Icon(Iconsax.profile_circle), label: "Profile"),
          ],
        ),
      ),
      //showed screen based on choice
      body: Obx(() => controller.screens[controller.selectedIndex.value]),

      // 🔥 FLOATING ACTION BUTTON (Tombol +) - Hanya tampil di Home tab
      floatingActionButton: Obx(
        () => controller.selectedIndex.value == 0
            ? FloatingActionButton(
                onPressed: () async {
                  final result = await Get.toNamed(AddJobScreen.id);
                  if (result == true) {
                    try {
                      final jobCtrl = Get.find<HrdJobListController>();
                      jobCtrl.loadJobs();
                    } catch (_) {
                      // ignore if controller not found
                    }
                  }
                },
                backgroundColor: Colors.blue[600],
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              )
            : const SizedBox.shrink(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
