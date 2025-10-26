import 'package:flutter/material.dart';
import 'package:job_app/common/styles/widget/search_container.dart';
import 'package:job_app/common/styles/widget/custom_shapes/container/primary_header_container.dart';
import 'package:job_app/common/styles/widget/job__card.dart';
import 'package:job_app/data/models/job_model.dart';
import 'package:job_app/data/repositories/job_repository.dart';
import 'package:job_app/data/repositories/job_repository.dart';
import 'package:job_app/data/models/job_model.dart';

// KODE MODIFIKASI HomeScreen

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});
    

    @override
    State <HomeScreen> createState() => _HomeScreenState();
}

  class _HomeScreenState extends State<HomeScreen>{
      late Future<List<JobModel>> _jobFuture;
      final JobRepository _jobRepository = JobRepository();

      @override
      void initState(){
        _jobFuture = _jobRepository.fetchJobs();
      }

      void unfocusKeyboard(){
        FocusScope.of(context).unfocus();
    }





    @override
    Widget build(BuildContext context) {
      
        return  Scaffold(
            // SingleChildScrollView adalah container untuk atur scroll 
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
                                                
                                                FutureBuilder<List<JobModel>>(
                                                  future: _jobFuture,
                                                  builder: (context,snapshot){
                                                    if (snapshot.connectionState == ConnectionState.waiting){
                                                      return const Center(child: CircularProgressIndicator(),);
                                                    }
                                                    if(snapshot.hasError){
                                                      return Center(child: Text('Error: ${snapshot.error}'),);
                                                    }
                                                    if(snapshot.hasData){
                                                      final jobs = snapshot.data!;

                                                      return SizedBox(
                                                        height: jobs.length * 150.0,
                                                        child: ListView.builder(
                                                          itemCount: jobs.length,
                                                          itemBuilder: (context, index){
                                                            final job = jobs[index];

                                                            return TJobCard(jobModel: job);
                                                          },
                                                          physics: const NeverScrollableScrollPhysics(),
                                                        ),
                                                      );
                                                    }
                                                    return const SizedBox.shrink();                                                  },
                                                )
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