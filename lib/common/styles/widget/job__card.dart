// lib/common/widgets/job_card.dart

import 'package:flutter/material.dart';
import 'package:job_app/constants/colors.dart'; 
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:job_app/data/models/job_model.dart';

class TJobCard extends StatelessWidget {
  final JobModel jobModel;
  const TJobCard({super.key,required this.jobModel});

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
            color: Colors.grey.withAlpha(25),
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
              // Judul & Perusahaan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jobModel.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(jobModel.companyName, style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),

              // Tombol Bookmark (Bendera)
              Icon(Iconsax.save_2, color: CColors.primary), // Ganti dengan CColors.primary
            ],
          ),
          
          const SizedBox(height: 12),

          // 2. BARIS BAWAH: Lokasi & Gaji
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lokasi/Tipe Kerja
              Text(jobModel.location, style: TextStyle(color: Colors.grey)), 

              // Gaji
              Text(jobModel.salary, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), 
            ],
          ),
        ],
      ),
    );
  }
}