import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/models/user_role_enum.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/screens_stub/screens_stubs.dart';
import '../widget/adaptive_shell_builder.dart';
import 'navigation_key.dart';
import 'route_paths.dart';

GoRouter routes = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutePaths.login,
  routes: [
    /*
    GoRoute(
      path: RoutePaths.splashScreen,
      builder: (context, state) => SplashScreen(),
    ),
    */

    // --------------------AUTH--------------------
    GoRoute(path: RoutePaths.login, builder: (context, state) => LoginScreen()),
    /*
    GoRoute(
      path: RoutePaths.signup,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: RoutePaths.aLocked,
      builder: (context, state) => AccountLockedScreen(),
    ),
    GoRoute(
      path: RoutePaths.verifyOTP,
      builder: (context, state) => VerifyOtpScreen(),
    ),
    GoRoute(
      path: RoutePaths.resendOTP,
      builder: (context, state) => ResendOtpScreen(),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RoutePaths.resetPassword,
      builder: (context, state) => ResetPasswordScreen(),
    ),
    GoRoute(
      path: RoutePaths.cTrackEntry,
      builder: (context, state) => TrackEntryScreen(),
    ),
    GoRoute(
      path: RoutePaths.cTrackCode,
      builder: (context, state) =>
          TrackComplaintScreen(code: state.pathParameters['code']!),
    ),
    */
    // ----------------------------------------
    ShellRoute(
      builder: (context, state, child) {
        final state = context.read<AuthCubit>().state;
        UserModel? user;
        if (state is LoginSuccessState) {
          user = state.user;
        }
        final role = user?.role ?? UserRole.citizen;

        return AdaptiveShellBuilder(currentChild: child, role: role);
      },
      routes: [
        /*
        GoRoute(
          path: RoutePaths.submissionSuccess,
          builder: (context, state) => SubmissionSuccessScreen(),
        ),
        */
        // All logged-in users)
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => ProfileScreen(),
        ), // GET/PUT/DELETE /api/auth/profile
        GoRoute(
          path: RoutePaths.notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        // ----------------------------------------
        // CITIZEN ( /api/complaints)
        // ----------------------------------------
        GoRoute(
          path: RoutePaths.cComplaints,
          builder: (context, state) => CitizenComplaintListScreen(),
        ), // GET /api/complaints
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
          builder: (context, state) => SubmitComplaintScreen(),
        ), // POST /api/complaints (multipart)
        /*
        GoRoute(
          path: RoutePaths.cUpdate,
          builder: (context, state) => UpdateComplaintScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.cAttachments,
          builder: (context, state) => UploadAttachmentsScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        */
        // ----------------------------------------
        // Staff ( /api/agency/ )
        // ----------------------------------------
        GoRoute(
          path: RoutePaths.sComplaints,
          builder: (context, state) => StaffComplainsQueueScreen(),
        ), // GET /api/agency/complaints
        GoRoute(
          path: RoutePaths.sComplaint,
          builder: (context, state) => StaffComplaintDetailScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        // GoRoute(
        //   path: RoutePaths.staffRequestInfo,
        //   builder: (context, state) => StaffRequestInfoScreen(
        //     complaintId: int.parse(state.pathParameters['id']!),
        //   ),
        // ), // POST /api/agency/complaints/{id}/request-info
        /*
        GoRoute(
          path: RoutePaths.sComplaint,
          builder: (context, state) => StaffComplaintDetailScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.updateComplaint,
          builder: (context, state) => StaffUpdateComplaintScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.complaintLock,
          builder: (context, state) => StaffLockComplaintScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.complaintUnlock,
          builder: (context, state) => StaffUnlockComplaintScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.complaintRevisions,
          builder: (context, state) => StaffRevisionsScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.complaintStatusHistory,
          builder: (context, state) => StaffStatusHistoryScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        */
        // ----------------------------------------
        // ADMIN ( /api/admin, /api/statistics, /api/agencies)
        // ----------------------------------------
        GoRoute(
          path: RoutePaths.statistics,
          builder: (context, state) => AdminStatisticsScreen(),
        ), // GET /api/statistics/overall, /by-agency, /by-date, /performance
        GoRoute(
          path: RoutePaths.users,
          builder: (context, state) => AdminUsersListScreen(),
        ), // GET /api/admin/users
        // GoRoute(
        //   path: RoutePaths.addUser,
        //   builder: (context, state) => AdminUserFormScreen(),
        // ), // POST /api/admin/users
        // GoRoute(
        //   path: RoutePaths.updateUser,
        //   builder: (context, state) => AdminUserFormScreen(
        //     userId: int.parse(state.pathParameters['id']!),
        //   ),
        // ), // PUT /api/admin/users/{id}
        /*
        GoRoute(
          path: RoutePaths.performance,
          builder: (context, state) => SystemPerformanceScreen(),
        ),
        */
        /*
        GoRoute(
          path: RoutePaths.user,
          builder: (context, state) => AdminUserDetailScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        */
        // GoRoute(
        //   path: RoutePaths.agencies,
        //   builder: (context, state) => AdminAgenciesListScreen(),
        // ), // GET /api/agencies, POST /api/agencies
        // Agency form screens are owned by another teammate and are not in this copy yet.
        // GoRoute(
        //   path: RoutePaths.addAgency,
        //   builder: (context, state) => AdminAgencyFormScreen(),
        // ),
        // GoRoute(
        //   path: RoutePaths.updateAgency,
        //   builder: (context, state) =>
        //       AdminAgencyFormScreen(id: int.parse(state.pathParameters['id']!)),
        // ),
        // GoRoute(
        //   path: RoutePaths.agency,
        //   builder: (context, state) => AdminAgencyDetailsScreen(
        //     id: int.parse(state.pathParameters['id']!),
        //   ),
        // ), // GET /api/agencies/{id}
        /*
        GoRoute(
          path: RoutePaths.agencyUsers,
          builder: (context, state) => AdminAgencyUsersListScreen(
            agencyId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: RoutePaths.agencyUser,
          builder: (context, state) => AdminAgencyUserDetailScreen(
            agencyId: int.parse(state.pathParameters['id']!),
            userId: int.parse(state.pathParameters['userId']!),
          ),
        ),
        */
        GoRoute(
          path: RoutePaths.reports,
          builder: (context, state) => AdminReportsScreen(),
        ), // GET /api/reports/complaints/csv, /pdf, /statistics/csv
      ],
    ),
  ],
  redirect: (context, state) => _redirectContent(context, state),
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
  // Auth Guard
  final isAuthRoute =
      location == RoutePaths.login ||
      location == RoutePaths.signup ||
      location == RoutePaths.verifyOTP ||
      location == RoutePaths.resendOTP;

  if (user == null && !isAuthRoute && !isPublicRoute) return RoutePaths.login;
  if (user != null && isAuthRoute) return _getHomePath(user.role);

  // Role Guard
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
