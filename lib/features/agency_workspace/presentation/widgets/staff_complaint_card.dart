import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'package:flutter/material.dart';

import '../../../../core/widget/status_chip.dart';
import '../../domain/entities/staff_complaint_entity.dart';

class StaffComplaintCard extends StatelessWidget {
  final StaffComplaintEntity complaint;
  final VoidCallback onTap;

  const StaffComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      complaint.referenceCode,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  StatusChip(status: complaint.status, dense: true),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                complaint.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                complaint.agency.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  PriorityChip(priority: complaint.priority, dense: true),

                  const Spacer(),

                  if (complaint.isLocked)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          complaint.lockedByName ?? LocaleKeys.locked.tr(),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
