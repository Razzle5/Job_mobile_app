import 'package:flutter/material.dart';
import 'package:job_app/common/styles/widget/search_container.dart';
import 'package:job_app/common/styles/widget/custom_shapes/container/primary_header_container.dart';
import 'package:job_app/common/styles/widget/job__card.dart';
// KODE MODIFIKASI HomeScreen

class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      void unfocusKeyboard(){
        FocusScope.of(context).unfocus();
      }
        return  Scaffold(
            // SingleChildScrollView adalah container utama yang mengatur scroll
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: unfocusKeyboard,

              child: SingleChildScrollView( 
                  child: Column( 
                      children: [
                          // A. HEADER AREA (Warna Biru, Bentuk Melengkung)
                          CPrimaryHeaderContainer(
                              child: Column(
                                  children: [
                                      // TAppBar(), // <-- Nanti untuk user profile
                                      TSearchContainer(), 
                                  ],
                              ),
                          ),
              
                          // B. BODY AREA (Konten di bawah header, di luar CCurvedEdgeWidget)
                          GestureDetector(
                            onTap: unfocusKeyboard,
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Column(
                                      children: [
                                        Text("Job Recommendation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                SizedBox(height: 16),
                                                TJobCard(), // <-- Card Pekerjaan Pertama
                                      ],
                                  ),
                              ),
                            ),
                          )
                      ],
                  ),
              ),
            ),
        );
    }
}