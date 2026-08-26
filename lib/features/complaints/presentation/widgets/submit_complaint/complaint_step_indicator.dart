import 'package:flutter/material.dart';

class ComplaintStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ComplaintStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الخطوة ${currentStep + 1} من $totalSteps'),
            Text('${(progress * 100).round()}%'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress),
      ],
    );
  }
}
