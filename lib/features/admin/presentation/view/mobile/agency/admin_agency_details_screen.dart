import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/staff/staff_management_cubit.dart';
import 'package:final_flutter/features/admin/widget/mobile/agency_complaints_tab.dart';
import 'package:final_flutter/features/admin/widget/mobile/agency_staff_tab.dart';
import 'package:final_flutter/features/admin/widget/mobile/agensy_info_tab.dart';
import 'package:final_flutter/features/admin/domain/agency_repository.dart';
import 'package:final_flutter/features/admin/domain/staff_management_repository.dart';
import 'package:final_flutter/features/admin/domain/agency_complaints_repository.dart';

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
            title: Text(LocaleKeys.agencyDetails.tr()),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.info), text: LocaleKeys.info.tr()),
                Tab(icon: Icon(Icons.people), text: LocaleKeys.staff.tr()),
                Tab(icon: Icon(Icons.report), text: LocaleKeys.complaints.tr()),
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
