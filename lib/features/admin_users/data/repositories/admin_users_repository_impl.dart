import 'package:final_flutter/core/shared/paginated_result.dart';
import 'package:final_flutter/features/admin_users/data/datasources/admin_users_remote_datasource.dart';
import 'package:final_flutter/features/admin_users/domain/entities/admin_user_entity.dart';
import 'package:final_flutter/features/admin_users/domain/repositories/admin_users_repository.dart';

class AdminUsersRepositoryImpl implements AdminUsersRepository {
  AdminUsersRepositoryImpl(this._remote);

  final AdminUsersRemoteDataSource _remote;

  @override
  Future<PaginatedResult<AdminUserEntity>> getUsers({
    int page = 1,
    int perPage = 15,
  }) {
    return _remote.fetchUsers(page: page, perPage: perPage);
  }

  @override
  Future<AdminUserEntity> getUser(int id) => _remote.fetchUser(id);

  @override
  Future<AdminUserEntity> updateUser({
    required int id,
    required String type,
    required bool isActive,
  }) {
    return _remote.updateUser(id: id, type: type, isActive: isActive);
  }

  @override
  Future<void> deleteUser(int id) => _remote.deleteUser(id);
}
