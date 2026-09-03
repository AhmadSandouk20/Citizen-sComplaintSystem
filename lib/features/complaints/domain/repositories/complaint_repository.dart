import 'package:dio/dio.dart';

import '../../../../core/files/models/selected_attachment.dart';
import '../../data/models/complaints_page_model.dart';
import '../../data/models/create_complaint_result_model.dart';
import '../../data/models/status_history_response_model.dart';
import '../../data/models/track_complaint_model.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintRepository {
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
  });

  Future<ComplaintsPageModel> getComplaints({
    required String token,
    int page = 1,
  });

  Future<ComplaintEntity> getComplaintDetails({
    required String token,
    required int complaintId,
  });

  Future<void> deleteComplaint({
    required String token,
    required int complaintId,
  });

  Future<void> updateComplaint({
    required String token,
    required int complaintId,
    required int agencyId,
    required String title,
    required String description,
    required String locationText,
    required String priority,
  });

  Future<StatusHistoryResponseModel> getStatusHistory({
    required String token,
    required int complaintId,
  });

  Future<TrackComplaintModel> trackComplaint({required String referenceCode});
}
