import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/features/admin/presentation/view/web/agency/agency_list_panel.dart';
import 'package:final_flutter/features/admin/presentation/view/web/agency/agency_details_panel.dart';
import 'package:final_flutter/features/admin/presentation/view/web/user/user_panel.dart';
import '../../bloc/web/dascboard/dashboard_cubit.dart';
import '../../bloc/web/dascboard/dashboard_state.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                switch (state.selectedNavItem) {
                  case DashboardNavItem.statistics:
                    return Scaffold(
                      body: Center(child: Text(LocaleKeys.statistics.tr())),
                    );
                  case DashboardNavItem.agencies:
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AgencyListPanel(
                            selectedAgencyId: state.selectedAgencyId,
                          ),
                        ),
                        const VerticalDivider(width: 1, thickness: 1),
                        Expanded(
                          flex: 3,
                          child: state.selectedAgencyId != null
                              ? AgencyDetailsPanel(
                                  agencyId: state.selectedAgencyId!,
                                )
                              : Center(
                                  child: Text(LocaleKeys.selectAgency.tr()),
                                ),
                        ),
                      ],
                    );
                  case DashboardNavItem.users:
                    return const UsersPanel();
                  case DashboardNavItem.reports:
                    return const Scaffold(body: Center(child: Text('Reports')));
                  case DashboardNavItem.profile:
                    return const Scaffold(body: Center(child: Text('Profile')));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return NavigationRail(
          selectedIndex: _navIndex(state.selectedNavItem),
          onDestinationSelected: (index) {
            cubit.selectNavItem(_navItemFromIndex(index));
          },
          labelType: NavigationRailLabelType.all,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.bar_chart),
              label: Text(LocaleKeys.statistics.tr()),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.business),
              label: Text(LocaleKeys.agencies.tr()),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.people),
              label: Text(LocaleKeys.users.tr()),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.report),
              label: Text(LocaleKeys.reports.tr()),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person),
              label: Text(LocaleKeys.profile.tr()),
            ),
          ],
        );
      },
    );
  }

  int _navIndex(DashboardNavItem item) {
    switch (item) {
      case DashboardNavItem.statistics:
        return 0;
      case DashboardNavItem.agencies:
        return 1;
      case DashboardNavItem.users:
        return 2;
      case DashboardNavItem.reports:
        return 3;
      case DashboardNavItem.profile:
        return 4;
    }
  }

  DashboardNavItem _navItemFromIndex(int index) {
    switch (index) {
      case 0:
        return DashboardNavItem.statistics;
      case 1:
        return DashboardNavItem.agencies;
      case 2:
        return DashboardNavItem.users;
      case 3:
        return DashboardNavItem.reports;
      case 4:
        return DashboardNavItem.profile;
      default:
        return DashboardNavItem.statistics;
    }
  }
}
