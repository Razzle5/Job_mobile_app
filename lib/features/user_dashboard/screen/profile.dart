import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:job_app/features/user_dashboard/controllers/job_seeker_controller.dart';

class JobSeekerProfileScreen extends StatelessWidget {
  const JobSeekerProfileScreen({super.key});

  static const String id = '/job_seeker_profile';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobSeekerController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        centerTitle: true,
      ),
      body: Obx(() {
        final data = controller.jobSeeker;

        if (data.isEmpty) {
          return const Center(child: Text("Data profile belum tersedia"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              _profileItem(
                icon: Ionicons.person_outline,
                label: "Nama Lengkap",
                value: "${data['first_name']} ${data['last_name'] ?? ''}",
              ),

              _profileItem(
                icon: Ionicons.mail_outline,
                label: "Email",
                value: data['email'],
              ),

              _profileItem(
                icon: Ionicons.calendar_outline,
                label: "Tanggal Lahir",
                value: data['birth_date'],
              ),

              _profileItem(
                icon: Ionicons.call_outline,
                label: "Nomor Telepon",
                value: data['phone_number'],
              ),

              _profileItem(
                icon: Ionicons.home_outline,
                label: "Domisili",
                value: data['domicile'],
              ),

              _profileItem(
                icon: Ionicons.location_outline,
                label: "Alamat Lengkap",
                value: data['full_address'],
              ),

              _profileItem(
                icon: Ionicons.school_outline,
                label: "Pendidikan Terakhir",
                value: data['current_education'],
              ),

              const SizedBox(height: 32),

              // NANTI BUAT EDIT
              ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    "Info",
                    "Edit profile belum tersedia",
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profil"),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.nunitoSans(),
        ),
      ),
    );
  }
}
