import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/models/user_role_enum.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/screens_stub/screens_stubs.dart' hide LoginScreen;
import '../../features/auth/presentation/login_screen.dart';
import '../widget/adaptive_shell_builder.dart';
import 'navigation_key.dart';
import 'route_paths.dart';

UserRole _stringToUserRole(String type) {
  switch (type) {
    case 'admin':
      return UserRole.admin;
    case 'staff':
      return UserRole.staff;
    case 'citizen':
      return UserRole.citizen;
    default:
      return UserRole.citizen;
  }
}

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

GoRouter routes = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutePaths.login,
  routes: [
    GoRoute(path: RoutePaths.login, builder: (context, state) => LoginScreen()),

    ShellRoute(
      builder: (context, state, child) {
        final authState = context.read<AuthCubit>().state;
        UserModel? user;
        if (authState is LoginSuccessState) {
          user = authState.user;
        }
        final role = user != null ? _stringToUserRole(user.type) : UserRole.citizen;
        return AdaptiveShellBuilder(currentChild: child, role: role);
      },
      routes: [
        GoRoute(path: RoutePaths.profile, builder: (context, state) => ProfileScreen()),

        GoRoute(path: RoutePaths.cComplaints, builder: (context, state) => CitizenComplaintListScreen()),
        GoRoute(path: RoutePaths.cHome, builder: (context, state) => const CitizenHomeScreen()),
        GoRoute(path: RoutePaths.submit, builder: (context, state) => SubmitComplaintScreen()),

        GoRoute(path: RoutePaths.sComplaints, builder: (context, state) => StaffComplainsQueueScreen()),

        GoRoute(path: RoutePaths.statistics, builder: (context, state) => AdminStatisticsScreen()),
        GoRoute(path: RoutePaths.users, builder: (context, state) => AdminUsersListScreen()),
        // GoRoute(
        //   path: RoutePaths.addAgency,
        //   builder: (context, state) => AdminAgencyFormScreen(),
        // ),
        // GoRoute(
        //   path: RoutePaths.updateAgency,
        //   builder: (context, state) =>
        //       AdminAgencyFormScreen(id: int.parse(state.pathParameters['id']!)),
        // ),
        GoRoute(path: RoutePaths.reports, builder: (context, state) => AdminReportsScreen()),
      ],
    ),
  ],
  redirect: (context, state) => _redirectContent(context, state),
);

_redirectContent(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthCubit>().state;
  UserModel? user;
  if (authState is LoginSuccessState) {
    user = authState.user;
  }

  final location = state.matchedLocation;
  final bool isPublicRoute =
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

  if (user != null && isAuthRoute) {
    return _getHomePath(_stringToUserRole(user.type));
  }

  if (user != null) {
    final isAdminRoute = location.startsWith('/admin');
    final isStaffRoute = location.startsWith('/staff');
    final role = _stringToUserRole(user.type);

    if (role == UserRole.citizen && (isStaffRoute || isAdminRoute)) {
      return RoutePaths.cHome;
    }
    if (role == UserRole.staff && isAdminRoute) {
      return RoutePaths.sComplaints;
    }
  }

  if (user != null && location == '/') {
    return _getHomePath(_stringToUserRole(user.type));
  }

  return null;
}
