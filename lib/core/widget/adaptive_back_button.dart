import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../router/route_paths.dart';

/// A back button that always leads somewhere.
///
/// `context.pop()` alone is not enough on the public screens: they can be
/// reached three ways — pushed from inside the app, opened with `go` (which
/// replaces the stack), or hit directly as a public deep link. In the last two
/// there is nothing to pop, and a bare back button would either do nothing or
/// throw.
///
/// So: pop when there is history, otherwise fall back to whatever "home" means
/// for the current session — the role's landing route, or the login screen for
/// a visitor tracking a complaint without an account.
class AdaptiveBackButton extends StatelessWidget {
  const AdaptiveBackButton({super.key, this.fallback});

  /// Overrides the computed destination when there is no history to pop.
  final String? fallback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (context.canPop()) {
          context.pop();
          return;
        }
        if (fallback != null) {
          context.go(fallback!);
          return;
        }
        final role = context.read<AuthCubit>().role;
        context.go(
          role == null ? RoutePaths.login : RoutePaths.homeForRole(role),
        );
      },
    );
  }
}
