import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_flutter/features/screens_stub/screens_stubs.dart';

void main() {
  testWidgets('Citizen home screen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CitizenHomeScreen()));

    expect(find.text('Citizen Dashboard'), findsOneWidget);

    expect(find.text('تقديم شكوى'), findsOneWidget);

    expect(find.text('شكاواي'), findsOneWidget);

    expect(find.text('تتبع شكوى'), findsOneWidget);

    expect(find.text('الملف الشخصي'), findsOneWidget);
  });
}
