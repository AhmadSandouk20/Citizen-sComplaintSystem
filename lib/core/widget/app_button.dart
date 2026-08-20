import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outlined, text }

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.variant = AppButtonVariant.primary,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget child;
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
      ],
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: variant == AppButtonVariant.primary
          ? colorScheme.primary
          : variant == AppButtonVariant.secondary
          ? colorScheme.secondary
          : null,
      foregroundColor:
          variant == AppButtonVariant.primary ||
              variant == AppButtonVariant.secondary
          ? colorScheme.onPrimary
          : null,
      minimumSize: Size(isFullWidth ? double.infinity : 0, height!),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
        child = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: content,
        );
        break;
      case AppButtonVariant.outlined:
        child = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.primary),
            minimumSize: Size(isFullWidth ? double.infinity : 0, height!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: content,
        );
        break;
      case AppButtonVariant.text:
        child = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: content,
        );
        break;
    }

    return child;
  }
}
