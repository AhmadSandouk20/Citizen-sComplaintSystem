import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/core/widget/error_view.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:final_flutter/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:final_flutter/features/notifications/presentation/notification_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().load(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationsCubit>().loadMore();
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
      appBar: AppBar(
        title: Text(LocaleKeys.notifications.tr()),
        actions: [
          IconButton(
            tooltip: LocaleKeys.markAllRead.tr(),
            onPressed: () => context.read<NotificationsCubit>().markAllAsRead(),
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationsError) {
            return ErrorView(
              message: state.message,
              buttonText: LocaleKeys.retry.tr(),
              onRetry: () =>
                  context.read<NotificationsCubit>().load(refresh: true),
            );
          }
          if (state is NotificationsEmpty) {
            return EmptyState(
              icon: Icons.notifications_off_outlined,
              message: LocaleKeys.notificationsEmpty.tr(),
              subMessage: LocaleKeys.notificationsEmptyHint.tr(),
            );
          }
          if (state is NotificationsLoaded) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NotificationsCubit>().load(refresh: true),
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final item = state.items[index];
                  return NotificationTile(
                    notification: item,
                    onTap: () {
                      context.read<NotificationsCubit>().markAsRead(item.id);
                      final complaintId = item.complaintId;
                      // Nothing to open: this list is already the destination.
                      if (complaintId == null) return;
                      // Push, so the details screen has this list to go back to.
                      context.push(
                        notificationRoute(complaintId: complaintId),
                      );
                    },
                  );
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
