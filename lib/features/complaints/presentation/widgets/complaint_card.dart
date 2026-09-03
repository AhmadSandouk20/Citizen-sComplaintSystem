import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widget/status_chip.dart';
import '../../domain/entities/complaint_entity.dart';

/// One complaint in a list.
///
/// The old card stacked five icon+label rows of equal weight, so nothing read
/// first. This version has a clear hierarchy: title, then the metadata that
/// distinguishes one complaint from another (agency, date, attachments) as a
/// single quiet footer line, with status and priority as chips.
class ComplaintCard extends StatelessWidget {
  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  final ComplaintEntity complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 10),
                  StatusChip(status: complaint.status, dense: true),
                ],
              ),

              const SizedBox(height: 10),

              // The reference code is what a citizen reads out on the phone,
              // so it gets monospace-ish emphasis rather than being one more
              // grey row.
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 15,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    complaint.referenceCode,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.primary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  PriorityChip(priority: complaint.priority, dense: true),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: scheme.outline),
              const SizedBox(height: 10),

              // One quiet metadata line instead of four stacked rows.
              DefaultTextStyle.merge(
                style: theme.textTheme.bodySmall!,
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_outlined,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        complaint.agencyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (complaint.attachments.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.attach_file,
                        size: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Text('${complaint.attachments.length}'),
                    ],
                    if (complaint.createdAt != null) ...[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(
                          'd MMM y',
                          context.locale.languageCode,
                        ).format(complaint.createdAt!.toLocal()),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
