import 'package:flutter/material.dart';
import 'package:job_app/constants/colors.dart';


class CCircularContainer extends StatelessWidget {
  const CCircularContainer({
    super.key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundcolor = CColors.primaryBackground,
  });

  final double? width;
  final double? height;
  final double? radius;
  final double? padding;
  final Widget? child; 
  final Color backgroundcolor;
    


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 00),
        color: backgroundcolor,
      ),
      child: child,
    );
  }
}