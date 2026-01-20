import 'package:flutter/material.dart';
import 'package:job_app/data/models/application_model.dart';
import 'package:job_app/data/repositories/hrd_repository.dart';

class HrdActivityScreen extends StatefulWidget {
  const HrdActivityScreen({super.key});
  static const String id = '/hrd_activity';

  @override
  State<HrdActivityScreen> createState() => _HrdActivityScreenState();
}

class _HrdActivityScreenState extends State<HrdActivityScreen> {
  late Future<List<ApplicationModel>> _applicationsFuture;
  final HrdRepository _hrdRepository = HrdRepository();

  @override
  void initState() {
    super.initState();
    _applicationsFuture = _hrdRepository.fetchApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktivitas')),
      body: FutureBuilder<List<ApplicationModel>>(
        future: _applicationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada lamaran'));
          }

          final applications = snapshot.data!;
          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                child: ListTile(
                  title: Text(app.jobTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Pelamar: ${app.jobSeekerName}'),
                  trailing: Text(app.status,
                      style: const TextStyle(color: Colors.blueAccent)),
                  onTap: () {
                    // ketika card ditekan, buka halaman CV
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CvDetailScreen(application: app),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Halaman detail CV
class CvDetailScreen extends StatelessWidget {
  final ApplicationModel application;
  const CvDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CV ${application.jobSeekerName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${application.jobSeekerName}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Posisi dilamar: ${application.jobTitle}'),
            const SizedBox(height: 8),
            Text('Status: ${application.status}'),
            const Divider(height: 20),
            // tampilkan CV (misalnya link atau text)
            application.cvUrl != null
                ? ElevatedButton(
                    onPressed: () {
                      // buka CV di browser / PDF viewer
                      // contoh: pakai url_launcher
                      // launchUrl(Uri.parse(application.cvUrl!));
                    },
                    child: const Text('Lihat CV'),
                  )
                : const Text('CV belum tersedia'),
          ],
        ),
      ),
    );
  }
}
