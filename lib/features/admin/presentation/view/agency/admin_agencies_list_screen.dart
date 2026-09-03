import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/router/router.dart';
import 'package:final_flutter/core/widget/admin_crud_scaffold.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/features/admin/data/model/agency/agency_model/agency_model.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_state.dart';
import 'package:final_flutter/features/admin/widget/confirm_deletion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminAgenciesListScreen extends StatefulWidget {
  const AdminAgenciesListScreen({super.key});

  @override
  State<AdminAgenciesListScreen> createState() =>
      _AdminAgenciesListScreenState();
}

class _AdminAgenciesListScreenState extends State<AdminAgenciesListScreen> {
  late final AdminAgenciesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AdminAgenciesCubit>()..loadAgencies(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminAgenciesCubit>.value(
      value: _cubit,
      child: BlocBuilder<AdminAgenciesCubit, AdminAgenciesState>(
        builder: (context, state) {
          if (state is AgenciesLoading) {
            return AdminCrudScaffold<AgencyModel>(
              title: 'Agencies',
              items: const [],
              isLoading: true,
              itemBuilder: (_, _) => const SizedBox.shrink(),
            );
          }

          if (state is AgenciesError) {
            return AdminCrudScaffold<AgencyModel>(
              title: 'Agencies',
              items: const [],
              errorMessage: state.message,
              itemBuilder: (_, _) => const SizedBox.shrink(),
            );
          }

          if (state is AgenciesLoaded) {
            return AdminCrudScaffold<AgencyModel>(
              title: 'Agencies',
              items: state.agencies,
              isLoading: false,
              itemBuilder: (context, agency) => ListTile(
                title: Text(agency.name),
                subtitle: Text('${agency.category} · ${agency.city}'),
                onTap: () => context.push(RoutePaths.agencyPath(agency.id)),
              ),
              onAdd: () async {
                await context.push(RoutePaths.addAgency);
                _cubit.loadAgencies(refresh: true);
              },
              onEdit: (agency) async {
                await context.push(RoutePaths.updateAgencyPath(agency.id));
                _cubit.loadAgencies(refresh: true);
              },
              onDelete: (agency) async {
                final confirmed = await confirmDeleteAgency(context, agency);
                if (confirmed) _cubit.deleteAgency(agency.id);
              },
              emptyState: EmptyState(
                message: 'No Agencies Found',
                buttonText: 'Refresh',
                onAction: () => _cubit.loadAgencies(refresh: true),
              ),
              showPagination: true,
              hasMore: !state.hasReachedEnd,
              onLoadMore: () => _cubit.loadMore(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
