import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_entity.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  updating,
  updated,
  deleting,
  deleted,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  bool get isBusy =>
      status == ProfileStatus.loading ||
      status == ProfileStatus.updating ||
      status == ProfileStatus.deleting;

  /// [clearError] is explicit so that a normal `copyWith` never silently drops
  /// an error message — the previous implementation cleared it on every call.
  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
