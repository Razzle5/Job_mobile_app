import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:job_app/constants/colors.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: CColors.textWhite.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
        ),
          child: const Row(
            children: [
              Icon(Iconsax.search_normal, color: CColors.textWhite),
              SizedBox(width: 12),
              Text("Cari Tipe Kerja", style: TextStyle(color: CColors.textWhite)),
            ],
          )
      ),
    );
  }
}