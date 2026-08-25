import 'package:final_flutter/core/shared/paginated_result.dart';
import 'package:final_flutter/features/admin_users/domain/entities/admin_user_entity.dart';

abstract class AdminUsersRepository {
  Future<PaginatedResult<AdminUserEntity>> getUsers({
    int page = 1,
    int perPage = 15,
  });

  Future<AdminUserEntity> getUser(int id);

  Future<AdminUserEntity> updateUser({
    required int id,
    required String type,
    required bool isActive,
  });

  Future<void> deleteUser(int id);
}
