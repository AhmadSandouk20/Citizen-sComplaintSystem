import 'package:dio/dio.dart';

import '../../../../core/files/models/selected_attachment.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../data_sources/complaint_remote_data_source.dart';
import '../models/complaints_page_model.dart';
import '../models/create_complaint_result_model.dart';
import '../models/status_history_response_model.dart';
import '../models/track_complaint_model.dart';

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDataSource remoteDataSource;

  ComplaintRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) {
    return remoteDataSource.createComplaint(
      token: token,
      agencyId: agencyId,
      title: title,
      description: description,
      locationText: locationText,
      priority: priority,
      attachments: attachments,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  @override
  Future<ComplaintsPageModel> getComplaints({
    required String token,
    int page = 1,
  }) {
    return remoteDataSource.getComplaints(token: token, page: page);
  }

  @override
  Future<ComplaintEntity> getComplaintDetails({
    required String token,
    required int complaintId,
  }) {
    return remoteDataSource.getComplaintDetails(
      token: token,
      complaintId: complaintId,
    );
  }

  @override
  Future<void> deleteComplaint({
    required String token,
    required int complaintId,
  }) {
    return remoteDataSource.deleteComplaint(
      token: token,
      complaintId: complaintId,
    );
  }

  @override
  Future<void> updateComplaint({
    required String token,
    required int complaintId,
    required int agencyId,
    required String title,
    required String description,
    required String locationText,
    required String priority,
  }) {
    return remoteDataSource.updateComplaint(
      token: token,
      complaintId: complaintId,
      agencyId: agencyId,
      title: title,
      description: description,
      locationText: locationText,
      priority: priority,
    );
  }

  @override
  Future<StatusHistoryResponseModel> getStatusHistory({
    required String token,
    required int complaintId,
  }) {
    return remoteDataSource.getStatusHistory(
      token: token,
      complaintId: complaintId,
    );
  }

  @override
  Future<TrackComplaintModel> trackComplaint({required String referenceCode}) {
    return remoteDataSource.trackComplaint(referenceCode: referenceCode);
  }
}
