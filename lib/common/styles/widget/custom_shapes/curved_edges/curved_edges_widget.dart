import 'package:flutter/material.dart';
import 'package:job_app/common/styles/widget/custom_shapes/curved_edges/curved_edges.dart';

class CCurvedEdgeWidget extends StatelessWidget {
  const CCurvedEdgeWidget({
    super.key,

    this.child,
  });

  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CCustomCurvedEdges(),
      child: child,
    );
  }
}
