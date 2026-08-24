import 'package:dio/dio.dart';
import 'package:final_flutter/core/api/api_service.dart';
import 'package:final_flutter/core/api/endpoints/api_endpoints.dart';
import 'package:final_flutter/features/admin/data/model/users/paginated_users/paginated_users_model.dart';
import 'package:final_flutter/features/admin/domain/user_management_repository.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/error/error_handler.dart';

class UserManagementRepositoryImplementation
    implements UserManagementRepository {
  final APIService _apiService;

  UserManagementRepositoryImplementation(this._apiService);

  @override
  Future<({List<UserModel> users, int total})> getUsers({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await _apiService.getData(
        path: APIEndpoints.ALL_USERS,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final paginated = PaginatedUsers.fromJson(response.data);
      return (users: paginated.data, total: paginated.total);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.putData(
        APIEndpoints.UPDATE_OR_DELETE_USER(id),
        bodyData: data,
      );

      final Map<String, dynamic> json = response.data;
      final Map<String, dynamic> userJson =
          json['user'] as Map<String, dynamic>;

      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await _apiService.deleteData(
        path: APIEndpoints.UPDATE_OR_DELETE_USER(id),
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }
}
