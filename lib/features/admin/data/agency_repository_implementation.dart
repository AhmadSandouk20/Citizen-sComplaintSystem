import 'package:dio/dio.dart';

import '../../../core/api/api_service.dart';
import '../../../core/api/endpoints/api_endpoints.dart';
import '../../../core/error/app_exception.dart';

import '../../../core/error/error_handler.dart';
import '../domain/agency_repository.dart';
import 'model/agency/agency_model/agency_model.dart';
import 'model/agency/paginated_agencies_model/paginated_agencies_model.dart';

class AgencyRepositoryImplementation extends AgencyRepository {
  final APIService _apiService;

  AgencyRepositoryImplementation(this._apiService);

  @override
  Future<PaginatedAgencies> getAgencies({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final Response agenciesJson = await _apiService.getData(
        path: APIEndpoints.ALL_AGENCIES,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      return PaginatedAgencies.fromJson(agenciesJson.data);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<AgencyModel> getAgencyDetails(int id) async {
    try {
      final Response agenciesJson = await _apiService.getData(
        path: APIEndpoints.AGENCY_DETAILS(id),
      );
      return AgencyModel.fromJson(agenciesJson.data);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<AgencyModel> addAgency(AgencyModel newAgency) async {
    try {
      final Response agenciesJson = await _apiService.postData(
        APIEndpoints.ADD_AGENCY,
        bodyData: newAgency.toJson(),
      );
      return AgencyModel.fromJson(agenciesJson.data['agency']);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<AgencyModel> updateAgency(int id, AgencyModel updatedModel) async {
    try {
      final Response agenciesJson = await _apiService.putData(
        APIEndpoints.UPDATE_AGENCY(id),
        bodyData: updatedModel.toJson(),
      );
      return AgencyModel.fromJson(agenciesJson.data['agency']);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteAgency(int id) async {
    try {
      await _apiService.deleteData(path: APIEndpoints.DELETE_AGENCY(id));
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }
}
