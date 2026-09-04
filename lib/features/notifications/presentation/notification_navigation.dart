import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/router/navigation_key.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:go_router/go_router.dart';

/// Where a notification points, given the role of the signed-in user.
String notificationRoute({int? complaintId}) {
  if (complaintId == null) return RoutePaths.notifications;

  final role = getIt<AuthCubit>().user?.role ?? UserRole.citizen;
  switch (role) {
    case UserRole.staff:
      return RoutePaths.sComplaintPath(complaintId);
    case UserRole.admin:
    case UserRole.citizen:
      return RoutePaths.cComplaintDetailsPath(complaintId);
  }
}

/// Entry point for a tapped *push* notification. The app may be anywhere, or
/// cold-starting with no stack at all, so this replaces the stack. A tap inside
/// the notifications list pushes instead, so that back returns to the list.
void openFromNotification({int? complaintId}) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  context.go(notificationRoute(complaintId: complaintId));
}

int? complaintIdFromData(Map<String, dynamic> data) {
  final raw = data['complaint_id'] ?? data['complaintId'];
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw);
  return null;
}
