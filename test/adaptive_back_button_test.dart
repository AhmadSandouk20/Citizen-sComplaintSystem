import 'package:final_flutter/core/widget/adaptive_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// The tracking screens are reachable three ways; the back button has to lead
/// somewhere in all of them.
void main() {
  Widget app(GoRouter router) => MaterialApp.router(routerConfig: router);

  GoRouter buildRouter() => GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (c, s) => const Scaffold(body: Text('HOME')),
      ),
      GoRoute(
        path: '/track',
        builder: (c, s) => Scaffold(
          appBar: AppBar(
            leading: const AdaptiveBackButton(fallback: '/home'),
            title: const Text('TRACK'),
          ),
        ),
      ),
    ],
  );

  testWidgets('pops when it was pushed', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(app(router));
    expect(find.text('HOME'), findsOneWidget);

    router.push('/track');
    await tester.pumpAndSettle();
    expect(find.text('TRACK'), findsOneWidget);

    await tester.tap(find.byType(AdaptiveBackButton));
    await tester.pumpAndSettle();
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('falls back home when the stack was replaced by go', (
    tester,
  ) async {
    final router = buildRouter();
    await tester.pumpWidget(app(router));

    // `go` replaces the stack, so there is nothing to pop.
    router.go('/track');
    await tester.pumpAndSettle();
    expect(find.text('TRACK'), findsOneWidget);

    await tester.tap(find.byType(AdaptiveBackButton));
    await tester.pumpAndSettle();
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('falls back home on a cold deep link', (tester) async {
    final router = GoRouter(
      initialLocation: '/track',
      routes: [
        GoRoute(
          path: '/home',
          builder: (c, s) => const Scaffold(body: Text('HOME')),
        ),
        GoRoute(
          path: '/track',
          builder: (c, s) => Scaffold(
            appBar: AppBar(
              leading: const AdaptiveBackButton(fallback: '/home'),
              title: const Text('TRACK'),
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(app(router));
    expect(find.text('TRACK'), findsOneWidget);

    await tester.tap(find.byType(AdaptiveBackButton));
    await tester.pumpAndSettle();
    expect(find.text('HOME'), findsOneWidget);
  });
}
