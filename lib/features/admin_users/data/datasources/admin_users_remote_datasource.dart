import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/core/shared/paginated_result.dart';
import 'package:final_flutter/features/admin_users/data/models/admin_user_model.dart';

class AdminUsersRemoteDataSource {
  AdminUsersRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<PaginatedResult<AdminUserModel>> fetchUsers({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _dioClient.client.get(
        '/admin/users',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final data = response.data;
      if (data is! Map) {
        throw const AppException('Unexpected users response.');
      }
      return PaginatedResult.fromJson(
        Map<String, dynamic>.from(data),
        (json) => AdminUserModel.fromJson(json),
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<AdminUserModel> fetchUser(int id) async {
    try {
      final response = await _dioClient.client.get('/admin/users/$id');
      final data = response.data;
      if (data is! Map) {
        throw const AppException('Unexpected user response.');
      }
      final map = Map<String, dynamic>.from(data);
      final raw = map['user'] ?? map['data'] ?? map;
      if (raw is! Map) {
        throw const AppException('Unexpected user response.');
      }
      return AdminUserModel.fromJson(Map<String, dynamic>.from(raw));
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<AdminUserModel> updateUser({
    required int id,
    required String type,
    required bool isActive,
  }) async {
    try {
      final response = await _dioClient.client.put(
        '/admin/users/$id',
        data: {'type': type, 'is_active': isActive},
      );
      final data = response.data;
      if (data is Map && data['user'] is Map) {
        return AdminUserModel.fromJson(
          Map<String, dynamic>.from(data['user'] as Map),
        );
      }
      return fetchUser(id);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dioClient.client.delete('/admin/users/$id');
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }
}
