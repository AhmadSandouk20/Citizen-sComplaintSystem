import 'package:final_flutter/core/widget/centered_form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reproduces the register-screen overflow: the body is squeezed to roughly
/// what is left when the soft keyboard is open.
void main() {
  /// Sizes the actual render surface, not just MediaQuery: the default test
  /// surface is 800x600, which silently overrides a MediaQuery-only size.
  Future<void> pumpAt(WidgetTester tester, Widget child, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
  }

  Widget tallForm() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 0; i < 3; i++) ...[
        const SizedBox(height: 58, child: Placeholder()),
        const SizedBox(height: 16),
      ],
      const SizedBox(height: 50, child: Placeholder()),
      const SizedBox(height: 16),
      const SizedBox(height: 48, child: Placeholder()),
    ],
  );

  testWidgets('overflows without the wrapper — the original bug', (
    tester,
  ) async {
    await pumpAt(
      tester,
      Padding(padding: const EdgeInsets.all(24), child: tallForm()),
      const Size(360, 344),
    );
    expect(
      tester.takeException(),
      isA<FlutterError>(),
      reason: 'a centred Column with no scroll view must overflow here',
    );
  });

  testWidgets('CenteredFormBody scrolls instead of overflowing', (
    tester,
  ) async {
    await pumpAt(
      tester,
      CenteredFormBody(child: tallForm()),
      const Size(360, 344),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('still centres when there is plenty of room', (tester) async {
    await pumpAt(
      tester,
      CenteredFormBody(
        child: const SizedBox(
          key: ValueKey('content'),
          height: 100,
          child: Placeholder(),
        ),
      ),
      const Size(360, 800),
    );
    expect(tester.takeException(), isNull);

    final box = tester.getRect(find.byKey(const ValueKey('content')));
    expect(
      (box.center.dy - 400).abs(),
      lessThan(2),
      reason: 'short content stays vertically centred in the 800px viewport',
    );
  });

  testWidgets('constrains width on a wide viewport', (tester) async {
    await pumpAt(
      tester,
      CenteredFormBody(
        maxWidth: 440,
        child: const SizedBox(
          key: ValueKey('content'),
          height: 100,
          child: Placeholder(),
        ),
      ),
      const Size(1400, 900),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getRect(find.byKey(const ValueKey('content'))).width,
      lessThanOrEqualTo(440),
    );
  });
}
