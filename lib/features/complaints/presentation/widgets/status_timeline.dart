import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/status_history_model.dart';

class StatusTimeline extends StatelessWidget {
  final List<StatusHistoryModel> history;

  const StatusTimeline({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('لا يوجد سجل لحالة الشكوى')),
        ),
      );
    }

    return Column(
      children: List.generate(history.length, (index) {
        final item = history[index];
        final isLast = index == history.length - 1;

        return _TimelineItem(item: item, isLast: isLast);
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final StatusHistoryModel item;
  final bool isLast;

  const _TimelineItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: _statusColor(item.newStatus),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade300),
                ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _statusIcon(item.newStatus),
                            color: _statusColor(item.newStatus),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _statusLabel(item.newStatus),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (item.note != null && item.note!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(item.note!),
                      ],

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(item.changedByName ?? 'غير معروف'),
                          ),
                        ],
                      ),

                      if (item.changedAt != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat(
                                'dd/MM/yyyy • HH:mm',
                              ).format(item.changedAt!),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'resolved':
        return Colors.green;

      case 'in_progress':
        return Colors.orange;

      case 'rejected':
        return Colors.red;

      case 'new':
      default:
        return Colors.blue;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'resolved':
        return Icons.check_circle;

      case 'in_progress':
        return Icons.hourglass_top;

      case 'rejected':
        return Icons.cancel;

      case 'new':
      default:
        return Icons.fiber_new;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'resolved':
        return 'تم حل الشكوى';

      case 'in_progress':
        return 'قيد المعالجة';

      case 'rejected':
        return 'تم رفض الشكوى';

      case 'new':
      default:
        return 'تم إنشاء الشكوى';
    }
  }
}
