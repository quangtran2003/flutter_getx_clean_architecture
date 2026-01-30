import 'package:flutter/material.dart';

class DraggableBottomSheet extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double defaultHeight;
  final double maxHeight;

  const DraggableBottomSheet({
    super.key,
    required this.child,
    this.minHeight = 200,
    this.defaultHeight = 400,
    this.maxHeight = 600,
  });

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  late double _currentHeight;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.defaultHeight;
  }

  void _snapToClosest(double height) {
    final snapPoints = [
      widget.minHeight,
      widget.defaultHeight,
      widget.maxHeight
    ];
    double closest = snapPoints[0];
    double minDiff = (height - snapPoints[0]).abs();

    for (var point in snapPoints) {
      final diff = (height - point).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = point;
      }
    }

    setState(() {
      _currentHeight = closest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _currentHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _currentHeight = (_currentHeight - details.delta.dy)
                .clamp(widget.minHeight, widget.maxHeight);
          });
        },
        onVerticalDragEnd: (details) {
          _snapToClosest(_currentHeight);
        },
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}
