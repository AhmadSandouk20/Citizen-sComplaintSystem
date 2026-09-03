import 'package:flutter/material.dart';

import 'app_button.dart';

/// Shown when a list has loaded and has nothing in it.
///
/// Deliberately quiet: a muted icon disc rather than a large grey glyph, so
/// an empty screen reads as "nothing yet" rather than as an error.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.inbox_outlined,
    this.buttonText,
    this.onAction,
  });

  final String message;
  final String? subMessage;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 76,
                width: 76,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 34, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              if (subMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  subMessage!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              if (onAction != null && buttonText != null) ...[
                const SizedBox(height: 24),
                AppButton(
                  label: buttonText!,
                  onPressed: onAction,
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.small,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
