import 'package:flutter/material.dart';

import '../../domain/entities/complaint_entity.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintEntity complaint;
  final VoidCallback onTap;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(status: complaint.status),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.confirmation_number_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(complaint.referenceCode)),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.account_balance_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(complaint.agencyName)),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.flag_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(_priorityLabel(complaint.priority)),
                ],
              ),

              if (complaint.createdAt != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text(_formatDate(complaint.createdAt!)),
                  ],
                ),
              ],

              if (complaint.attachments.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.attach_file, size: 18),
                    const SizedBox(width: 4),
                    Text('${complaint.attachments.length} مرفق'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _priorityLabel(String priority) {
    switch (priority) {
      case 'low':
        return 'منخفضة';
      case 'high':
        return 'مرتفعة';
      case 'medium':
      default:
        return 'متوسطة';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_label(status)),
      visualDensity: VisualDensity.compact,
    );
  }

  String _label(String status) {
    switch (status) {
      case 'in_progress':
        return 'قيد المعالجة';
      case 'resolved':
        return 'تم الحل';
      case 'rejected':
        return 'مرفوضة';
      case 'new':
      default:
        return 'جديدة';
    }
  }
}
