import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/local_keys.dart';
import '../../core/router/route_paths.dart';

/// Placeholders for screens whose tracks have not landed yet.
///
/// Each one is a real route target so navigation, deep links and the shell can
/// be exercised end to end. Delete a stub the moment its owner pushes the real
/// screen â€” do not build features in here.
///
/// Still owned elsewhere:
///   Ibrahim â€” citizen complaints (list, submit, details, track)
///   Leen    â€” staff workspace (queue, details, lock, revisions)
///   Ahmad   â€” agencies and agency staff
///   Joly    â€” statistics, reports, users
class _Stub extends StatelessWidget {
  const _Stub(this.title, {this.detail, this.icon = Icons.construction_outlined});

  final String title;
  final String? detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.notImplementedYet.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (detail != null) ...[
                const SizedBox(height: 6),
                Text(detail!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------- CITIZEN ------------------------------------

class CitizenHomeScreen extends StatelessWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.ccs.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _QuickActionCard(
              title: LocaleKeys.submit.tr(),
              icon: Icons.add_circle_outline,
              onTap: () => context.go(RoutePaths.submit),
            ),
            _QuickActionCard(
              title: LocaleKeys.track.tr(),
              icon: Icons.search,
              onTap: () => context.go(RoutePaths.cTrackEntry),
            ),
            _QuickActionCard(
              title: LocaleKeys.complaints.tr(),
              icon: Icons.list_alt_outlined,
              onTap: () => context.go(RoutePaths.cComplaints),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

class CitizenComplaintListScreen extends StatelessWidget {
  const CitizenComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _Stub(LocaleKeys.complaints.tr(), detail: 'GET /api/complaints');
}

class SubmitComplaintScreen extends StatelessWidget {
  const SubmitComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _Stub(LocaleKeys.submit.tr(), detail: 'POST /api/complaints');
}

class CitizenComplaintDetailScreen extends StatelessWidget {
  const CitizenComplaintDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) => _Stub(
    LocaleKeys.complaints.tr(),
    detail: 'GET /api/complaints/$id',
  );
}

class TrackEntryScreen extends StatelessWidget {
  const TrackEntryScreen({super.key});

  @override
  Widget build(BuildContext context) => _Stub(
    LocaleKeys.track.tr(),
    detail: 'GET /api/complaints/track/{reference_code}',
    icon: Icons.search,
  );
}

class TrackComplaintScreen extends StatelessWidget {
  const TrackComplaintScreen({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => _Stub(
    LocaleKeys.track.tr(),
    detail: 'GET /api/complaints/track/$code',
    icon: Icons.search,
  );
}

// -------------------------------- STAFF -------------------------------------

class StaffComplainsQueueScreen extends StatelessWidget {
  const StaffComplainsQueueScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _Stub(LocaleKeys.queue.tr(), detail: 'GET /api/agency/complaints');
}

class StaffComplaintDetailScreen extends StatelessWidget {
  const StaffComplaintDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) => _Stub(
    LocaleKeys.queue.tr(),
    detail: 'GET /api/agency/complaints/$id',
  );
}

// -------------------------------- ADMIN -------------------------------------
//
// Every admin screen now has a real implementation:
//   agencies, agency staff, users  -> features/admin/
//   statistics, system performance -> features/admin_analytics/
//   reports                        -> features/admin_reports/
