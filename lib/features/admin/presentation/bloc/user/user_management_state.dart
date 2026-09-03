import 'package:equatable/equatable.dart';
import '../../../../auth/data/models/user_model.dart';

sealed class UserManagementState extends Equatable {
  const UserManagementState();
  @override
  List<Object> get props => [];
}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class UserManagementLoaded extends UserManagementState {
  final List<UserModel> users;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;
  final int total;

  const UserManagementLoaded({
    required this.users,
    required this.hasMore,
    required this.isLoadingMore,
    required this.currentPage,
    required this.total,
  });

  UserManagementLoaded copyWith({
    List<UserModel>? users,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentPage,
    int? total,
  }) {
    return UserManagementLoaded(
      users: users ?? this.users,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
    );
  }

  @override
  List<Object> get props => [users, hasMore, isLoadingMore, currentPage, total];
}

class UserManagementError extends UserManagementState {
  final String message;
  const UserManagementError(this.message);
  @override
  List<Object> get props => [message];
}
