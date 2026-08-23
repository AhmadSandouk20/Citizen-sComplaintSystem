import 'package:bloc/bloc.dart';
import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/features/notifications/domain/entities/notification_entity.dart';
import 'package:final_flutter/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository) : super(const NotificationsInitial());

  final NotificationsRepository _repository;

  Future<void> load({bool refresh = false}) async {
    final previousUnread = state.unreadCount;
    if (!refresh && state is NotificationsLoaded) return;

    emit(NotificationsLoading(unreadCount: previousUnread));
    try {
      final result = await _repository.getNotifications(page: 1);
      final unread = await _safeUnreadCount();
      if (result.items.isEmpty) {
        emit(NotificationsEmpty(unreadCount: unread));
        return;
      }
      emit(
        NotificationsLoaded(
          items: result.items,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          unreadCount: unread,
        ),
      );
    } catch (error) {
      emit(
        NotificationsError(
          _message(error),
          unreadCount: previousUnread,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final result = await _repository.getNotifications(
        page: current.currentPage + 1,
      );
      emit(
        current.copyWith(
          items: [...current.items, ...result.items],
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refreshUnreadCount() async {
    try {
      final unread = await _repository.getUnreadCount();
      final current = state;
      if (current is NotificationsLoaded) {
        emit(current.copyWith(unreadCount: unread));
      } else if (current is NotificationsEmpty) {
        emit(NotificationsEmpty(unreadCount: unread));
      } else if (current is NotificationsError) {
        emit(NotificationsError(current.message, unreadCount: unread));
      } else {
        emit(NotificationsInitial(unreadCount: unread));
      }
    } catch (_) {
      // Badge stays as-is if the count request fails.
    }
  }

  Future<void> markAsRead(int id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final target = current.items.where((item) => item.id == id);
    if (target.isEmpty || target.first.isRead) return;

    try {
      await _repository.markAsRead(id);
      final updated = current.items
          .map(
            (item) => item.id == id
                ? item.copyWith(isRead: true, readAt: DateTime.now())
                : item,
          )
          .toList();
      emit(
        current.copyWith(
          items: updated,
          unreadCount: current.unreadCount > 0 ? current.unreadCount - 1 : 0,
        ),
      );
    } catch (error) {
      emit(
        NotificationsError(
          _message(error),
          unreadCount: current.unreadCount,
        ),
      );
    }
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final unreadItems = current.items.where((item) => !item.isRead).toList();
    for (final item in unreadItems) {
      try {
        await _repository.markAsRead(item.id);
      } catch (_) {
        break;
      }
    }
    await load(refresh: true);
  }

  Future<int> _safeUnreadCount() async {
    try {
      return await _repository.getUnreadCount();
    } catch (_) {
      return state.unreadCount;
    }
  }

  String _message(Object error) {
    if (error is AppException) return error.message;
    return error.toString();
  }
}
