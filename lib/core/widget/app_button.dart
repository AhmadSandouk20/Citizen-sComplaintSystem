import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

enum AppButtonSize { small, medium, large }

/// The app's button.
///
/// Styling comes from the theme; this widget only decides which Material
/// button to use and how to lay out the icon, label and loading state.
///
/// `isFullWidth` defaults to false. A button stretches because the screen
/// wants it to, not by default — full-bleed buttons in a row or a dialog look
/// like a mistake.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  double get _height => switch (size) {
    AppButtonSize.small => 40,
    AppButtonSize.medium => 50,
    AppButtonSize.large => 56,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null && !isLoading;

    // The spinner inherits the button's own foreground, so it stays legible
    // on every variant instead of being hardcoded white.
    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: switch (variant) {
                AppButtonVariant.primary => scheme.onPrimary,
                AppButtonVariant.secondary => scheme.onSecondary,
                AppButtonVariant.danger => scheme.onError,
                _ => scheme.primary,
              },
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == AppButtonSize.small ? 18 : 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    final minSize = Size(isFullWidth ? double.infinity : 0, _height);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(minimumSize: minSize),
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          minimumSize: minSize,
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
        ),
        child: child,
      ),
      AppButtonVariant.danger => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          minimumSize: minSize,
          backgroundColor: scheme.error,
          foregroundColor: scheme.onError,
        ),
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(minimumSize: minSize),
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(minimumSize: minSize),
        child: child,
      ),
    };

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
