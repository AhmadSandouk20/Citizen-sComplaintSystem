import 'package:bloc/bloc.dart';
import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/features/admin_users/domain/repositories/admin_users_repository.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_user_detail_state.dart';

class AdminUserDetailCubit extends Cubit<AdminUserDetailState> {
  AdminUserDetailCubit(this._repository) : super(const AdminUserDetailLoading());

  final AdminUsersRepository _repository;

  Future<void> load(int id) async {
    emit(const AdminUserDetailLoading());
    try {
      final user = await _repository.getUser(id);
      emit(
        AdminUserDetailLoaded(
          user: user,
          selectedType: user.type,
          isActive: user.isActive,
        ),
      );
    } catch (error) {
      emit(AdminUserDetailError(_message(error)));
    }
  }

  void changeType(String type) {
    final current = state;
    if (current is! AdminUserDetailLoaded || current.isSaving) return;
    emit(current.copyWith(selectedType: type));
  }

  void changeActive(bool isActive) {
    final current = state;
    if (current is! AdminUserDetailLoaded || current.isSaving) return;
    emit(current.copyWith(isActive: isActive));
  }

  Future<void> save() async {
    final current = state;
    if (current is! AdminUserDetailLoaded || current.isSaving) return;
    emit(current.copyWith(isSaving: true, clearActionError: true));
    try {
      final updated = await _repository.updateUser(
        id: current.user.id,
        type: current.selectedType,
        isActive: current.isActive,
      );
      emit(AdminUserDetailSaved(updated));
    } catch (error) {
      emit(
        current.copyWith(
          isSaving: false,
          actionError: _message(error),
        ),
      );
    }
  }

  Future<void> delete() async {
    final current = state;
    if (current is! AdminUserDetailLoaded || current.isDeleting) return;
    emit(current.copyWith(isDeleting: true, clearActionError: true));
    try {
      await _repository.deleteUser(current.user.id);
      emit(const AdminUserDetailDeleted());
    } catch (error) {
      emit(
        current.copyWith(
          isDeleting: false,
          actionError: _message(error),
        ),
      );
    }
  }

  String _message(Object error) {
    if (error is AppException) return error.message;
    return error.toString();
  }
}
