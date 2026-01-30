// lib/features/advice/presentation/widgets/advice_button.dart
import 'package:flutter/material.dart';

class AdviceButton extends StatelessWidget {
  final bool isLoading;
  final int currentFetchCount;
  final VoidCallback onPressed;

  const AdviceButton({
    super.key,
    required this.isLoading,
    required this.currentFetchCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String buttonText = 'Get New Advice\nClick';
    IconData iconData = Icons.arrow_upward;

    if (isLoading) {
      switch (currentFetchCount) {
        case 1:
          buttonText = 'Running 1/5...';
          iconData = Icons.hourglass_top;
          break;
        case 2:
          buttonText = 'Running 2/5...';
          iconData = Icons.hourglass_top;
          break;
        case 3:
          buttonText = 'Running 3/5...';
          iconData = Icons.hourglass_top;
          break;
        case 4:
          buttonText = 'Running 4/5...';
          iconData = Icons.hourglass_top;
          break;
        case 5:
          buttonText = 'Running 5/5...';
          iconData = Icons.hourglass_bottom;
          break;
        default:
          buttonText = 'Loading...';
          iconData = Icons.hourglass_empty;
      }
    }

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isLoading ? Colors.blue : Colors.green,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        duration: const Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              isLoading ? buttonText : 'Get New Advice',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // ID Display
            Text(
              isLoading ? 'Stop' : 'Click',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
