import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/admin/widget/web/dialogs/edit_staff_dialog.dart';
import 'package:final_flutter/features/admin/widget/web/dialogs/transfer_staff_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widget/app_button.dart';
import '../../presentation/bloc/mobile/staff/staff_management_cubit.dart';
import '../../presentation/bloc/mobile/staff/staff_management_state.dart';

class AgencyStaffWebTab extends StatelessWidget {
  final int agencyId;
  const AgencyStaffWebTab({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StaffManagementCubit>();
    return BlocBuilder<StaffManagementCubit, StaffManagementState>(
      builder: (context, state) {
        if (state is StaffManagementLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StaffManagementError) {
          return Center(
            child: Text('${LocaleKeys.error.tr()}: ${state.message}'),
          );
        }
        if (state is StaffManagementLoaded) {
          final staff = state.staff;
          if (staff.isEmpty) {
            return EmptyState(message: LocaleKeys.noStaffFound.tr());
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: staff.length,
                  itemBuilder: (context, index) {
                    final user = staff[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email ?? LocaleKeys.noEmail.tr()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () => _showEditDialog(context, user),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.swap_horiz,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              onPressed: () =>
                                  _showTransferDialog(context, user, cubit),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () =>
                                  _removeStaff(context, user.id, cubit),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: AppButton(
                  label: LocaleKeys.addStaff.tr(),
                  icon: Icons.add,
                  onPressed: () => _showAddStaffDialog(context),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showAddStaffDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => EditStaffDialog(agencyId: agencyId),
    ).then((_) {
      if (context.mounted) {
        context.read<StaffManagementCubit>().loadStaff(agencyId);
      }
    });
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => EditStaffDialog(agencyId: agencyId, staff: user),
    ).then((_) {
      if (context.mounted) {
        context.read<StaffManagementCubit>().loadStaff(agencyId);
      }
    });
  }

  void _showTransferDialog(
    BuildContext context,
    UserModel user,
    StaffManagementCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (_) =>
          TransferStaffDialog(agencyId: agencyId, staff: user, cubit: cubit),
    ).then((_) {
      cubit.loadStaff(agencyId);
    });
  }

  void _removeStaff(
    BuildContext context,
    int userId,
    StaffManagementCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(LocaleKeys.remove.tr()),
        content: Text(LocaleKeys.removeConfirm.tr()),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(LocaleKeys.remove.tr()),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      cubit.removeStaff(userId);
    }
  }
}
