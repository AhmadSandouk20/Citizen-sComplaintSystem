import 'package:flutter/material.dart';

import 'app_button.dart';

/// Shown when a request failed and the user can retry.
///
/// The message is the server's, so it stays readable body text rather than
/// being coloured red — the icon already carries the severity, and red body
/// copy is hard to read at length.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.buttonText,
    this.onRetry,
    this.icon = Icons.cloud_off_outlined,
  });

  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData icon;

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
                  color: scheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 34, color: scheme.error),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                AppButton(
                  label: buttonText ?? 'Retry',
                  icon: Icons.refresh,
                  onPressed: onRetry,
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
