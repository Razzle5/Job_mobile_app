import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:job_app/features/user_dashboard/screen/home.dart';

class NavigationControllers extends GetxController{
  final selectedIndex = 0.obs;

  final screens = const [
    HomeScreen(),
  ];
}