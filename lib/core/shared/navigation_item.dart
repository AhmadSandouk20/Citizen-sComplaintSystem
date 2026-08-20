import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:flutter/material.dart';

import '../../features/auth/data/models/user_role_enum.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String route; // The go_router path
  NavItem({required this.label, required this.icon, required this.route});
}

List<NavItem> getNavItemsForRole(UserRole role) {
  switch (role) {
    case UserRole.citizen:
      return [
        NavItem(
          label: LocaleKeys.complaints.tr(),
          icon: Icons.list,
          route: RoutePaths.cComplaints,
        ),
        NavItem(
          label: LocaleKeys.submit.tr(),
          icon: Icons.add_circle,
          route: RoutePaths.submit,
        ),

        NavItem(
          label: LocaleKeys.track.tr(),
          icon: Icons.search,
          route: RoutePaths.cTrackEntry,
        ), // Uses /track/{code}
        NavItem(
          label: LocaleKeys.profile.tr(),
          icon: Icons.person,
          route: RoutePaths.profile,
        ),
      ];

    case UserRole.staff:
      return [
        NavItem(
          label: LocaleKeys.agenciesQueue.tr(),
          icon: Icons.queue,
          route: RoutePaths.sComplaints,
        ),
        // GET /api/agency/complaints
        NavItem(
          label: LocaleKeys.profile.tr(),
          icon: Icons.person,
          route: RoutePaths.profile,
        ),
      ];

    case UserRole.admin:
      return [
        NavItem(
          label: LocaleKeys.statistics.tr(),
          icon: Icons.dashboard,
          route: RoutePaths.statistics,
        ), // GET /api/statistics/*
        NavItem(
          label: LocaleKeys.users.tr(),
          icon: Icons.people,
          route: RoutePaths.users,
        ), // GET /api/admin/users
        NavItem(
          label: LocaleKeys.agencies.tr(),
          icon: Icons.business,
          route: RoutePaths.agencies,
        ), // GET /api/agencies
        NavItem(
          label: LocaleKeys.reports.tr(),
          icon: Icons.file_copy,
          route: RoutePaths.reports,
        ), // GET /api/reports/*
        NavItem(
          label: LocaleKeys.profile.tr(),
          icon: Icons.person,
          route: RoutePaths.profile,
        ),
      ];
  }
}
