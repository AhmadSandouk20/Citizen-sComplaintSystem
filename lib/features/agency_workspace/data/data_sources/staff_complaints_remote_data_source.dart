import 'package:dio/dio.dart';
import 'package:final_flutter/features/agency_workspace/data/models/complaint_revision_model.dart';
import 'package:final_flutter/features/agency_workspace/data/models/complaint_status_history_model.dart';

import '../../../../core/shared/paginated_result.dart';
import '../models/staff_complaint_model.dart';

class StaffComplaintsRemoteDataSource {
  final Dio dio;

  StaffComplaintsRemoteDataSource({required this.dio});

  Future<PaginatedResult<StaffComplaintModel>> getComplaints({
    int page = 1,
    int perPage = 15,
    String? status,
    String? priority,
    String? dateFrom,
    String? dateTo,
  }) async {
    final response = await dio.get(
      '/agency/complaints',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (status != null && status.isNotEmpty) 'status': status,
        if (priority != null && priority.isNotEmpty) 'priority': priority,
        if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
        if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map);

    return PaginatedResult<StaffComplaintModel>.fromJson(
      data,
      StaffComplaintModel.fromJson,
    );
  }

  Future<StaffComplaintModel> getComplaintDetails(int complaintId) async {
    final response = await dio.get('/agency/complaints/$complaintId');

    return StaffComplaintModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> lockComplaint(int complaintId) async {
    await dio.post('/agency/complaints/$complaintId/lock');
  }

  Future<void> unlockComplaint(int complaintId) async {
    await dio.post('/agency/complaints/$complaintId/unlock');
  }

  Future<List<ComplaintStatusHistoryModel>> getStatusHistory(
    int complaintId,
  ) async {
    final response = await dio.get(
      '/agency/complaints/$complaintId/status-history',
    );

    final data = Map<String, dynamic>.from(response.data as Map);

    final list = data['status_history'] as List<dynamic>? ?? const [];

    return list
        .whereType<Map>()
        .map(
          (item) => ComplaintStatusHistoryModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<List<ComplaintRevisionModel>> getRevisions(int complaintId) async {
    final response = await dio.get('/agency/complaints/$complaintId/revisions');

    final data = Map<String, dynamic>.from(response.data as Map);

    final list = data['revisions'] as List<dynamic>? ?? const [];

    return list
        .whereType<Map>()
        .map(
          (item) =>
              ComplaintRevisionModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<void> updateComplaint({
    required int complaintId,
    String? status,
    String? priority,
    String? internalNote,
  }) async {
    await dio.put(
      '/agency/complaints/$complaintId',
      data: {
        'status': ?status,
        'priority': ?priority,
        if (internalNote != null && internalNote.trim().isNotEmpty)
          'internal_note': internalNote.trim(),
      },
    );
  }

  Future<int?> requestMoreInfo({
    required int complaintId,
    required String message,
  }) async {
    final response = await dio.post(
      '/agency/complaints/$complaintId/request-info',
      data: {'message': message.trim()},
    );

    final data = Map<String, dynamic>.from(response.data as Map);

    return data['notification_id'] as int?;
  }
}
