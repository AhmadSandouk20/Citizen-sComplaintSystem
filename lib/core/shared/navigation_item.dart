import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:flutter/material.dart';

import '../../features/auth/data/models/user_type_enum.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String route;
  NavItem({required this.label, required this.icon, required this.route});
}

List<NavItem> getNavItemsForRole(UserType role) {
  switch (role) {
    case UserType.citizen:
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
        ),
        NavItem(
          label: LocaleKeys.profile.tr(),
          icon: Icons.person,
          route: RoutePaths.profile,
        ),
      ];

    case UserType.staff:
      return [
        NavItem(
          label: LocaleKeys.agenciesQueue.tr(),
          icon: Icons.queue,
          route: RoutePaths.sComplaints,
        ),

        NavItem(
          label: LocaleKeys.profile.tr(),
          icon: Icons.person,
          route: RoutePaths.profile,
        ),
      ];

    case UserType.admin:
      return [
        NavItem(
          label: LocaleKeys.statistics.tr(),
          icon: Icons.dashboard,
          route: RoutePaths.statistics,
        ),
        NavItem(
          label: LocaleKeys.users.tr(),
          icon: Icons.people,
          route: RoutePaths.users,
        ),
        NavItem(
          label: LocaleKeys.agencies.tr(),
          icon: Icons.business,
          route: RoutePaths.agencies,
        ),
        NavItem(
          label: LocaleKeys.reports.tr(),
          icon: Icons.file_copy,
          route: RoutePaths.reports,
        ),
        NavItem(
          label: LocaleKeys.profile.tr(),
          icon: Icons.person,
          route: RoutePaths.profile,
        ),
      ];
  }
}
