import 'package:flutter/material.dart';

/// Body wrapper for a short, centred form.
///
/// Solves the overflow every auth screen hit: a `Column` with
/// `MainAxisAlignment.center` sitting directly in `Scaffold.body` is centred
/// but cannot scroll, so the moment the keyboard halves the available height
/// the content overflows and Flutter paints the yellow stripes.
///
/// This keeps both behaviours: centred while the content fits, scrollable the
/// instant it does not. `maxWidth` also stops the fields stretching across a
/// tablet or the web dashboard.
class CenteredFormBody extends StatelessWidget {
  const CenteredFormBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.maxWidth = 440,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: padding,
            // Reserve at least the viewport height so `center` still centres
            // when the content is short; IntrinsicHeight lets the Column size
            // itself normally when it is taller.
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight -
                    padding.vertical.clamp(0, constraints.maxHeight),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
