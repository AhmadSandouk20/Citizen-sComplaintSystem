import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import '../../presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import '../../presentation/bloc/agency/agency_cubit/admin_agency_state.dart';

class AgencyInfoWebTab extends StatelessWidget {
  final int agencyId;
  const AgencyInfoWebTab({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AdminAgenciesCubit, AdminAgenciesState>(
      builder: (context, state) {
        if (state is AgencyDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AgencyDetailsLoaded) {
          final agency = state.agencyModelDetails;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: scheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      agency.name,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Chip(
                      label: Text(agency.category),
                      backgroundColor: scheme.onPrimaryContainer,
                      labelStyle: textTheme.labelMedium?.copyWith(
                        color: scheme.primaryContainer,
                      ),
                    ),
                    const Divider(height: 32),
                    _infoRow(
                      context,
                      Icons.phone,
                      LocaleKeys.phone.tr(),
                      agency.phone,
                    ),
                    _infoRow(
                      context,
                      Icons.location_on,
                      LocaleKeys.address.tr(),
                      agency.address,
                    ),
                    _infoRow(
                      context,
                      Icons.location_city,
                      LocaleKeys.city.tr(),
                      agency.city,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: Text(LocaleKeys.loading.tr()));
      },
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(width: 16),
          Text(
            '$label:',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
