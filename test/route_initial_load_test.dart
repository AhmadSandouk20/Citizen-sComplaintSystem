import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A cubit that fetches on demand only shows data if something asks it to.
///
/// Screens that load in `initState` are fine; stateless screens depend on the
/// route creating the cubit with a cascade (`..load()`). That is easy to drop
/// when wiring providers — it is exactly how the users and system-performance
/// screens ended up permanently empty — so it is asserted here rather than
/// left to manual testing.
void main() {
  final route = File('lib/core/router/route.dart').readAsStringSync();

  /// cubit name -> the call that must appear where the route creates it
  const mustLoad = <String, String>{
    'UserManagementCubit': 'loadUsers()',
    'PerformanceCubit': 'load()',
    'AdminUserDetailCubit': 'load(',
  };

  mustLoad.forEach((cubit, call) {
    test('$cubit is loaded where the route creates it', () {
      final creation = RegExp(
        r'create:\s*\(_\)\s*=>\s*getIt<' + cubit + r'>\(\)([^,]*)',
      ).allMatches(route);

      expect(
        creation,
        isNotEmpty,
        reason: '$cubit is never created in the router',
      );

      // At least one creation site must kick off the fetch. (The user-detail
      // route also provides UserManagementCubit purely to refresh the list
      // after a save, so not every site needs it.)
      expect(
        creation.any((m) => (m.group(1) ?? '').contains(call)),
        isTrue,
        reason:
            'no creation of $cubit calls $call — the screen will render empty',
      );
    });
  });
}
