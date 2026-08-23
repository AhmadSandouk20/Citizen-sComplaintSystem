import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/router/navigation_key.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:go_router/go_router.dart';

void openFromNotification({int? complaintId}) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  if (complaintId == null) {
    context.go(RoutePaths.notifications);
    return;
  }

  final role = getIt<AuthCubit>().user?.role ?? UserRole.citizen;
  switch (role) {
    case UserRole.staff:
      context.go(RoutePaths.sComplaintPath(complaintId));
      return;
    case UserRole.admin:
    case UserRole.citizen:
      context.go(RoutePaths.cComplaintDetailsPath(complaintId));
  }
}

int? complaintIdFromData(Map<String, dynamic> data) {
  final raw = data['complaint_id'] ?? data['complaintId'];
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw);
  return null;
}
