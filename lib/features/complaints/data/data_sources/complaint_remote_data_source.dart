import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/files/models/selected_attachment.dart';
import '../../../../core/files/services/multipart_upload_service.dart';
import '../models/complaint_model.dart';
import '../models/complaints_page_model.dart';
import '../models/create_complaint_result_model.dart';
import '../models/status_history_response_model.dart';
import '../models/track_complaint_model.dart';

class ComplaintRemoteDataSource {
  final Dio dio;
  final MultipartUploadService uploadService;

  ComplaintRemoteDataSource({required this.dio, required this.uploadService});

  Future<CreateComplaintResultModel> createComplaint({
    required String token,
    required int agencyId,
    required String title,
    required String description,
    required String locationText,
    required String priority,
    List<SelectedAttachment> attachments = const [],
    CancelToken? cancelToken,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final response = await uploadService.upload(
      url: '${AppConfig.apiBaseUrl}/complaints',
      token: token,
      fields: {
        'agency_id': agencyId,
        'title': title,
        'description': description,
        'location_text': locationText,
        'priority': priority,
      },
      files: attachments,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );

    final data = response.data as Map<String, dynamic>;

    return CreateComplaintResultModel.fromJson(data);
  }

  Future<ComplaintsPageModel> getComplaints({
    required String token,
    int page = 1,
  }) async {
    final response = await dio.get(
      '${AppConfig.apiBaseUrl}/complaints',
      queryParameters: {'page': page},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;

    return ComplaintsPageModel.fromJson(data);
  }

  Future<ComplaintModel> getComplaintDetails({
    required String token,
    required int complaintId,
  }) async {
    final response = await dio.get(
      '${AppConfig.apiBaseUrl}/complaints/$complaintId',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;

    return ComplaintModel.fromJson(data);
  }

  Future<void> deleteComplaint({
    required String token,
    required int complaintId,
  }) async {
    await dio.delete(
      '${AppConfig.apiBaseUrl}/complaints/$complaintId',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<void> updateComplaint({
    required String token,
    required int complaintId,
    required int agencyId,
    required String title,
    required String description,
    required String locationText,
    required String priority,
  }) async {
    await dio.put(
      '${AppConfig.apiBaseUrl}/complaints/$complaintId',
      data: {
        'agency_id': agencyId,
        'title': title,
        'description': description,
        'location_text': locationText,
        'priority': priority,
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<StatusHistoryResponseModel> getStatusHistory({
    required String token,
    required int complaintId,
  }) async {
    final response = await dio.get(
      '${AppConfig.apiBaseUrl}/complaints/$complaintId/status-history',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;

    return StatusHistoryResponseModel.fromJson(data);
  }

  Future<TrackComplaintModel> trackComplaint({
    required String referenceCode,
  }) async {
    final response = await dio.get(
      '${AppConfig.apiBaseUrl}/complaints/track/$referenceCode',
      options: Options(headers: {'Accept': 'application/json'}),
    );

    final data = response.data as Map<String, dynamic>;

    return TrackComplaintModel.fromJson(data);
  }
}
