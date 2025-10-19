import 'package:flutter/material.dart';
import 'package:job_app/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CColors.primary,
              padding: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  CCircularContainer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CCircularContainer extends StatelessWidget {
  const CCircularContainer({
    super.key,
  });


  


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(400),
        color: CColors.textWhite.withOpacity(0.1),
      ),
    );
  }
}