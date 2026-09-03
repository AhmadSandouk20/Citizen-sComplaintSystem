import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/features/complaints/presentation/screens/complaint_submitted_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('submissionSuccessPath', () {
    test('carries the code and id in the query string', () {
      final p = RoutePaths.submissionSuccessPath('CMP-2026-00001', id: 7);
      expect(p, startsWith(RoutePaths.submissionSuccess));
      expect(Uri.parse(p).queryParameters['code'], 'CMP-2026-00001');
      expect(Uri.parse(p).queryParameters['id'], '7');
    });

    test('omits the id when there is none', () {
      final p = RoutePaths.submissionSuccessPath('CMP-2026-00002');
      expect(Uri.parse(p).queryParameters.containsKey('id'), isFalse);
    });
  });

  testWidgets('copy button puts the reference code on the clipboard', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        startLocale: const Locale('en'),
        child: Builder(
          builder: (context) => MaterialApp.router(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: GoRouter(
              initialLocation: '/s',
              routes: [
                GoRoute(
                  path: '/s',
                  builder: (c, s) => const ComplaintSubmittedScreen(
                    referenceCode: 'CMP-2026-00042',
                    complaintId: 42,
                  ),
                ),
                GoRoute(
                  path: RoutePaths.cComplaints,
                  builder: (c, s) => const Scaffold(body: Text('LIST')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CMP-2026-00042'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.copy_rounded));
    await tester.pump();
    expect(copied, 'CMP-2026-00042');

    // Icon flips to a tick as immediate confirmation.
    expect(find.byIcon(Icons.check_rounded), findsWidgets);
  });
}
