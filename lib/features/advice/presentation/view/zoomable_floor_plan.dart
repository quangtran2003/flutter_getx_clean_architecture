// lib/features/advice/presentation/widgets/zoomable_floor_plan.dart
import 'package:flutter/material.dart';

class ZoomableFloorPlan extends StatefulWidget {
  final String imagePath;

  const ZoomableFloorPlan({
    super.key,
    required this.imagePath,
  });

  @override
  State<ZoomableFloorPlan> createState() => _ZoomableFloorPlanState();
}

class _ZoomableFloorPlanState extends State<ZoomableFloorPlan> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 4.0,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      child: Image.asset(
        widget.imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}
