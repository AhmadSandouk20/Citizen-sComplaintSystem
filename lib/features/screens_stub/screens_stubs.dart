import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/local_keys.dart';
import '../../core/router/route_paths.dart';
import '../auth/presentation/bloc/auth_cubit.dart';

/// Placeholders for screens whose tracks have not landed yet.
///
/// Each one is a real route target so navigation, deep links and the shell can
/// be exercised end to end. Delete a stub the moment its owner pushes the real
/// screen â€” do not build features in here.
///
/// Only the staff workspace is still outstanding (Leen): the inbox,
/// complaint details, the lock mechanism, revisions and request-info.
class _Stub extends StatelessWidget {
  const _Stub(this.title, {this.detail});

  final String title;
  final String? detail;

  static const IconData icon = Icons.construction_outlined;

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
    final theme = Theme.of(context);
    final name = context.select<AuthCubit, String>(
      (c) => c.user?.name ?? '',
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            // Greeting carries the signed-in name so the home screen feels
            // addressed to someone rather than being a menu.
            Text(LocaleKeys.welcome.tr(), style: theme.textTheme.bodyLarge),
            const SizedBox(height: 2),
            Text(
              name.isEmpty ? LocaleKeys.ccs.tr() : name,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // The primary action gets a full card of its own; the two
            // supporting actions share a row below it.
            _PrimaryAction(
              title: LocaleKeys.newComplaint.tr(),
              subtitle: LocaleKeys.submit.tr(),
              icon: Icons.add_circle_outline,
              onTap: () => context.go(RoutePaths.submit),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SecondaryAction(
                    title: LocaleKeys.myComplaintsShort.tr(),
                    icon: Icons.list_alt_outlined,
                    onTap: () => context.go(RoutePaths.cComplaints),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SecondaryAction(
                    title: LocaleKeys.track.tr(),
                    icon: Icons.search,
                    // push, not go: tracking lives outside the shell, so
                    // replacing the stack would strand the citizen there with
                    // no bottom bar and nothing to go back to.
                    onTap: () => context.push(RoutePaths.cTrackEntry),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                scheme.primary,
                Color.lerp(scheme.primary, scheme.secondary, 0.35)!,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: scheme.onPrimary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: scheme.onPrimary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: scheme.onPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: scheme.onPrimary.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Text(title, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
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
