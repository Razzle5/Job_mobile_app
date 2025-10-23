// lib/common/widgets/job_card.dart

import 'package:flutter/material.dart';
import 'package:job_app/constants/colors.dart'; // Asumsikan warna Anda
import 'package:iconsax_flutter/iconsax_flutter.dart'; // Untuk ikon (misal bookmark)

class TJobCard extends StatelessWidget {
  // Nanti akan menerima JobModel, untuk saat ini kita buat statis dulu
  const TJobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0), // Jarak antar card
      decoration: BoxDecoration(
        color: CColors.textWhite, // Latar belakang putih
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          // Tambahkan shadow agar terlihat timbul (opsional)
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BARIS ATAS: Logo, Judul Pekerjaan, Tombol Bookmark
          Row(
            children: [
              // Logo Perusahaan (Ganti dengan Image.asset atau NetworkImage)
              const Icon(Iconsax.facebook, size: 40, color: Colors.blue), 
              const SizedBox(width: 12),
              
              // Judul & Perusahaan
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ui/Ux Designer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Facebook", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),

              // Tombol Bookmark (Bendera)
              Icon(Iconsax.save_2, color: CColors.primary), // Ganti dengan CColors.primary
            ],
          ),
          
          const SizedBox(height: 12),

          // 2. BARIS BAWAH: Lokasi & Gaji
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lokasi/Tipe Kerja
              Text("United State - Full Time", style: TextStyle(color: Colors.grey)), 

              // Gaji
              Text("\$ 2.500", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), 
            ],
          ),
        ],
      ),
    );
  }
}