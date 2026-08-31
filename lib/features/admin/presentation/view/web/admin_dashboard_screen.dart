import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/localization/local_keys.dart';
import '../../bloc/web/dascboard/dashboard_cubit.dart';
import '../../bloc/web/dascboard/dashboard_state.dart';
import 'agency/agency_details_panel.dart';
import 'agency/agency_list_panel.dart';

/// Agencies, laid out for a wide viewport: the list on one side and the
/// selected agency's details beside it.
///
/// It carries no navigation of its own. The admin sidebar already owns
/// navigation, and the rail this screen used to have repeated it — the same
/// three sections reachable two ways, landing on two different screens.
/// This is now simply what `/admin/agencies` looks like when there is room
/// for two panes.
class AdminAgenciesWebView extends StatelessWidget {
  const AdminAgenciesWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: const _AgenciesTwoPane(),
    );
  }
}

class _AgenciesTwoPane extends StatelessWidget {
  const _AgenciesTwoPane();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.agencies.tr())),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    ? AgencyDetailsPanel(agencyId: state.selectedAgencyId!)
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 32,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              LocaleKeys.selectAgency.tr(),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
