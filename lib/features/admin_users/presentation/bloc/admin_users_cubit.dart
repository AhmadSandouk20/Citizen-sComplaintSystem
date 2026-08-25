import 'package:bloc/bloc.dart';
import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/features/admin_users/domain/repositories/admin_users_repository.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_users_state.dart';

class AdminUsersCubit extends Cubit<AdminUsersState> {
  AdminUsersCubit(this._repository) : super(const AdminUsersInitial());

  final AdminUsersRepository _repository;

  Future<void> load({bool refresh = false}) async {
    if (!refresh && state is AdminUsersLoaded) return;
    emit(const AdminUsersLoading());
    try {
      final result = await _repository.getUsers(page: 1);
      if (result.items.isEmpty) {
        emit(const AdminUsersEmpty());
        return;
      }
      emit(
        AdminUsersLoaded(
          items: result.items,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
        ),
      );
    } catch (error) {
      emit(AdminUsersError(_message(error)));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! AdminUsersLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }
    emit(current.copyWith(isLoadingMore: true));
    try {
      final result = await _repository.getUsers(page: current.currentPage + 1);
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

  String _message(Object error) {
    if (error is AppException) return error.message;
    return error.toString();
  }
}
