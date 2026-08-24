import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/core/widget/error_view.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.business, size: 40, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                Text(
                  agency.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(agency.category),
                  backgroundColor: Colors.blue.shade50,
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InfoRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: agency.phone,
                        ),
                        const Divider(),
                        InfoRow(
                          icon: Icons.location_on,
                          label: 'Address',
                          value: agency.address,
                        ),
                        const Divider(),
                        InfoRow(
                          icon: Icons.location_city,
                          label: 'City',
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
        return const EmptyState(message: "Nothing to view");
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
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 12),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
