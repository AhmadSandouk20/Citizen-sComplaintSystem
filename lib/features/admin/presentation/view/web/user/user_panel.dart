import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/features/admin/widget/user/user_card.dart';
import '../../../bloc/user/user_management_cubit.dart';
import '../../../bloc/user/user_management_state.dart';

class UsersPanel extends StatelessWidget {
  const UsersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserManagementCubit>()..loadUsers(refresh: true),
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.users.tr())),
        body: BlocBuilder<UserManagementCubit, UserManagementState>(
          builder: (context, state) {
            if (state is UserManagementLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserManagementError) {
              return Center(
                child: Text(
                  '${LocaleKeys.error.tr()}: ${state.message}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            }
            if (state is UserManagementLoaded) {
              final users = state.users;
              if (users.isEmpty) {
                return Center(child: Text(LocaleKeys.usersEmpty.tr()));
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (state.hasMore &&
                      !state.isLoadingMore &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    context.read<UserManagementCubit>().loadMore();
                  }
                  return false;
                },
                child: ListView.separated(
                  itemCount: users.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index >= users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final user = users[index];
                    return UserCard(
                      user: user,
                      onDelete: () => context
                          .read<UserManagementCubit>()
                          .deleteUser(user.id),
                      onToggleActive: () => context
                          .read<UserManagementCubit>()
                          .toggleActive(user),
                      onChangeRole: (newRole) => context
                          .read<UserManagementCubit>()
                          .changeRole(user, newRole),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
