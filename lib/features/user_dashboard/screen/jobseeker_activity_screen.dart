import 'package:flutter/material.dart';

class JobSeekerActivityScreen extends StatelessWidget {
  const JobSeekerActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Aktivitas Saya',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kelola aplikasi dan lamaran Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Lamaran Masuk
                  Card(
                    child: ListTile(
                      leading:
                          Icon(Icons.mail_outline, color: Colors.blue[600]),
                      title: const Text('Lamaran Masuk'),
                      subtitle: const Text('Lihat status lamaran Anda'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lowongan Tersimpan
                  Card(
                    child: ListTile(
                      leading:
                          Icon(Icons.bookmark_outline, color: Colors.blue[600]),
                      title: const Text('Lowongan Tersimpan'),
                      subtitle: const Text('Lihat lowongan yang Anda simpan'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Riwayat Pencarian
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.history, color: Colors.blue[600]),
                      title: const Text('Riwayat Pencarian'),
                      subtitle: const Text('Lihat riwayat pencarian Anda'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
