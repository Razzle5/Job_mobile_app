import 'package:flutter/material.dart';
import 'package:job_app/common/styles/widget/custom_shapes/container/circular_container.dart';
import 'package:job_app/constants/colors.dart';
import 'package:job_app/common/styles/widget/custom_shapes/curved_edges/curved_edges_widget.dart';

class CPrimaryHeaderContainer extends StatelessWidget {

    const CPrimaryHeaderContainer({
      super.key,
      required this.child,
    });
    final Widget child;

    @override
    Widget build(BuildContext context) {
        return CCurvedEdgeWidget(
            child: Container(
                color: CColors.primary, 
                padding: const EdgeInsets.all(0),

                child: SizedBox(
                  height: 400,
                child: Stack( 
                    children: [
                       
                        Positioned(top: -150, right: -250, child: CCircularContainer(
                          backgroundcolor: CColors.textWhite.withAlpha(25))),
                        Positioned(top: 100, right: -300, child: CCircularContainer(
                          backgroundcolor: CColors.textWhite.withAlpha(25))),
                        
                        child, 
                    ],
                 ),
                ),
            ),
        );
    }
}