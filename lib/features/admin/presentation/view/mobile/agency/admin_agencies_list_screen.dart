import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/router/router.dart';
import 'package:final_flutter/core/widget/admin_crud_scaffold.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/features/admin/data/model/agency/agency_model/agency_model.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/agency/agency_cubit/admin_agency_state.dart';
import 'package:final_flutter/features/admin/widget/confirm_deletion_dialog.dart';

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
              title: LocaleKeys.agencies.tr(),
              items: const [],
              isLoading: true,
              itemBuilder: (_, __) => const SizedBox.shrink(),
            );
          }

          if (state is AgenciesError) {
            return AdminCrudScaffold<AgencyModel>(
              title: LocaleKeys.agencies.tr(),
              items: const [],
              errorMessage: state.message,
              itemBuilder: (_, __) => const SizedBox.shrink(),
            );
          }

          if (state is AgenciesLoaded) {
            return AdminCrudScaffold<AgencyModel>(
              title: LocaleKeys.agencies.tr(),
              items: state.agencies,
              isLoading: false,
              itemBuilder: (context, agency) => ListTile(
                title: Text(
                  agency.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  '${agency.category} · ${agency.city}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
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
                message: LocaleKeys.noAgenciesFound.tr(),
                buttonText: LocaleKeys.retry.tr(),
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
