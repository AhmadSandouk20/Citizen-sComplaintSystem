import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/view/agency/admin_agencies_list_screen.dart';
import '../../features/admin_analytics/presentation/screens/admin_statistics_screen.dart';
import '../../features/admin_analytics/presentation/screens/system_performance_screen.dart';
import '../../features/admin_reports/presentation/screens/admin_reports_screen.dart';
import '../../features/admin_users/presentation/screens/admin_user_detail_screen.dart';
import '../../features/admin/presentation/view/agency/admin_agency_details_screen.dart';
import '../../features/admin/presentation/view/agency/admin_agency_form_screen.dart';
import '../../features/admin/presentation/view/staff/admin_staff_management_form_screen.dart';
import '../../features/admin/presentation/view/user/user_management_screen.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/models/user_role_enum.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/delete_account_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/screens_stub/screens_stubs.dart';
import '../di/injector.dart';
import '../widget/adaptive_shell_builder.dart';
import 'navigation_key.dart';
import 'route_paths.dart';

final GoRouter routes = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutePaths.login,
  // Re-runs `redirect` whenever the session changes, so a logout or a 401
  // bounces the user out without any screen having to navigate manually.
  refreshListenable: _AuthRefreshNotifier(getIt<AuthCubit>()),
  redirect: _redirect,
  routes: [
    // -------------------------------- Public --------------------------------
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.cTrackEntry,
      builder: (context, state) => const TrackEntryScreen(),
    ),
    GoRoute(
      path: RoutePaths.cTrackCode,
      builder: (context, state) =>
          TrackComplaintScreen(code: state.pathParameters['code']!),
    ),

    // TODO(ayham): splash, signup, verify-otp, resend-otp,
    // forgot-password, reset-password, account-locked.

    // --------------------------- Authenticated shell ------------------------
    ShellRoute(
      builder: (context, state, child) {
        final role = context.select<AuthCubit, UserRole>(
          (cubit) => cubit.role ?? UserRole.citizen,
        );
        return AdaptiveShellBuilder(currentChild: child, role: role);
      },
      routes: [
        // ----- All logged-in users -----
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
            GoRoute(
              path: 'delete',
              builder: (context, state) => const DeleteAccountScreen(),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),

        // ----- Citizen (/api/complaints) -----
        GoRoute(
          path: RoutePaths.cHome,
          builder: (context, state) => const CitizenHomeScreen(),
        ),
        GoRoute(
          path: RoutePaths.cComplaints,
          builder: (context, state) => const CitizenComplaintListScreen(),
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

        // ----- Staff (/api/agency/*) — also served to admins -----
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

        // ----- Admin (/api/admin, /api/statistics, /api/agencies) -----
        GoRoute(
          path: RoutePaths.statistics,
          builder: (context, state) => const AdminStatisticsScreen(),
        ),
        GoRoute(
          path: RoutePaths.users,
          builder: (context, state) => const AdminUsersManagementScreen(),
        ),
        GoRoute(
          path: RoutePaths.user,
          builder: (context, state) => AdminUserDetailScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.agencies,
          builder: (context, state) => const AdminAgenciesListScreen(),
        ),
        GoRoute(
          path: RoutePaths.addAgency,
          builder: (context, state) => const AdminAgencyFormScreen(),
        ),
        GoRoute(
          path: RoutePaths.updateAgency,
          builder: (context, state) => AdminAgencyFormScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.agency,
          builder: (context, state) => AdminAgencyDetailsScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.addStaff,
          builder: (context, state) => AdminStaffManagementFormScreen(
            agencyId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.updateStaff,
          builder: (context, state) => AdminStaffManagementFormScreen(
            agencyId: int.parse(state.pathParameters['id']!),
            staff: state.extra as UserModel?,
          ),
        ),
        GoRoute(
          path: RoutePaths.performance,
          builder: (context, state) => const SystemPerformanceScreen(),
        ),
        GoRoute(
          path: RoutePaths.reports,
          builder: (context, state) => const AdminReportsScreen(),
        ),
      ],
    ),
  ],
);

/// Auth guard + role guard.
///
/// Returning `null` means "let the requested location through".
String? _redirect(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthCubit>().state;

  // A stored token is still being exchanged for a user — hold the current
  // location rather than flashing the login screen and redirecting back.
  if (authState is AuthRestoringState) return null;

  final UserModel? user = authState is LoginSuccessState ? authState.user : null;
  final location = state.matchedLocation;

  // --- Auth guard ---
  if (user == null) {
    if (RoutePaths.isAuthRoute(location) || RoutePaths.isPublic(location)) {
      return null;
    }
    return RoutePaths.login;
  }

  if (RoutePaths.isAuthRoute(location)) {
    return RoutePaths.homeForRole(user.role);
  }

  // --- Role guard ---
  // Mirrors the backend middleware: `role.admin` on /admin/*, and
  // `role.staff_or_admin` on the agency workspace.
  final role = user.role;

  if (RoutePaths.isAdminRoute(location) && !role.isAdmin) {
    return RoutePaths.homeForRole(role);
  }

  if (RoutePaths.isStaffRoute(location) && !role.canAccessAgencyWorkspace) {
    return RoutePaths.homeForRole(role);
  }

  return null;
}

/// Bridges the auth Cubit to go_router's `refreshListenable`.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(AuthCubit cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
