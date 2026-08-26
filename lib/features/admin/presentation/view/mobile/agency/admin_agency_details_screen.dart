import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/staff/staff_management_cubit.dart';
import 'package:final_flutter/features/admin/widget/mobile/agency_complaints_tab.dart';
import 'package:final_flutter/features/admin/widget/mobile/agency_staff_tab.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/agency_repository.dart';
import '../../../../domain/staff_management_repository.dart';
import '../../../../domain/agency_complaints_repository.dart';
import '../../../../widget/mobile/agensy_info_tab.dart';

class AdminAgencyDetailsScreen extends StatelessWidget {
  const AdminAgencyDetailsScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocProvider<AdminAgenciesCubit>(
        create: (_) => getIt<AdminAgenciesCubit>(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Agency Details'),
            bottom: const TabBar(
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(Icons.info), text: 'Info'),
                Tab(icon: Icon(Icons.people), text: 'Staff'),
                Tab(icon: Icon(Icons.report), text: 'Complaints'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AgencyInfoTab(id: id),
              BlocProvider(
                create: (_) => StaffManagementCubit(
                  getIt<StaffManagementRepository>(),
                  getIt<AgencyRepository>(),
                ),
                child: AgencyStaffTab(agencyId: id),
              ),
              BlocProvider(
                create: (_) => AdminAgenciesComplaintCubit(
                  getIt<AgencyComplaintsRepository>(),
                ),
                child: AgencyComplaintsTab(agencyId: id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
