import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/admin_crud_scaffold.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/core/widget/error_view.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/admin/data/model/agency/agency_model/agency_model.dart';

import 'package:final_flutter/core/router/route_paths.dart';

import '../../presentation/bloc/mobile/staff/staff_management_cubit.dart';
import '../../presentation/bloc/mobile/staff/staff_management_state.dart';

class AgencyStaffTab extends StatefulWidget {
  final int agencyId;
  const AgencyStaffTab({super.key, required this.agencyId});

  @override
  State<AgencyStaffTab> createState() => _AgencyStaffTabState();
}

class _AgencyStaffTabState extends State<AgencyStaffTab> {
  late final StaffManagementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StaffManagementCubit>();
    _cubit.loadStaff(widget.agencyId);
  }

  Future<void> _navigateToAddStaff() async {
    final result = await context.push<bool>(
      RoutePaths.addStaffPath(widget.agencyId),
    );
    if (result == true) {
      _cubit.loadStaff(widget.agencyId);
    }
  }

  Future<void> _navigateToEditStaff(UserModel user) async {
    final result = await context.push<bool>(
      RoutePaths.editStaffPath(widget.agencyId, user.id),
      extra: user,
    );
    if (result == true) {
      _cubit.loadStaff(widget.agencyId);
    }
  }

  Future<void> _showTransferDialog(UserModel user) async {
    await _cubit.loadAgencies();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocBuilder<StaffManagementCubit, StaffManagementState>(
            builder: (context, state) {
              final agencies = state is StaffManagementLoaded
                  ? state.agencies
                  : const <AgencyModel>[];
              return AlertDialog(
                title: Text('${LocaleKeys.transfer.tr()} ${user.name}'),
                content: DropdownButtonFormField<int>(
                  initialValue: null,
                  hint: Text(LocaleKeys.selectAgency.tr()),
                  items: agencies
                      .where((agency) => agency.id != widget.agencyId)
                      .map(
                        (agency) => DropdownMenuItem(
                          value: agency.id,
                          child: Text(agency.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _cubit.transferStaff(user.id, value);
                      context.pop();
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(LocaleKeys.cancel.tr()),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _confirmRemove(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.remove.tr()),
        content: Text('${LocaleKeys.removeConfirmPrefix.tr()} ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () => context.pop(true),
            child: Text(LocaleKeys.remove.tr()),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _cubit.removeStaff(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffManagementCubit, StaffManagementState>(
      builder: (context, state) {
        if (state is StaffManagementLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StaffManagementError) {
          return ErrorView(message: state.message);
        }
        if (state is StaffManagementLoaded) {
          return AdminCrudScaffold<UserModel>(
            title: '',
            items: state.staff,
            isLoading: false,
            itemBuilder: (context, user) => ListTile(
              title: Text(user.name),
              subtitle: Text(user.email ?? LocaleKeys.noEmail.tr()),
            ),
            onAdd: _navigateToAddStaff,
            onEdit: _navigateToEditStaff,
            onDelete: _confirmRemove,
            extraActions: (context, user) => [
              IconButton(
                icon: Icon(
                  Icons.swap_horiz,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                tooltip: LocaleKeys.transfer.tr(),
                onPressed: () => _showTransferDialog(user),
              ),
            ],
            emptyState: EmptyState(message: LocaleKeys.noStaffFound.tr()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
