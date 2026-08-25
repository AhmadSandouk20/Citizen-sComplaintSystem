import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/core/theme/colors.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/core/widget/error_view.dart';
import 'package:final_flutter/features/admin_users/domain/entities/admin_user_entity.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_users_cubit.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminUsersListScreen extends StatefulWidget {
  const AdminUsersListScreen({super.key});

  @override
  State<AdminUsersListScreen> createState() => _AdminUsersListScreenState();
}

class _AdminUsersListScreenState extends State<AdminUsersListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AdminUsersCubit>().load(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AdminUsersCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.users.tr())),
      body: BlocBuilder<AdminUsersCubit, AdminUsersState>(
        builder: (context, state) {
          if (state is AdminUsersLoading || state is AdminUsersInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminUsersError) {
            return ErrorView(
              message: state.message,
              buttonText: LocaleKeys.retry.tr(),
              onRetry: () =>
                  context.read<AdminUsersCubit>().load(refresh: true),
            );
          }
          if (state is AdminUsersEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              message: LocaleKeys.usersEmpty.tr(),
            );
          }
          if (state is AdminUsersLoaded) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<AdminUsersCubit>().load(refresh: true),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _UserTile(user: state.items[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final AdminUserEntity user;

  @override
  Widget build(BuildContext context) {
    final lastLogin = user.lastLoginAt == null
        ? LocaleKeys.neverLoggedIn.tr()
        : DateFormat.yMMMd().add_jm().format(user.lastLoginAt!.toLocal());
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user.isActive
              ? AppColors.secondaryContainer
              : AppColors.errorContainer,
          child: Icon(
            Icons.person_outline,
            color: user.isActive ? AppColors.secondary : AppColors.error,
          ),
        ),
        title: Text(user.name),
        subtitle: Text(
          '${_roleLabel(user.type)} · ${_statusLabel(user.isActive)}\n$lastLogin',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go(RoutePaths.userPath(user.id)),
      ),
    );
  }

  String _roleLabel(String type) {
    switch (type) {
      case 'admin':
        return LocaleKeys.roleAdmin.tr();
      case 'staff':
        return LocaleKeys.roleStaff.tr();
      default:
        return LocaleKeys.roleCitizen.tr();
    }
  }

  String _statusLabel(bool isActive) {
    return isActive ? LocaleKeys.active.tr() : LocaleKeys.inactive.tr();
  }
}
