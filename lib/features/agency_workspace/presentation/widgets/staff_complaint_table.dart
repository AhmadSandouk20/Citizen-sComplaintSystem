import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'package:flutter/material.dart';

import '../../../../core/widget/status_chip.dart';
import '../../domain/entities/staff_complaint_entity.dart';

class StaffComplaintsTable extends StatelessWidget {
  final List<StaffComplaintEntity> complaints;
  final void Function(StaffComplaintEntity complaint) onComplaintTap;

  const StaffComplaintsTable({
    super.key,
    required this.complaints,
    required this.onComplaintTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(LocaleKeys.referenceNumber.tr())),
            DataColumn(label: Text(LocaleKeys.complaintTitle.tr())),
            DataColumn(label: Text(LocaleKeys.agency.tr())),
            DataColumn(label: Text(LocaleKeys.status.tr())),
            DataColumn(label: Text(LocaleKeys.priority.tr())),
            DataColumn(label: Text(LocaleKeys.lockState.tr())),
            DataColumn(label: Text(LocaleKeys.view.tr())),
          ],
          rows: complaints.map((complaint) {
            return DataRow(
              cells: [
                DataCell(
                  Text(complaint.referenceCode),
                  onTap: () {
                    onComplaintTap(complaint);
                  },
                ),

                DataCell(
                  SizedBox(
                    width: 220,
                    child: Text(
                      complaint.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () {
                    onComplaintTap(complaint);
                  },
                ),

                DataCell(
                  SizedBox(
                    width: 180,
                    child: Text(
                      complaint.agency.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                DataCell(StatusChip(status: complaint.status, dense: true)),

                DataCell(
                  PriorityChip(priority: complaint.priority, dense: true),
                ),

                DataCell(
                  complaint.isLocked
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline, size: 16),
                            const SizedBox(width: 4),
                            Text(complaint.lockedByName ?? LocaleKeys.locked.tr()),
                          ],
                        )
                      : Text(LocaleKeys.lockAvailable.tr()),
                ),

                DataCell(
                  IconButton(
                    tooltip: LocaleKeys.viewDetails.tr(),
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      onComplaintTap(complaint);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
