import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/bloc/user/user_management_cubit.dart';
import '../../features/admin/presentation/view/agency/admin_agencies_list_screen.dart';
import '../../features/admin_analytics/presentation/bloc/performance_cubit.dart';
import '../../features/admin_analytics/presentation/bloc/statistics_cubit.dart';
import '../../features/admin_reports/presentation/bloc/reports_cubit.dart';
import '../../features/admin_users/presentation/bloc/admin_user_detail_cubit.dart';
import '../../features/admin_analytics/presentation/screens/admin_statistics_screen.dart';
import '../../features/admin_analytics/presentation/screens/system_performance_screen.dart';
import '../../features/admin_reports/presentation/screens/admin_reports_screen.dart';
import '../../features/admin_users/presentation/screens/admin_user_detail_screen.dart';
import '../../features/admin/presentation/view/agency/admin_agency_details_screen.dart';
import '../../features/admin/presentation/view/agency/admin_agency_form_screen.dart';
import '../../features/admin/presentation/view/staff/admin_staff_management_form_screen.dart';
import '../../features/admin/presentation/view/user/user_management_screen.dart';
import '../../features/agencies/presentation/cubit/agency_cubit.dart';
import '../../features/attachments/presentation/cubit/attachment_cubit.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/models/user_role_enum.dart';
import '../../features/complaints/domain/entities/complaint_entity.dart';
import '../../features/complaints/presentation/cubit/complaint_details_cubit.dart';
import '../../features/complaints/presentation/cubit/create_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/my_complaints_cubit.dart';
import '../../features/complaints/presentation/cubit/status_history_cubit.dart';
import '../../features/complaints/presentation/cubit/track_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/update_complaint_cubit.dart';
import '../../features/complaints/presentation/screens/complaint_details_screen.dart';
import '../../features/complaints/presentation/screens/complaint_submitted_screen.dart';
import '../../features/complaints/presentation/screens/my_complaints_screen.dart';
import '../../features/complaints/presentation/screens/submit_complaint_screen.dart';
import '../../features/complaints/presentation/screens/track_complaint_entry_screen.dart';
import '../../features/complaints/presentation/screens/track_complaint_screen.dart';
import '../../features/complaints/presentation/screens/update_complaint_screen.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/account_locked_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
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
      builder: (context, state) => const TrackComplaintEntryScreen(),
    ),
    GoRoute(
      path: RoutePaths.cTrackCode,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<TrackComplaintCubit>(),
        child: TrackComplaintScreen(
          referenceCode: state.pathParameters['code']!,
        ),
      ),
    ),

    GoRoute(
      path: RoutePaths.signup,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RoutePaths.verifyOTP,
      // `contact` is the email or phone the code was sent to; it arrives as a
      // query parameter so a resend link can reopen this screen directly.
      builder: (context, state) =>
          OtpScreen(contact: state.uri.queryParameters['contact'] ?? ''),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RoutePaths.resetPassword,
      builder: (context, state) => ResetPasswordScreen(
        contact: state.uri.queryParameters['contact'] ?? '',
      ),
    ),
    GoRoute(
      path: RoutePaths.aLocked,
      builder: (context, state) => const AccountLockedScreen(),
    ),

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
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<MyComplaintsCubit>(),
            child: const MyComplaintsScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.cComplaintDetails,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<ComplaintDetailsCubit>()),
              BlocProvider(create: (_) => getIt<StatusHistoryCubit>()),
            ],
            child: ComplaintDetailsScreen(
              complaintId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.cUpdate,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<UpdateComplaintCubit>()),
              BlocProvider(create: (_) => getIt<AttachmentCubit>()),
              // The form lets the citizen change the target agency.
              BlocProvider(create: (_) => getIt<AgencyCubit>()),
            ],
            // Passed through `extra` by the details screen; a cold hit on this
            // URL has no complaint to edit and falls back to the list.
            child: UpdateComplaintScreen(
              complaint: state.extra as ComplaintEntity,
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.submissionSuccess,
          builder: (context, state) => ComplaintSubmittedScreen(
            referenceCode: state.uri.queryParameters['code'] ?? '',
            complaintId: int.tryParse(
              state.uri.queryParameters['id'] ?? '',
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.submit,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<CreateComplaintCubit>()),
              BlocProvider(create: (_) => getIt<AttachmentCubit>()),
              // Backs the agency picker in the first step of the form.
              BlocProvider(create: (_) => getIt<AgencyCubit>()),
            ],
            child: const SubmitComplaintScreen(),
          ),
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
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<StatisticsCubit>(),
            child: const AdminStatisticsScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.users,
          builder: (context, state) => BlocProvider(
            // The screen is stateless and has no initState, so the first
            // fetch has to be kicked off where the cubit is created.
            create: (_) => getIt<UserManagementCubit>()..loadUsers(),
            child: const AdminUsersManagementScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.user,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<AdminUserDetailCubit>()
                  ..load(int.parse(state.pathParameters['id']!)),
              ),
              // The detail screen refreshes the list after a save or delete.
              BlocProvider(create: (_) => getIt<UserManagementCubit>()),
            ],
            child: AdminUserDetailScreen(
              id: int.parse(state.pathParameters['id']!),
            ),
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
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<PerformanceCubit>()..load(),
            child: const SystemPerformanceScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.reports,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ReportsCubit>(),
            child: const AdminReportsScreen(),
          ),
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
