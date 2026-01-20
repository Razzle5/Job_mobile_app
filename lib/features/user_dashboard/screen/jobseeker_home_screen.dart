import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/common/styles/widget/search_container.dart';
import 'package:job_app/common/styles/widget/custom_shapes/container/primary_header_container.dart';
import 'package:job_app/common/styles/widget/job__card.dart';
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/data/repositories/job_repository.dart';
import 'package:job_app/data/repositories/job_application_repository.dart';
import 'package:job_app/features/user_dashboard/screen/job_detail_page.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({super.key});
  static const String id = '/jobseeker_home';

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen> {
  late Future<List<JobModel>> _jobFuture;
  final JobRepository _jobRepository = JobRepository();

  @override
  void initState() {
    print('🏠 JobSeekerHomeScreen initState() called');
    _jobFuture = _jobRepository.fetchJobs();
    _jobFuture.then((jobs) {
      print('✅ Jobs loaded successfully: ${jobs.length} jobs');
      for (var job in jobs) {
        print('   - ${job.title} (${job.companyName})');
      }
    }).catchError((error) {
      print(' Error loading jobs: $error');
    });
    super.initState();
  }

  void unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: unfocusKeyboard,
        child: SingleChildScrollView(
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
                      "Lowongan Pekerjaan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<JobModel>>(
                      future: _jobFuture,
                      builder: (context, snapshot) {
                        print(
                            '📊 FutureBuilder state: ${snapshot.connectionState}');

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          print('⏳ Jobs loading...');
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          print('❌ FutureBuilder error: ${snapshot.error}');
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          print(
                              '⚠️ No jobs data returned. hasData: ${snapshot.hasData}, isEmpty: ${snapshot.data?.isEmpty ?? 'null'}');
                          return const Center(
                            child: Text('Tidak ada lowongan pekerjaan'),
                          );
                        }

                        final jobs = snapshot.data!;
                        print('✅ Rendering ${jobs.length} jobs');
                        return SizedBox(
                          height: jobs.length * 150.0,
                          child: ListView.builder(
                            itemCount: jobs.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return InkWell(
                                onTap: () {
                                  Get.to(() => JobDetailPage(job: job));
                                },
                                child: TJobCard(jobModel: job),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
