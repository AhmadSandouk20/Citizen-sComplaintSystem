import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/complaint_revision_entity.dart';

class RevisionsSection extends StatelessWidget {
  final List<ComplaintRevisionEntity> revisions;

  const RevisionsSection({
    super.key,
    required this.revisions,
  });

  @override
  Widget build(BuildContext context) {
    if (revisions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.compare_arrows_outlined),
                SizedBox(width: 8),
                Text(
                  LocaleKeys.revisions.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...List.generate(
              revisions.length,
              (index) {
                final current = revisions[index];

                // الـ API يرجع الأحدث أولاً:
                // v3, v2, v1
                //
                // لذلك النسخة السابقة للـ current
                // موجودة في index + 1.
                final previous = index + 1 < revisions.length
                    ? revisions[index + 1]
                    : null;

                return _RevisionCard(
                  current: current,
                  previous: previous,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  final ComplaintRevisionEntity current;
  final ComplaintRevisionEntity? previous;

  const _RevisionCard({
    required this.current,
    required this.previous,
  });

  @override
  Widget build(BuildContext context) {
    final changes = _buildChanges();

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(
        bottom: 16,
      ),
      title: Text(
        LocaleKeys.versionNumber.tr(args: [current.versionNumber.toString()]),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The model falls back to an empty name when the API omits the
          // author, and "By: " on its own reads worse than no line at all.
          if (current.changedByName.trim().isNotEmpty)
            Text(
              LocaleKeys.changedBy.tr(args: [current.changedByName]),
            ),
          if (current.changedAt != null)
            Text(
              _formatDate(current.changedAt!),
            ),
        ],
      ),
      children: [
        if (previous == null)
          _InitialRevisionView(
            revision: current,
          )
        else if (changes.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Text(
              LocaleKeys.noVisibleChanges.tr(),
            ),
          )
        else
          ...changes.map(
            (change) => _ChangeCard(
              change: change,
            ),
          ),
      ],
    );
  }

  List<_RevisionChange> _buildChanges() {
    if (previous == null) {
      return const [];
    }

    final changes = <_RevisionChange>[];

    _addChange(
      changes,
      label: LocaleKeys.complaintTitle.tr(),
      before: previous!.data['title'],
      after: current.data['title'],
    );

    _addChange(
      changes,
      label: LocaleKeys.description.tr(),
      before: previous!.data['description'],
      after: current.data['description'],
    );

    _addChange(
      changes,
      label: LocaleKeys.location.tr(),
      before: previous!.data['location_text'],
      after: current.data['location_text'],
    );

    _addChange(
      changes,
      label: LocaleKeys.status.tr(),
      before: previous!.data['status'],
      after: current.data['status'],
    );

    _addChange(
      changes,
      label: LocaleKeys.priority.tr(),
      before: previous!.data['priority'],
      after: current.data['priority'],
    );

    return changes;
  }

  void _addChange(
    List<_RevisionChange> changes, {
    required String label,
    required dynamic before,
    required dynamic after,
  }) {
    final beforeValue = before?.toString() ?? '';
    final afterValue = after?.toString() ?? '';

    if (beforeValue != afterValue) {
      changes.add(
        _RevisionChange(
          label: label,
          before: beforeValue,
          after: afterValue,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    return '${local.year}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}

class _ChangeCard extends StatelessWidget {
  final _RevisionChange change;

  const _ChangeCard({
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context)
              .dividerColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            change.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          _ValueRow(
            label: LocaleKeys.before.tr(),
            value: change.before,
          ),

          const SizedBox(height: 8),

          _ValueRow(
            label: LocaleKeys.after.tr(),
            value: change.after,
          ),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _ValueRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
          ),
        ),
      ],
    );
  }
}

class _InitialRevisionView extends StatelessWidget {
  final ComplaintRevisionEntity revision;

  const _InitialRevisionView({
    required this.revision,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.firstVersion.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _InitialRow(
            label: LocaleKeys.complaintTitle.tr(),
            value: revision.title,
          ),
          _InitialRow(
            label: LocaleKeys.status.tr(),
            value: revision.status,
          ),
          _InitialRow(
            label: LocaleKeys.priority.tr(),
            value: revision.priority,
          ),
        ],
      ),
    );
  }
}

class _InitialRow extends StatelessWidget {
  final String label;
  final String value;

  const _InitialRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class _RevisionChange {
  final String label;
  final String before;
  final String after;

  const _RevisionChange({
    required this.label,
    required this.before,
    required this.after,
  });
}