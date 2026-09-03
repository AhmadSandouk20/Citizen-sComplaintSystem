import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserRole.fromApi', () {
    test('maps the three backend values', () {
      expect(UserRole.fromApi('admin'), UserRole.admin);
      expect(UserRole.fromApi('staff'), UserRole.staff);
      expect(UserRole.fromApi('citizen'), UserRole.citizen);
    });

    test('is case and whitespace tolerant', () {
      expect(UserRole.fromApi(' Admin '), UserRole.admin);
    });

    test('falls back to the least privileged role', () {
      expect(UserRole.fromApi(null), UserRole.citizen);
      expect(UserRole.fromApi('superuser'), UserRole.citizen);
    });

    test('admins reach the agency workspace, citizens do not', () {
      expect(UserRole.admin.canAccessAgencyWorkspace, isTrue);
      expect(UserRole.staff.canAccessAgencyWorkspace, isTrue);
      expect(UserRole.citizen.canAccessAgencyWorkspace, isFalse);
    });
  });

  group('UserModel.fromJson', () {
    test('reads the API shape and carries the token', () {
      final user = UserModel.fromJson(const {
        'id': 7,
        'name': 'Fatima',
        'email': 'fatima.staff@example.com',
        'type': 'staff',
        'is_active': true,
      }).copyWith(token: 'abc123');

      expect(user.id, 7);
      expect(user.role, UserRole.staff);
      expect(user.token, 'abc123');
      expect(user.isActive, isTrue);
    });

    test('survives an id arriving as a string', () {
      final user = UserModel.fromJson(const {
        'id': '42',
        'name': 'Ahmed',
        'type': 'citizen',
      }).copyWith(token: 't');

      expect(user.id, 42);
    });
  });

  group('RoutePaths', () {
    test('sends each role to its own landing route', () {
      expect(RoutePaths.homeForRole(UserRole.admin), RoutePaths.statistics);
      expect(RoutePaths.homeForRole(UserRole.staff), RoutePaths.sComplaints);
      expect(RoutePaths.homeForRole(UserRole.citizen), RoutePaths.cHome);
    });

    test('public tracking needs no session', () {
      expect(RoutePaths.isPublic(RoutePaths.cTrackEntry), isTrue);
      expect(RoutePaths.isPublic('/citizen/track/CMP-2025-00001'), isTrue);
      expect(RoutePaths.isPublic(RoutePaths.cComplaints), isFalse);
    });

    test('builds parameterised paths', () {
      expect(RoutePaths.sComplaintPath(12), '/staff/complaints/12');
      expect(RoutePaths.updateAgencyPath(3), '/admin/agencies/3/edit');
    });
  });

  group('DioClient.mapError', () {
    test('passes an AppException through untouched', () {
      final mapped = DioClient.mapError(
        DioClient.mapError(Exception('boom')),
      );
      expect(mapped.message, contains('boom'));
    });
  });
}
