import 'package:dio/dio.dart';
import 'package:final_flutter/core/api/api_base.dart';
import 'package:final_flutter/core/api/api_service.dart';
import 'package:final_flutter/core/api/endpoints/api_endpoints.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/error/error_handler.dart';
import '../../auth/data/models/user_model.dart';
import '../domain/staff_management_repository.dart';

class StaffManagementRepoImplementation implements StaffManagementRepository {
  final APIService _apiService;

  StaffManagementRepoImplementation(this._apiService);

  @override
  Future<List<UserModel>> getAgencyStaff(int agencyId) async {
    try {
      final response = await _apiService.getData(
        path: APIEndpoints.AGENCY_STAFF(agencyId),
      );

      final data = response.data as Map<String, dynamic>;
      final list = data['users'] as List;
      return list
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> createStaffForAgency(
    int agencyId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _apiService.postData(
        APIEndpoints.CREATE_STAFF(agencyId),
        bodyData: userData,
      );
      final data = response.data as Map<String, dynamic>;
      final userJson = data['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<void> transferStaff(int agencyId, int userId, int newAgencyId) async {
    final path = '/agencies/$agencyId/users/$userId';

    await _apiService.putData(path, bodyData: {'new_agency_id': newAgencyId});
  }

  @override
  Future<void> removeStaffFromAgency(int agencyId, int userId) async {
    try {
      await _apiService.deleteData(path: '/agencies/$agencyId/users/$userId');
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }
}
