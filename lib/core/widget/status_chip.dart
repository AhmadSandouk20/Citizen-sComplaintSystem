import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localization/local_keys.dart';
import '../theme/colors.dart';

/// Tone drives both the colour and the meaning; nothing here is decorative.
enum _Tone { info, warning, success, danger, neutral }

/// A complaint's status, as a chip.
///
/// Status is encoded twice — colour and a leading dot — so it survives
/// greyscale printing and colour-blind viewers, who are exactly the people a
/// four-state colour code fails.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.dense = false});

  /// Raw API value: new · in_progress · resolved · rejected.
  final String status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (status.toLowerCase().trim()) {
      'new' => (LocaleKeys.statusNew.tr(), _Tone.info),
      'in_progress' => (LocaleKeys.statusInProgress.tr(), _Tone.warning),
      'resolved' => (LocaleKeys.statusResolved.tr(), _Tone.success),
      'rejected' => (LocaleKeys.statusRejected.tr(), _Tone.danger),
      _ => (status, _Tone.neutral),
    };
    return _Pill(label: label, tone: tone, dense: dense, showDot: true);
  }
}

/// A complaint's priority, as a chip.
class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority, this.dense = false});

  /// Raw API value: low · medium · high.
  final String priority;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final (label, tone, icon) = switch (priority.toLowerCase().trim()) {
      'low' => (LocaleKeys.priorityLow.tr(), _Tone.success, Icons.arrow_downward),
      'medium' => (
        LocaleKeys.priorityMedium.tr(),
        _Tone.warning,
        Icons.remove,
      ),
      'high' => (LocaleKeys.priorityHigh.tr(), _Tone.danger, Icons.arrow_upward),
      _ => (priority, _Tone.neutral, Icons.remove),
    };
    return _Pill(label: label, tone: tone, dense: dense, icon: icon);
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.tone,
    required this.dense,
    this.icon,
    this.showDot = false,
  });

  final String label;
  final _Tone tone;
  final bool dense;
  final IconData? icon;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    final (fg, bg) = switch (tone) {
      _Tone.info => isLight
          ? (AppColors.onInfoContainer, AppColors.infoContainer)
          : (AppColors.darkInfo, AppColors.darkInfo.withValues(alpha: 0.16)),
      _Tone.warning => isLight
          ? (AppColors.onWarningContainer, AppColors.warningContainer)
          : (
              AppColors.darkWarning,
              AppColors.darkWarning.withValues(alpha: 0.16),
            ),
      _Tone.success => isLight
          ? (AppColors.onSuccessContainer, AppColors.successContainer)
          : (
              AppColors.darkSuccess,
              AppColors.darkSuccess.withValues(alpha: 0.16),
            ),
      _Tone.danger => isLight
          ? (AppColors.onErrorContainer, AppColors.errorContainer)
          : (AppColors.darkError, AppColors.darkError.withValues(alpha: 0.16)),
      _Tone.neutral => (
        scheme.onSurfaceVariant,
        scheme.surfaceContainerHighest,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            Icon(icon, size: dense ? 12 : 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: (dense ? theme.textTheme.labelSmall : theme.textTheme.labelMedium)
                ?.copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
