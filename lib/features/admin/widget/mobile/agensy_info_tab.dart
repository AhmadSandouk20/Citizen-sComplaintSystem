import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/core/widget/error_view.dart';

import '../../presentation/bloc/mobile/agency/agency_cubit/admin_agency_cubit.dart';
import '../../presentation/bloc/mobile/agency/agency_cubit/admin_agency_state.dart';

class AgencyInfoTab extends StatefulWidget {
  const AgencyInfoTab({super.key, required this.id});
  final int id;

  @override
  State<AgencyInfoTab> createState() => _AgencyInfoTabState();
}

class _AgencyInfoTabState extends State<AgencyInfoTab> {
  @override
  void initState() {
    super.initState();
    context.read<AdminAgenciesCubit>().getAgencyDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<AdminAgenciesCubit, AdminAgenciesState>(
      builder: (context, state) {
        if (state is AgencyDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AgencyDetailsFailed) {
          return ErrorView(message: state.message);
        }
        if (state is AgencyDetailsLoaded) {
          final agency = state.agencyModelDetails;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(
                    Icons.business,
                    size: 40,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  agency.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(agency.category),
                  backgroundColor: scheme.secondaryContainer,
                  labelStyle: TextStyle(color: scheme.onSecondaryContainer),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InfoRow(
                          icon: Icons.phone,
                          label: LocaleKeys.phone.tr(),
                          value: agency.phone,
                        ),
                        const Divider(),
                        InfoRow(
                          icon: Icons.location_on,
                          label: LocaleKeys.address.tr(),
                          value: agency.address,
                        ),
                        const Divider(),
                        InfoRow(
                          icon: Icons.location_city,
                          label: LocaleKeys.city.tr(),
                          value: agency.city,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return EmptyState(message: LocaleKeys.noData.tr());
      },
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: scheme.primary),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: scheme.onSurface,
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: scheme.onSurface)),
        ),
      ],
    );
  }
}
