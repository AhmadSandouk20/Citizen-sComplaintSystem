import 'package:flutter/material.dart';

import '../../../../../core/files/models/selected_attachment.dart';
import '../../../../agencies/domain/entities/agency_entity.dart';

class ComplaintReviewStep extends StatelessWidget {
  final AgencyEntity agency;
  final String title;
  final String description;
  final String location;
  final String priority;
  final List<SelectedAttachment> attachments;

  const ComplaintReviewStep({
    super.key,
    required this.agency,
    required this.title,
    required this.description,
    required this.location,
    required this.priority,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'مراجعة الشكوى',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('تأكد من البيانات قبل إرسال الشكوى'),
        const SizedBox(height: 24),

        _ReviewItem(
          title: 'الجهة',
          value: agency.name,
          icon: Icons.account_balance_outlined,
        ),
        _ReviewItem(title: 'عنوان الشكوى', value: title, icon: Icons.title),
        _ReviewItem(
          title: 'الوصف',
          value: description,
          icon: Icons.description_outlined,
        ),

        if (location.trim().isNotEmpty)
          _ReviewItem(
            title: 'الموقع',
            value: location,
            icon: Icons.location_on_outlined,
          ),

        _ReviewItem(
          title: 'الأولوية',
          value: _priorityLabel(priority),
          icon: Icons.flag_outlined,
        ),

        _ReviewItem(
          title: 'المرفقات',
          value: attachments.isEmpty
              ? 'لا توجد مرفقات'
              : '${attachments.length} مرفق',
          icon: Icons.attach_file,
        ),
      ],
    );
  }

  String _priorityLabel(String value) {
    switch (value) {
      case 'low':
        return 'منخفضة';
      case 'high':
        return 'مرتفعة';
      case 'medium':
      default:
        return 'متوسطة';
    }
  }
}

class _ReviewItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ReviewItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
