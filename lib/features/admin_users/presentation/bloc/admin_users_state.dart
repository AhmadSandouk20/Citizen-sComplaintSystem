import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/admin_users/domain/entities/admin_user_entity.dart';

sealed class AdminUsersState extends Equatable {
  const AdminUsersState();

  @override
  List<Object?> get props => [];
}

class AdminUsersInitial extends AdminUsersState {
  const AdminUsersInitial();
}

class AdminUsersLoading extends AdminUsersState {
  const AdminUsersLoading();
}

class AdminUsersEmpty extends AdminUsersState {
  const AdminUsersEmpty();
}

class AdminUsersError extends AdminUsersState {
  const AdminUsersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AdminUsersLoaded extends AdminUsersState {
  const AdminUsersLoaded({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    this.isLoadingMore = false,
  });

  final List<AdminUserEntity> items;
  final int currentPage;
  final int lastPage;
  final bool isLoadingMore;

  bool get hasMore => currentPage < lastPage;

  AdminUsersLoaded copyWith({
    List<AdminUserEntity>? items,
    int? currentPage,
    int? lastPage,
    bool? isLoadingMore,
  }) {
    return AdminUsersLoaded(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [items, currentPage, lastPage, isLoadingMore];
}
