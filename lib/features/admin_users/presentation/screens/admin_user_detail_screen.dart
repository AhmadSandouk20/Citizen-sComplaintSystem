import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/core/widget/error_view.dart';
import 'package:final_flutter/features/admin_users/domain/entities/admin_user_entity.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_user_detail_cubit.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_user_detail_state.dart';
import 'package:final_flutter/features/admin/presentation/bloc/user/user_management_cubit.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminUserDetailScreen extends StatelessWidget {
  const AdminUserDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().user?.id;
    final isSelf = currentUserId == id;

    return BlocConsumer<AdminUserDetailCubit, AdminUserDetailState>(
      listener: (context, state) async {
        if (state is AdminUserDetailSaved) {
          final userModel = _toUserModel(state.user);
          context.read<UserManagementCubit>().updateUserInList(userModel);
          await context.read<UserManagementCubit>().loadUsers(refresh: true);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.userUpdated.tr())),
            );
            context.pop();
          }
        }
        if (state is AdminUserDetailDeleted) {
          context.read<UserManagementCubit>().removeUserLocally(state.userId);
          await context.read<UserManagementCubit>().loadUsers(refresh: true);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.userDeleted.tr())),
            );
            context.pop();
          }
        }
        if (state is AdminUserDetailLoaded && state.actionError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionError!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.editUser.tr())),
          body: _body(context, state, isSelf),
        );
      },
    );
  }

  Widget _body(BuildContext context, AdminUserDetailState state, bool isSelf) {
    if (state is AdminUserDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AdminUserDetailError) {
      return ErrorView(
        message: state.message,
        buttonText: LocaleKeys.retry.tr(),
        onRetry: () => context.read<AdminUserDetailCubit>().load(id),
      );
    }
    if (state is! AdminUserDetailLoaded) {
      return const SizedBox.shrink();
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(state.user.name, style: Theme.of(context).textTheme.headlineSmall),
        if (state.user.email != null) ...[
          const SizedBox(height: 4),
          Text(state.user.email!),
        ],
        const SizedBox(height: 24),
        if (isSelf)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(LocaleKeys.cannotEditSelf.tr()),
          ),
        DropdownButtonFormField<String>(
          initialValue:
              ['citizen', 'staff', 'admin'].contains(state.selectedType)
              ? state.selectedType
              : 'citizen',
          decoration: InputDecoration(
            labelText: LocaleKeys.role.tr(),
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: 'citizen',
              child: Text(LocaleKeys.roleCitizen.tr()),
            ),
            DropdownMenuItem(
              value: 'staff',
              child: Text(LocaleKeys.roleStaff.tr()),
            ),
            DropdownMenuItem(
              value: 'admin',
              child: Text(LocaleKeys.roleAdmin.tr()),
            ),
          ],
          onChanged: isSelf
              ? null
              : (value) {
                  if (value != null) {
                    context.read<AdminUserDetailCubit>().changeType(value);
                  }
                },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(LocaleKeys.active.tr()),
          value: state.isActive,
          onChanged: isSelf
              ? null
              : (value) =>
                    context.read<AdminUserDetailCubit>().changeActive(value),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: LocaleKeys.save.tr(),
          isLoading: state.isSaving,
          onPressed: isSelf
              ? null
              : () => context.read<AdminUserDetailCubit>().save(),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: LocaleKeys.deleteUser.tr(),
          variant: AppButtonVariant.outlined,
          isLoading: state.isDeleting,
          onPressed: isSelf ? null : () => _confirmDelete(context),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.deleteUser.tr()),
        content: Text(LocaleKeys.deleteUserConfirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(LocaleKeys.deleteUser.tr()),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AdminUserDetailCubit>().delete();
    }
  }

  UserModel _toUserModel(AdminUserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      isActive: entity.isActive,
      role: UserRole.values.firstWhere(
        (e) => e.name == entity.type,
        orElse: () => UserRole.citizen,
      ),
      lastLoginAt: null,
    );
  }
}
