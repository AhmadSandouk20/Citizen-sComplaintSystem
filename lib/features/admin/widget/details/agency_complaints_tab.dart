import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widget/empty_state.dart';
import '../../presentation/bloc/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import '../../presentation/bloc/agency/agency_complaints_cubit/admin_agency_complaints_state.dart';

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
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _priorityColor(complaint.priority),
                      child: Text(
                        complaint.priority.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(complaint.title),
                    subtitle: Text(
                      'Status: ${complaint.status}\nRef: ${complaint.referenceCode}',
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      complaint.priority,
                      style: TextStyle(
                        color: _priorityColor(complaint.priority),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
