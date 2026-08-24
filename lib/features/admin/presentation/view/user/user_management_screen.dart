import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/widget/admin_crud_scaffold.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/admin/presentation/bloc/user/user_management_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/user/user_management_state.dart';
import 'package:final_flutter/features/admin/widget/user/user_card.dart';

class AdminUsersManagementScreen extends StatelessWidget {
  const AdminUsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserManagementCubit, UserManagementState>(
      builder: (context, state) {
        if (state is UserManagementLoading) {
          return AdminCrudScaffold<UserModel>(
            title: 'Users',
            items: const [],
            isLoading: true,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          );
        }
        if (state is UserManagementError && state is! UserManagementLoaded) {
          return AdminCrudScaffold<UserModel>(
            title: 'Users',
            items: const [],
            errorMessage: state.message,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          );
        }
        if (state is UserManagementLoaded) {
          return AdminCrudScaffold<UserModel>(
            title: 'Users',
            items: state.users,
            isLoading: state.isLoadingMore,
            itemBuilder: (context, user) => UserCard(
              user: user,
              onDelete: () =>
                  context.read<UserManagementCubit>().deleteUser(user.id),
              onToggleActive: () =>
                  context.read<UserManagementCubit>().toggleActive(user),
              onChangeRole: (newRole) =>
                  context.read<UserManagementCubit>().changeRole(user, newRole),
            ),

            onAdd: null,
            onEdit: null,
            onDelete: (user) => _confirmDelete(context, user),
            emptyState: EmptyState(
              message: 'No users found.',
              buttonText: 'Refresh',
              onAction: () =>
                  context.read<UserManagementCubit>().loadUsers(refresh: true),
            ),
            showPagination: true,
            hasMore: state.hasMore,
            onLoadMore: () => context.read<UserManagementCubit>().loadMore(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _confirmDelete(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete "${user.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<UserManagementCubit>().deleteUser(user.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
