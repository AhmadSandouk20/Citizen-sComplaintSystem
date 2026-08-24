import 'package:dio/dio.dart';
import 'package:final_flutter/core/api/endpoints/api_endpoints.dart';
import 'package:final_flutter/features/admin/domain/agency_complaints_repository.dart';

import '../../../core/api/api_service.dart';
import '../../../core/error/app_exception.dart';

import '../../../core/error/error_handler.dart';
import 'model/agency/agency_complaints/paginated_agency_complaints/paginated_agency_complaints_model.dart';

class AgencyComplaintsRepositoryImplementation
    extends AgencyComplaintsRepository {
  final APIService _apiService;

  AgencyComplaintsRepositoryImplementation(this._apiService);

  @override
  Future<PaginatedAgencyComplaints> getAgencyComplaints(
    int agencyId, {
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final Response response = await _apiService.getData(
        path: APIEndpoints.AGENCY_COMPLAINTS(agencyId),
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final data = response.data;
      Map<String, dynamic> paginatedJson;

      if (data is Map<String, dynamic> && data.containsKey('complaints')) {
        paginatedJson = data['complaints'] as Map<String, dynamic>;
      } else {
        paginatedJson = data as Map<String, dynamic>;
      }

      return PaginatedAgencyComplaints.fromJson(paginatedJson);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }
}
