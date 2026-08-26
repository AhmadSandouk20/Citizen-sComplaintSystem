import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:final_flutter/core/widget/admin_crud_scaffold.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/core/widget/error_view.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/admin/data/model/agency/agency_model/agency_model.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/staff/staff_management_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/staff/staff_management_state.dart';
import 'package:final_flutter/core/router/route_paths.dart';

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
                title: Text('Transfer ${user.name}'),
                content: DropdownButtonFormField<int>(
                  value: null,
                  hint: const Text('Select new agency'),
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
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel'),
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
        title: const Text('Remove Staff'),
        content: Text('Are you sure you want to remove ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
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
              subtitle: Text(user.email ?? 'No email'),
            ),
            onAdd: _navigateToAddStaff,
            onEdit: _navigateToEditStaff,
            onDelete: _confirmRemove,
            extraActions: (context, user) => [
              IconButton(
                icon: const Icon(Icons.swap_horiz, color: Colors.orange),
                tooltip: 'Transfer',
                onPressed: () => _showTransferDialog(user),
              ),
            ],
            emptyState: const EmptyState(message: 'No staff found.'),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
