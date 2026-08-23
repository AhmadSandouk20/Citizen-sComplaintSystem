import 'package:flutter/material.dart';

class UploadProgressView extends StatelessWidget {
  final double progress;
  final VoidCallback onCancel;

  const UploadProgressView({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
        ),
        const SizedBox(height: 8),
        Text('$percent%'),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onCancel,
          child: const Text('إلغاء الرفع'),
        ),
      ],
    );
  }
}