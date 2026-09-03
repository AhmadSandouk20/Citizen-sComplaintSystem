import 'package:bloc/bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository, this._authCubit) : super(const ProfileState());

  final ProfileRepository _repository;
  final AuthCubit _authCubit;

  Future<void> getProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));
    try {
      final profile = await _repository.getProfile();
      emit(state.copyWith(status: ProfileStatus.success, profile: profile));
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: _message(error),
        ),
      );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    emit(state.copyWith(status: ProfileStatus.updating, clearError: true));
    try {
      final profile = await _repository.updateProfile(
        name: name,
        phone: phone,
      );
      emit(state.copyWith(status: ProfileStatus.updated, profile: profile));

      // Keep the session's cached user in sync so the shell, the drawer and
      // any other screen reading AuthCubit show the new name immediately.
      final current = _authCubit.user;
      if (current != null) {
        _authCubit.updateUser(
          current.copyWith(name: profile.name, phone: profile.phone),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: _message(error),
        ),
      );
    }
  }

  Future<void> deleteProfile() async {
    emit(state.copyWith(status: ProfileStatus.deleting, clearError: true));
    try {
      await _repository.deleteProfile();

      // The account no longer exists — drop the session locally instead of
      // calling /auth/logout with a token the server has already invalidated.
      await _authCubit.clearSession();

      emit(const ProfileState(status: ProfileStatus.deleted));
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: _message(error),
        ),
      );
    }
  }

  /// Lets a screen consume an error once without it re-firing on rebuild.
  void clearError() {
    if (state.errorMessage != null) emit(state.copyWith(clearError: true));
  }

  String? _message(Object error) =>
      error is AppException ? error.message : null;
}
