import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/features/admin_analytics/domain/repositories/statistics_repository.dart';
import 'package:final_flutter/features/admin_analytics/presentation/bloc/performance_cubit.dart';
import 'package:final_flutter/features/admin_analytics/presentation/screens/admin_statistics_screen.dart';
import 'package:final_flutter/features/admin_analytics/presentation/screens/system_performance_screen.dart';
import 'package:final_flutter/features/admin_reports/presentation/screens/admin_reports_screen.dart';
import 'package:final_flutter/features/admin_users/domain/repositories/admin_users_repository.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_user_detail_cubit.dart';
import 'package:final_flutter/features/admin_users/presentation/screens/admin_user_detail_screen.dart';
import 'package:final_flutter/features/admin_users/presentation/screens/admin_users_list_screen.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:final_flutter/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:final_flutter/features/screens_stub/screens_stubs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widget/adaptive_shell_builder.dart';
import 'navigation_key.dart';
import 'route_paths.dart';

GoRouter routes = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutePaths.login,
  routes: [
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final authState = context.read<AuthCubit>().state;
        UserModel? user;
        if (authState is LoginSuccessState) {
          user = authState.user;
        }
        final role = user?.role ?? UserRole.citizen;
        return AdaptiveShellBuilder(currentChild: child, role: role);
      },
      routes: [
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: RoutePaths.notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: RoutePaths.cComplaints,
          builder: (context, state) => const CitizenComplaintListScreen(),
        ),
        GoRoute(
          path: RoutePaths.cHome,
          builder: (context, state) => const CitizenHomeScreen(),
        ),
        GoRoute(
          path: RoutePaths.cComplaintDetails,
          builder: (context, state) => CitizenComplaintDetailScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.submit,
          builder: (context, state) => const SubmitComplaintScreen(),
        ),
        GoRoute(
          path: RoutePaths.sComplaints,
          builder: (context, state) => const StaffComplainsQueueScreen(),
        ),
        GoRoute(
          path: RoutePaths.sComplaint,
          builder: (context, state) => StaffComplaintDetailScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.statistics,
          builder: (context, state) => const AdminStatisticsScreen(),
        ),
        GoRoute(
          path: RoutePaths.performance,
          builder: (context, state) => BlocProvider(
            create: (_) =>
                PerformanceCubit(getIt<StatisticsRepository>())..load(),
            child: const SystemPerformanceScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.users,
          builder: (context, state) => const AdminUsersListScreen(),
        ),
        GoRoute(
          path: RoutePaths.user,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return BlocProvider(
              create: (_) =>
                  AdminUserDetailCubit(getIt<AdminUsersRepository>())..load(id),
              child: AdminUserDetailScreen(id: id),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.reports,
          builder: (context, state) => const AdminReportsScreen(),
        ),
      ],
    ),
  ],
  redirect: _redirectContent,
);

String _getHomePath(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return RoutePaths.statistics;
    case UserRole.staff:
      return RoutePaths.sComplaints;
    case UserRole.citizen:
      return RoutePaths.cHome;
  }
}

String? _redirectContent(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthCubit>().state;
  UserModel? user;
  if (authState is LoginSuccessState) {
    user = authState.user;
  }

  final location = state.matchedLocation;
  final isPublicRoute =
      location == RoutePaths.cTrackEntry ||
      location == RoutePaths.cTrackCode ||
      location == RoutePaths.aLocked ||
      location == RoutePaths.splashScreen;
  final isAuthRoute =
      location == RoutePaths.login ||
      location == RoutePaths.signup ||
      location == RoutePaths.verifyOTP ||
      location == RoutePaths.resendOTP;

  if (user == null && !isAuthRoute && !isPublicRoute) return RoutePaths.login;
  if (user != null && isAuthRoute) return _getHomePath(user.role);

  if (user != null) {
    final isAdminRoute = location.startsWith('/admin');
    final isStaffRoute = location.startsWith('/staff');

    if (user.role == UserRole.citizen && (isStaffRoute || isAdminRoute)) {
      return RoutePaths.cHome;
    }
    if (user.role == UserRole.staff && isAdminRoute) {
      return RoutePaths.sComplaints;
    }
  }

  if (user != null && location == '/') {
    return _getHomePath(user.role);
  }

  return null;
}
