import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/empty_state.dart';

import '../../../../core/widget/status_chip.dart';
import '../../presentation/bloc/mobile/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import '../../presentation/bloc/mobile/agency/agency_complaints_cubit/admin_agency_complaints_state.dart';

class AgencyComplaintsTab extends StatefulWidget {
  final int agencyId;
  const AgencyComplaintsTab({super.key, required this.agencyId});

  @override
  State<AgencyComplaintsTab> createState() => _AgencyComplaintsTabState();
}

class _AgencyComplaintsTabState extends State<AgencyComplaintsTab> {
  late final AdminAgenciesComplaintCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AdminAgenciesComplaintCubit>();
    _cubit.loadAgencyComplaints(widget.agencyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      AdminAgenciesComplaintCubit,
      AdminAgencyComplaintsState
    >(
      listener: (context, state) {
        if (state is AdminAgencyComplaintsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AdminAgencyComplaintsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AdminAgencyComplaintsLoaded) {
          final complaints = state.complaints;
          if (complaints.isEmpty) {
            return EmptyState(message: LocaleKeys.noComplaintsFound.tr());
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!state.hasReachedEnd &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                _cubit.loadMoreAgencyComplaints(widget.agencyId);
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: complaints.length + (state.hasReachedEnd ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= complaints.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final complaint = complaints[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: PriorityChip(
                      priority: complaint.priority,
                      dense: true,
                    ),
                    title: Text(complaint.title),
                    subtitle: Row(
                      children: [
                        StatusChip(status: complaint.status, dense: true),
                        const SizedBox(width: 8),
                        Text(
                          '${LocaleKeys.referenceCode.tr()}: ${complaint.referenceCode}',
                        ),
                      ],
                    ),
                    isThreeLine: false,
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
