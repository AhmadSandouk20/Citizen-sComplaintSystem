import 'package:flutter/material.dart';

import '../../domain/entities/complaint_status_history_entity.dart';

class StatusHistorySection extends StatelessWidget {
  final List<ComplaintStatusHistoryEntity> history;

  const StatusHistorySection({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history),
                SizedBox(width: 8),
                Text(
                  'سجل الحالات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...history.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(Icons.circle, size: 10),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.oldStatus == null
                                ? item.newStatus
                                : '${item.oldStatus} → ${item.newStatus}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('بواسطة: ${item.changedByName}'),
                          if (item.note != null &&
                              item.note!.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.note!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          if (item.changedAt != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(item.changedAt!),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
