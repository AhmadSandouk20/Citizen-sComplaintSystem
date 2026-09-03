import '../../../../core/shared/paginated_result.dart';
import '../entities/staff_complaint_entity.dart';
import '../entities/complaint_revision_entity.dart';
import '../entities/complaint_status_history_entity.dart';

abstract class StaffComplaintsRepository {
  Future<PaginatedResult<StaffComplaintEntity>> getComplaints({
    int page = 1,
    int perPage = 15,
    String? status,
    String? priority,
    String? dateFrom,
    String? dateTo,
  });

  Future<StaffComplaintEntity> getComplaintDetails(int complaintId);

  Future<StaffComplaintEntity> lockComplaint(int complaintId);

  Future<StaffComplaintEntity> unlockComplaint(int complaintId);

  Future<StaffComplaintEntity> updateComplaint({
    required int complaintId,
    String? status,
    String? priority,
    String? internalNote,
  });

  Future<List<ComplaintStatusHistoryEntity>> getStatusHistory(int complaintId);

  Future<List<ComplaintRevisionEntity>> getRevisions(int complaintId);

  Future<void> requestMoreInfo({
    required int complaintId,
    required String message,
  });
}
