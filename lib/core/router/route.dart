import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/agencies/presentation/cubit/agency_cubit.dart';

import '../../features/attachments/presentation/cubit/attachment_cubit.dart';

import '../../features/auth/data/models/user_role_enum.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';

import '../../features/complaints/domain/entities/complaint_entity.dart';

import '../../features/complaints/presentation/cubit/complaint_details_cubit.dart';
import '../../features/complaints/presentation/cubit/create_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/my_complaints_cubit.dart';
import '../../features/complaints/presentation/cubit/status_history_cubit.dart';
import '../../features/complaints/presentation/cubit/track_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/update_complaint_cubit.dart';

import '../../features/complaints/presentation/screens/complaint_details_screen.dart';
import '../../features/complaints/presentation/screens/my_complaints_screen.dart';
import '../../features/complaints/presentation/screens/submit_complaint_screen.dart';
import '../../features/complaints/presentation/screens/track_complaint_entry_screen.dart';
import '../../features/complaints/presentation/screens/track_complaint_screen.dart';
import '../../features/complaints/presentation/screens/update_complaint_screen.dart';

import '../../features/profile/ presentation/cubit/profile_cubit.dart';
import '../../features/profile/ presentation/screens/profile_screen.dart';

import '../../features/screens_stub/screens_stubs.dart';

import '../di/injector.dart';
import '../widget/adaptive_shell_builder.dart';
import 'navigation_key.dart';
import 'route_paths.dart';

GoRouter routes = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutePaths.cHome,

  routes: [
    // ==================================================
    // AUTH
    // ==================================================

    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),

    // ==================================================
    // PUBLIC COMPLAINT TRACKING
    // لا يحتاج تسجيل دخول
    // ==================================================
    GoRoute(
      path: RoutePaths.cTrackEntry,
      builder: (context, state) {
        return const TrackComplaintEntryScreen();
      },
    ),

    GoRoute(
      path: RoutePaths.cTrackCode,
      builder: (context, state) {
        final referenceCode = state.pathParameters['code']!;

        return BlocProvider(
          create: (_) => getIt<TrackComplaintCubit>(),
          child: TrackComplaintScreen(referenceCode: referenceCode),
        );
      },
    ),

    // ==================================================
    // AUTHENTICATED SHELL
    // ==================================================
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
        // ==================================================
        // PROFILE
        // ==================================================

        // Admin / Staff profile placeholder
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) {
            return const ProfileStubScreen();
          },
        ),

        // Citizen real profile
        GoRoute(
          path: RoutePaths.cProfile,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => getIt<ProfileCubit>(),
              child: const ProfileScreen(),
            );
          },
        ),

        // ==================================================
        // CITIZEN
        // ==================================================
        GoRoute(
          path: RoutePaths.cHome,
          builder: (context, state) => const CitizenHomeScreen(),
        ),

        // --------------------------------------------------
        // My Complaints
        // --------------------------------------------------
        GoRoute(
          path: RoutePaths.cComplaints,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => getIt<MyComplaintsCubit>(),
              child: const MyComplaintsScreen(),
            );
          },
        ),

        // --------------------------------------------------
        // Complaint Details
        // --------------------------------------------------
        GoRoute(
          path: RoutePaths.cComplaintDetails,
          builder: (context, state) {
            final complaintId = int.parse(state.pathParameters['id']!);

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<ComplaintDetailsCubit>()),
                BlocProvider(create: (_) => getIt<StatusHistoryCubit>()),
              ],
              child: ComplaintDetailsScreen(complaintId: complaintId),
            );
          },
        ),

        // --------------------------------------------------
        // Update Complaint
        // --------------------------------------------------
        GoRoute(
          path: RoutePaths.cUpdate,
          builder: (context, state) {
            final complaint = state.extra as ComplaintEntity;

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<AgencyCubit>()),
                BlocProvider(create: (_) => getIt<UpdateComplaintCubit>()),
                BlocProvider(create: (_) => getIt<AttachmentCubit>()),
              ],
              child: UpdateComplaintScreen(complaint: complaint),
            );
          },
        ),

        // --------------------------------------------------
        // Create Complaint
        // --------------------------------------------------
        GoRoute(
          path: RoutePaths.submit,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<AgencyCubit>()),
                BlocProvider(create: (_) => getIt<CreateComplaintCubit>()),
              ],
              child: const SubmitComplaintScreen(),
            );
          },
        ),

        // ==================================================
        // STAFF
        // ==================================================
        GoRoute(
          path: RoutePaths.sComplaints,
          builder: (context, state) => const StaffComplainsQueueScreen(),
        ),

        // ==================================================
        // ADMIN
        // ==================================================
        GoRoute(
          path: RoutePaths.statistics,
          builder: (context, state) => const AdminStatisticsScreen(),
        ),

        GoRoute(
          path: RoutePaths.users,
          builder: (context, state) => const AdminUsersListScreen(),
        ),

        GoRoute(
          path: RoutePaths.agencies,
          builder: (context, state) => const AdminAgenciesListScreen(),
        ),

        GoRoute(
          path: RoutePaths.reports,
          builder: (context, state) => const AdminReportsScreen(),
        ),
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

String? _redirectContent(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthCubit>().state;

  UserModel? user;

  if (authState is LoginSuccessState) {
    user = authState.user;
  }

  final location = state.matchedLocation;

  // ==================================================
  // PUBLIC ROUTES
  // ==================================================

  final bool isPublicRoute =
      location == RoutePaths.cTrackEntry ||
      location.startsWith('/citizen/track/') ||
      location == RoutePaths.aLocked ||
      location == RoutePaths.splashScreen;

  // ==================================================
  // AUTH ROUTES
  // ==================================================

  final bool isAuthRoute =
      location == RoutePaths.login ||
      location == RoutePaths.signup ||
      location == RoutePaths.verifyOTP ||
      location == RoutePaths.resendOTP;

  // ==================================================
  // AUTH GUARD
  // ==================================================

  if (user == null && !isAuthRoute && !isPublicRoute) {
    return RoutePaths.login;
  }

  if (user != null && isAuthRoute) {
    return _getHomePath(user.role);
  }

  // ==================================================
  // ROLE GUARD
  // ==================================================

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

  // ==================================================
  // ROOT
  // ==================================================

  if (user != null && location == '/') {
    return _getHomePath(user.role);
  }

  return null;
}
