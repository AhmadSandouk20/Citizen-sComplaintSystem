import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/notifications/domain/entities/notification_entity.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState({this.unreadCount = 0});

  final int unreadCount;

  @override
  List<Object?> get props => [unreadCount];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial({super.unreadCount});
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading({super.unreadCount});
}

class NotificationsEmpty extends NotificationsState {
  const NotificationsEmpty({super.unreadCount});
}

class NotificationsError extends NotificationsState {
  const NotificationsError(this.message, {super.unreadCount});

  final String message;

  @override
  List<Object?> get props => [unreadCount, message];
}

class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required super.unreadCount,
    this.isLoadingMore = false,
  });

  final List<NotificationEntity> items;
  final int currentPage;
  final int lastPage;
  final bool isLoadingMore;

  bool get hasMore => currentPage < lastPage;

  NotificationsLoaded copyWith({
    List<NotificationEntity>? items,
    int? currentPage,
    int? lastPage,
    int? unreadCount,
    bool? isLoadingMore,
  }) {
    return NotificationsLoaded(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    unreadCount,
    items,
    currentPage,
    lastPage,
    isLoadingMore,
  ];
}
