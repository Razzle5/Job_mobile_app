import 'package:flutter/material.dart';
import 'package:job_app/common/styles/widget/search_container.dart';
import 'package:job_app/common/styles/widget/custom_shapes/container/primary_header_container.dart';
import 'package:job_app/common/styles/widget/job__card.dart';
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/data/repositories/job_repository.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';
import 'package:job_app/features/hrd_dashboard/controller/hrd_job_list_controller.dart';
import 'package:get/get.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_addjob_screen.dart';

class HrdHomeScreen extends StatefulWidget {
  const HrdHomeScreen({super.key});
  static const String id = '/hrd_home_screen';

  @override
  State<HrdHomeScreen> createState() => _HrdHomeScreenState();
}

class _HrdHomeScreenState extends State<HrdHomeScreen> {
  final HrdJobListController jobCtrl = Get.put(HrdJobListController());

  void unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            CPrimaryHeaderContainer(
              child: Column(
                children: const [
                  TSearchContainer(),
                ],
              ),
            ),

            // ================= BODY =================
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "job vacancy you've posted",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (jobCtrl.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (jobCtrl.jobs.isEmpty) {
                      return const Center(
                        child:
                            Text('Anda belum menambahkan lowongan pekerjaan.'),
                      );
                    }

                    final jobs = jobCtrl.jobs;

                    return SizedBox(
                      height: jobs.length * 150.0,
                      child: ListView.builder(
                        itemCount: jobs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return TJobCard(jobModel: job);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
