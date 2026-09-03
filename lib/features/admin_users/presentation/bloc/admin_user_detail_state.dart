import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/admin_users/domain/entities/admin_user_entity.dart';

sealed class AdminUserDetailState extends Equatable {
  const AdminUserDetailState();

  @override
  List<Object?> get props => [];
}

class AdminUserDetailLoading extends AdminUserDetailState {
  const AdminUserDetailLoading();
}

class AdminUserDetailError extends AdminUserDetailState {
  const AdminUserDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AdminUserDetailLoaded extends AdminUserDetailState {
  const AdminUserDetailLoaded({
    required this.user,
    required this.selectedType,
    required this.isActive,
    this.isSaving = false,
    this.isDeleting = false,
    this.actionError,
  });

  final AdminUserEntity user;
  final String selectedType;
  final bool isActive;
  final bool isSaving;
  final bool isDeleting;
  final String? actionError;

  AdminUserDetailLoaded copyWith({
    AdminUserEntity? user,
    String? selectedType,
    bool? isActive,
    bool? isSaving,
    bool? isDeleting,
    String? actionError,
    bool clearActionError = false,
  }) {
    return AdminUserDetailLoaded(
      user: user ?? this.user,
      selectedType: selectedType ?? this.selectedType,
      isActive: isActive ?? this.isActive,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props => [
    user,
    selectedType,
    isActive,
    isSaving,
    isDeleting,
    actionError,
  ];
}

class AdminUserDetailSaved extends AdminUserDetailState {
  const AdminUserDetailSaved(this.user);

  final AdminUserEntity user;

  @override
  List<Object?> get props => [user];
}

class AdminUserDetailDeleted extends AdminUserDetailState {
  final int userId;
  const AdminUserDetailDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}
