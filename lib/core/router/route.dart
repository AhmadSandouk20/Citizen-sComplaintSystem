import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/features/admin/presentation/view/mobile/staff/admin_staff_management_form_screen.dart';
import 'package:final_flutter/features/admin/presentation/view/mobile/user/user_management_screen.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/bloc/mobile/user/user_management_cubit.dart';
import '../../features/admin/presentation/view/mobile/agency/admin_agencies_list_screen.dart';
import '../../features/admin/presentation/view/mobile/agency/admin_agency_details_screen.dart';
import '../../features/admin/presentation/view/mobile/agency/admin_agency_form_screen.dart';
import '../../features/admin/presentation/view/web/admin_dashboard_screen.dart';
import '../../features/auth/data/models/user_type_enum.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/screens_stub/screens_stubs.dart';
import '../shared/adaptive_shell_builder.dart';
import 'navigation_key.dart';
import 'route_paths.dart';

GoRouter routes = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutePaths.profile,
  routes: [
    /*
    GoRoute(
      path: RoutePaths.splashScreen,
      builder: (context, state) => SplashScreen(),
    ),
    */

    // --------------------AUTH--------------------
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => BlocProvider.value(
        value: getIt<AuthCubit>(),
        child: const LoginScreen(),
      ),
    ),
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
        final role = user?.type ?? UserType.citizen;

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
        /*
        GoRoute(
          path: RoutePaths.notifications,
          builder: (context, state) => NotificationsScreen(),
        ),
        */
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

        /*
        GoRoute(
          path: RoutePaths.cComplaintDetails,
          builder: (context, state) => CitizenComplaintDetailScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ),
        */
        GoRoute(
          path: '/admin-dashboard',
          name: 'adminDashboard',
          builder: (context, state) => const AdminDashboardScreen(),
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
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<UserManagementCubit>()..loadUsers(),
            child: const AdminUsersManagementScreen(),
          ),
        ), // GET /api/admin/users

        GoRoute(
          path: RoutePaths.agencies,
          builder: (context, state) => AdminAgenciesListScreen(),
        ), // GET /api/agencies, POST /api/agencies
        GoRoute(
          path: RoutePaths.addAgency,
          builder: (context, state) => AdminAgencyFormScreen(),
        ), // POST /api/agencies
        GoRoute(
          path: RoutePaths.updateAgency,
          builder: (context, state) =>
              AdminAgencyFormScreen(id: int.parse(state.pathParameters['id']!)),
        ), // PUT /api/agencies/{id}
        GoRoute(
          path: RoutePaths.agency,
          builder: (context, state) => AdminAgencyDetailsScreen(
            id: int.parse(state.pathParameters['id']!),
          ),
        ), // GET /api/agencies/{id}
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
          path: RoutePaths.reports,
          builder: (context, state) => AdminReportsScreen(),
        ), // GET /api/reports/complaints/csv, /pdf, /statistics/csv
      ],
    ),
  ],
  redirect: (context, state) => _redirectContent(context, state),
);

String _getHomePath(UserType role) {
  switch (role) {
    case UserType.admin:
      return RoutePaths.statistics;
    case UserType.staff:
      return RoutePaths.sComplaints;
    case UserType.citizen:
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
  if (user != null && isAuthRoute) return _getHomePath(user.type);

  // Role Guard
  if (user != null) {
    final isAdminRoute = location.startsWith('/admin');
    final isStaffRoute = location.startsWith('/staff');

    if (user.type == UserType.citizen && (isStaffRoute || isAdminRoute)) {
      return RoutePaths.cHome;
    }
    if (user.type == UserType.staff && isAdminRoute) {
      return RoutePaths.sComplaints;
    }
  }

  if (user != null && location == '/') {
    return _getHomePath(user.type);
  }

  return null;
}
