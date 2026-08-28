import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/local_keys.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widget/app_button.dart';

/// Shown after a complaint is filed.
///
/// A real route rather than a `Navigator.pushReplacement` over the form: the
/// previous version put a screen go_router did not know about on top of
/// `/citizen/submit`, so dismissing it revealed a freshly rebuilt — and
/// therefore empty — submit form.
///
/// The reference code is the one thing the citizen must keep, so it is the
/// visual centre of the screen and is copyable in one tap.
class ComplaintSubmittedScreen extends StatefulWidget {
  const ComplaintSubmittedScreen({
    super.key,
    required this.referenceCode,
    this.complaintId,
  });

  final String referenceCode;
  final int? complaintId;

  @override
  State<ComplaintSubmittedScreen> createState() =>
      _ComplaintSubmittedScreenState();
}

class _ComplaintSubmittedScreenState extends State<ComplaintSubmittedScreen> {
  bool _copied = false;

  /// Held so it can be cancelled: leaving the screen inside the confirmation
  /// window would otherwise leave a timer running past dispose.
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.referenceCode));
    if (!mounted) return;

    // The icon itself confirms, so the snackbar is a second channel rather
    // than the only feedback.
    setState(() => _copied = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.codeCopied.tr()),
          duration: const Duration(seconds: 2),
        ),
      );

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      // No back arrow: the complaint is filed, so there is nothing to go back
      // to. Both ways out are explicit buttons below.
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 46,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    LocaleKeys.complaintSubmitted.tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.submittedHint.tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),

                  // The code panel: label, code, and a copy affordance that
                  // covers the whole panel as well as the icon.
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _copy,
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scheme.outline),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            children: [
                              Text(
                                LocaleKeys.trackingCode.tr(),
                                style: theme.textTheme.labelMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: SelectableText(
                                      widget.referenceCode,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            color: scheme.primary,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: _copy,
                                    tooltip: LocaleKeys.copyCode.tr(),
                                    visualDensity: VisualDensity.compact,
                                    style: IconButton.styleFrom(
                                      backgroundColor: _copied
                                          ? scheme.primary
                                          : scheme.surface,
                                      foregroundColor: _copied
                                          ? scheme.onPrimary
                                          : scheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: _copied
                                              ? scheme.primary
                                              : scheme.outline,
                                        ),
                                      ),
                                    ),
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      child: Icon(
                                        _copied
                                            ? Icons.check_rounded
                                            : Icons.copy_rounded,
                                        key: ValueKey(_copied),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.complaintId != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  '${LocaleKeys.complaintNumber.tr()}: '
                                  '${widget.complaintId}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  if (widget.complaintId != null) ...[
                    AppButton(
                      label: LocaleKeys.viewComplaint.tr(),
                      icon: Icons.description_outlined,
                      isFullWidth: true,
                      onPressed: () => context.go(
                        RoutePaths.cComplaintDetailsPath(widget.complaintId!),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // "Done" lands on the complaints list, where the new
                  // complaint is visible — not back on an emptied form.
                  AppButton(
                    label: LocaleKeys.done.tr(),
                    variant: AppButtonVariant.outlined,
                    isFullWidth: true,
                    onPressed: () => context.go(RoutePaths.cComplaints),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
