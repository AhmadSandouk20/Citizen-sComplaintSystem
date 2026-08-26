import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(const ProfileState());

  Future<void> getProfile({required String token}) async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));

    try {
      final profile = await repository.getProfile(token: token);

      emit(state.copyWith(status: ProfileStatus.success, profile: profile));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateProfile({
    required String token,
    required String name,
    required String phone,
  }) async {
    emit(state.copyWith(status: ProfileStatus.updating, errorMessage: null));

    try {
      final profile = await repository.updateProfile(
        token: token,
        name: name,
        phone: phone,
      );

      emit(state.copyWith(status: ProfileStatus.updated, profile: profile));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteProfile({required String token}) async {
    emit(state.copyWith(status: ProfileStatus.deleting, errorMessage: null));

    try {
      await repository.deleteProfile(token: token);

      emit(state.copyWith(status: ProfileStatus.deleted));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  String _getErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
