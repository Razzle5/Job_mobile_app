import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/data/repositories/job_application_repository.dart';

class JobDetailPage extends StatelessWidget {
  final JobModel job;
  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.companyName,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job.description ?? 'Tidak ada deskripsi'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await JobApplicationRepository().applyJob(job.id);
                    Get.snackbar('Sukses', 'Lamaran berhasil dikirim',
                        backgroundColor: Colors.green,
                        colorText: Colors.white);
                  } catch (e) {
                    Get.snackbar('Error', 'Gagal melamar: $e',
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                child: const Text('Lamar Pekerjaan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
