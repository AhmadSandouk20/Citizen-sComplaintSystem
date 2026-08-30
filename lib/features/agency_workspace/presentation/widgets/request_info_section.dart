import 'package:flutter/material.dart';

import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_text_field.dart';

class RequestInfoSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final bool enabled;
  final Future<void> Function() onSend;

  const RequestInfoSection({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.contact_support_outlined),
                SizedBox(width: 8),
                Text(
                  'طلب معلومات إضافية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'أرسل رسالة إلى المواطن لطلب معلومات إضافية عن الشكوى.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            IgnorePointer(
              ignoring: !enabled || isLoading,
              child: Opacity(
                opacity: enabled ? 1 : 0.6,
                child: AppTextField(
                  controller: controller,
                  label: 'الرسالة',
                  hint: 'اكتب المعلومات المطلوبة من المواطن...',
                  maxLines: 4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            AppButton(
              label: 'إرسال الطلب',
              icon: Icons.send_outlined,
              isLoading: isLoading,
              onPressed: enabled && !isLoading ? onSend : null,
            ),
          ],
        ),
      ),
    );
  }
}
