import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/features/admin/widget/confirm_deletion_dialog.dart';
import 'package:final_flutter/features/admin/widget/web/dialogs/edit_agency_dialog.dart';
import '../../../bloc/mobile/agency/agency_cubit/admin_agency_cubit.dart';
import '../../../bloc/mobile/agency/agency_cubit/admin_agency_state.dart';
import '../../../bloc/web/dascboard/dashboard_cubit.dart';

class AgencyListPanel extends StatefulWidget {
  final int? selectedAgencyId;
  const AgencyListPanel({super.key, this.selectedAgencyId});

  @override
  State<AgencyListPanel> createState() => _AgencyListPanelState();
}

class _AgencyListPanelState extends State<AgencyListPanel> {
  late final AdminAgenciesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AdminAgenciesCubit>()..loadAgencies(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.agencies.tr()),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: scheme.onSurface),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<AdminAgenciesCubit, AdminAgenciesState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is AgenciesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AgenciesError) {
            return Center(
              child: Text(
                '${LocaleKeys.error.tr()}: ${state.message}',
                style: TextStyle(color: scheme.error),
              ),
            );
          }
          if (state is AgenciesLoaded) {
            final agencies = state.agencies;
            if (agencies.isEmpty) {
              return Center(child: Text(LocaleKeys.noAgenciesFound.tr()));
            }
            return ListView.separated(
              itemCount: agencies.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final agency = agencies[index];
                final isSelected = agency.id == widget.selectedAgencyId;
                return ListTile(
                  selected: isSelected,
                  selectedTileColor: scheme.primaryContainer.withOpacity(0.3),
                  title: Text(
                    agency.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    '${agency.category} · ${agency.city}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () {
                    context.read<DashboardCubit>().selectAgency(agency.id);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: scheme.primary),
                        onPressed: () => _showEditDialog(context, agency.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: scheme.error),
                        onPressed: () => _deleteAgency(context, agency),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const EditAgencyDialog()).then(
      (_) {
        _cubit.loadAgencies(refresh: true);
      },
    );
  }

  void _showEditDialog(BuildContext context, int agencyId) {
    showDialog(
      context: context,
      builder: (_) => EditAgencyDialog(agencyId: agencyId),
    ).then((_) {
      _cubit.loadAgencies(refresh: true);
    });
  }

  void _deleteAgency(BuildContext context, agency) async {
    final confirmed = await confirmDeleteAgency(context, agency);
    if (confirmed) {
      await _cubit.deleteAgency(agency.id);
      if (context.mounted) {
        final dashboardCubit = context.read<DashboardCubit>();
        if (dashboardCubit.state.selectedAgencyId == agency.id) {
          dashboardCubit.selectAgency(null);
        }
        _cubit.loadAgencies(refresh: true);
      }
    }
  }
}
