import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/features/admin/domain/agency_repository.dart';
import 'package:final_flutter/features/admin/domain/staff_management_repository.dart';
import 'package:final_flutter/features/admin/domain/agency_complaints_repository.dart';
import 'package:final_flutter/features/admin/widget/web/agency_complaints_web_tab.dart';
import 'package:final_flutter/features/admin/widget/web/agency_info_web_tab.dart';
import '../../../../../../core/localization/local_keys.dart';
import '../../../../widget/web/agnecy_staff_web_tab.dart';
import '../../../bloc/mobile/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import '../../../bloc/mobile/agency/agency_cubit/admin_agency_cubit.dart';
import '../../../bloc/mobile/staff/staff_management_cubit.dart';

class AgencyDetailsPanel extends StatelessWidget {
  final int agencyId;
  const AgencyDetailsPanel({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(agencyId),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt<AdminAgenciesCubit>()..getAgencyDetails(agencyId),
          ),
          BlocProvider(
            create: (_) => StaffManagementCubit(
              getIt<StaffManagementRepository>(),
              getIt<AgencyRepository>(),
            )..loadStaff(agencyId),
          ),
          BlocProvider(
            create: (_) =>
                AdminAgenciesComplaintCubit(getIt<AgencyComplaintsRepository>())
                  ..loadAgencyComplaints(agencyId),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.agencyDetails.tr())),
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Info'),
                    Tab(text: 'Staff'),
                    Tab(text: 'Complaints'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      AgencyInfoWebTab(agencyId: agencyId),
                      AgencyStaffWebTab(agencyId: agencyId),
                      AgencyComplaintsWebTab(agencyId: agencyId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
