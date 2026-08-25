import 'package:final_flutter/features/admin/domain/user_management_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/core/error/app_exception.dart';

import 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final UserManagementRepository _repository;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  int _total = 0;
  static const int _perPage = 15;

  final List<UserModel> _users = [];

  UserManagementCubit(this._repository) : super(UserManagementInitial());

  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _users.clear();
      _total = 0;
      emit(UserManagementLoading());
    } else if (state is UserManagementLoaded && !_hasMore) {
      return;
    }

    if (_currentPage == 1) {
      emit(UserManagementLoading());
    } else {
      _isLoadingMore = true;
      if (state is UserManagementLoaded) {
        emit((state as UserManagementLoaded).copyWith(isLoadingMore: true));
      }
    }

    try {
      final result = await _repository.getUsers(
        page: _currentPage,
        perPage: _perPage,
      );

      final newUsers = result.users;
      _users.addAll(newUsers);
      _total = result.total;

      _hasMore = newUsers.length == _perPage;
      _currentPage++;

      emit(
        UserManagementLoaded(
          users: List.unmodifiable(_users),
          hasMore: _hasMore,
          isLoadingMore: false,
          currentPage: _currentPage,
          total: _total,
        ),
      );
    } on AppException catch (e) {
      if (_currentPage == 1) {
        emit(UserManagementError(e.message));
      } else {
        if (state is UserManagementLoaded) {
          emit((state as UserManagementLoaded).copyWith(isLoadingMore: false));
        }
      }
    } catch (e) {
      if (_currentPage == 1) {
        emit(UserManagementError('Something went wrong. Please try again.'));
      } else {
        if (state is UserManagementLoaded) {
          emit((state as UserManagementLoaded).copyWith(isLoadingMore: false));
        }
      }
    }
  }

  void loadMore() {
    if (_hasMore && !_isLoadingMore && state is UserManagementLoaded) {
      loadUsers();
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _repository.deleteUser(userId);
      _users.removeWhere((u) => u.id == userId);
      _total--;

      if (state is UserManagementLoaded) {
        emit(
          (state as UserManagementLoaded).copyWith(
            users: List.unmodifiable(_users),
            total: _total,
          ),
        );
      }
    } on AppException catch (e) {
      emit(UserManagementError(e.message));
    } catch (e) {
      emit(UserManagementError('Something went wrong. Please try again.'));
    }
  }

  Future<void> toggleActive(UserModel user) async {
    try {
      final updated = await _repository.updateUser(user.id, {
        'is_active': !user.isActive,
      });
      _replaceUser(updated);
    } on AppException catch (e) {
      emit(UserManagementError(e.message));
    } catch (e) {
      emit(UserManagementError('Something went wrong. Please try again.'));
    }
  }

  Future<void> changeRole(UserModel user, UserRole newRole) async {
    try {
      final updated = await _repository.updateUser(user.id, {
        'type': newRole.name,
      });
      _replaceUser(updated);
    } on AppException catch (e) {
      emit(UserManagementError(e.message));
    } catch (e) {
      emit(UserManagementError('Something went wrong. Please try again.'));
    }
  }

  void _replaceUser(UserModel updated) {
    final index = _users.indexWhere((u) => u.id == updated.id);
    if (index != -1) {
      _users[index] = updated;
      if (state is UserManagementLoaded) {
        emit(
          (state as UserManagementLoaded).copyWith(
            users: List.unmodifiable(_users),
          ),
        );
      }
    }
  }
}
