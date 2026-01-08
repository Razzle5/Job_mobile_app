import 'package:flutter/material.dart';
import 'package:job_app/common/styles/widget/search_container.dart';
import 'package:job_app/common/styles/widget/custom_shapes/container/primary_header_container.dart';
import 'package:job_app/common/styles/widget/job__card.dart';
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/data/repositories/job_repository.dart';
import 'package:get/get.dart';
import 'package:job_app/features/hrd_dashboard/screen/hrd_addjob_screen.dart';


class HrdHomeScreen extends StatefulWidget {
  const HrdHomeScreen({super.key});
  static const String id = '/hrd_home_screen';

  @override
  State<HrdHomeScreen> createState() => _HrdHomeScreenState();
}

class _HrdHomeScreenState extends State<HrdHomeScreen> {
  late Future<List<JobModel>> _jobFuture;
  final JobRepository _jobRepository = JobRepository();

  @override
  void initState() {
    super.initState(); 
    _jobFuture = _jobRepository.fetchJobs();
  }
  
  void _refreshJobs() {
    setState(() {
      _jobFuture = _jobRepository.fetchJobs();
    });
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
                      "job vacancy you've posted",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    FutureBuilder<List<JobModel>>(
                      future: _jobFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Anda belum menambahkan lowongan pekerjaan.'),
                          );
                        }

                        final jobs = snapshot.data!;

                        return SizedBox(
                          height: jobs.length * 150.0,
                          child: ListView.builder(
                            itemCount: jobs.length,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return TJobCard(jobModel: job);
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
            // 🔥 FLOATING ACTION BUTTON (Tombol +)
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate ke AddJobScreen
          final result = await Get.toNamed(AddJobScreen.id);
          
          // Refresh data jika berhasil tambah lowongan
          if (result == true) {
            _refreshJobs();
          }
        },
        backgroundColor: Colors.purple[600],
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
