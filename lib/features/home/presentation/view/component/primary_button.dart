import 'package:flutter/material.dart';

class PrimaryButtonComponent extends StatelessWidget {
  final bool isLoading;
  final String subtitle;
  final String title;

  final VoidCallback onPressed;

  const PrimaryButtonComponent({
    super.key,
    required this.isLoading,
    required this.subtitle,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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
            const Icon(
              Icons.arrow_upward,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // ID Display
            Text(
              title,
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
