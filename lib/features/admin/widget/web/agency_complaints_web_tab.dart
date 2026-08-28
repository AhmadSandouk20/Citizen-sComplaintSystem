import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import '../../../../core/widget/status_chip.dart';
import '../../presentation/bloc/mobile/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import '../../presentation/bloc/mobile/agency/agency_complaints_cubit/admin_agency_complaints_state.dart';

class AgencyComplaintsWebTab extends StatelessWidget {
  final int agencyId;
  const AgencyComplaintsWebTab({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAgenciesComplaintCubit, AdminAgencyComplaintsState>(
      builder: (context, state) {
        if (state is AdminAgencyComplaintsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AdminAgencyComplaintsError) {
          return Center(
            child: Text('${LocaleKeys.error.tr()}: ${state.message}'),
          );
        }
        if (state is AdminAgencyComplaintsLoaded) {
          final complaints = state.complaints;
          if (complaints.isEmpty) {
            return Center(child: Text(LocaleKeys.noComplaintsFound.tr()));
          }
          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final c = complaints[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(c.title),
                  subtitle: Row(
                    children: [
                      StatusChip(status: c.status, dense: true),
                      const SizedBox(width: 8),
                      Text('Ref: ${c.referenceCode}'),
                    ],
                  ),
                  trailing: PriorityChip(priority: c.priority),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
