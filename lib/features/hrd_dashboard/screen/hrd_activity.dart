import 'package:flutter/material.dart';

class HrdActivityScreen extends StatelessWidget {
  const HrdActivityScreen({super.key});
  static const String id = '/hrd_activity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivitas'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Halaman Aktivitas'),
      ),
    );
  }
}
