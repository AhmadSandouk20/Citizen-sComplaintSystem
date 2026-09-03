import 'package:final_flutter/features/agency_workspace/domain/entities/complaint_revision_entity.dart';
import 'package:final_flutter/features/agency_workspace/domain/entities/complaint_status_history_entity.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/shared/paginated_result.dart';
import '../../domain/entities/staff_complaint_entity.dart';
import '../../domain/repositories/staff_complaints_repository.dart';
import '../data_sources/staff_complaints_remote_data_source.dart';

class StaffComplaintsRepositoryImpl implements StaffComplaintsRepository {
  final StaffComplaintsRemoteDataSource remoteDataSource;

  StaffComplaintsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedResult<StaffComplaintEntity>> getComplaints({
    int page = 1,
    int perPage = 15,
    String? status,
    String? priority,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      return await remoteDataSource.getComplaints(
        page: page,
        perPage: perPage,
        status: status,
        priority: priority,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<StaffComplaintEntity> getComplaintDetails(int complaintId) async {
    try {
      return await remoteDataSource.getComplaintDetails(complaintId);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<StaffComplaintEntity> lockComplaint(int complaintId) async {
    try {
      await remoteDataSource.lockComplaint(complaintId);

      return await remoteDataSource.getComplaintDetails(complaintId);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<StaffComplaintEntity> unlockComplaint(int complaintId) async {
    try {
      await remoteDataSource.unlockComplaint(complaintId);

      return await remoteDataSource.getComplaintDetails(complaintId);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<StaffComplaintEntity> updateComplaint({
    required int complaintId,
    String? status,
    String? priority,
    String? internalNote,
  }) async {
    try {
      await remoteDataSource.updateComplaint(
        complaintId: complaintId,
        status: status,
        priority: priority,
        internalNote: internalNote,
      );

      // مهم: نقرأ الحقيقة من السيرفر بعد التعديل.
      return await remoteDataSource.getComplaintDetails(complaintId);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<List<ComplaintStatusHistoryEntity>> getStatusHistory(
    int complaintId,
  ) async {
    try {
      return await remoteDataSource.getStatusHistory(complaintId);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<List<ComplaintRevisionEntity>> getRevisions(int complaintId) async {
    try {
      return await remoteDataSource.getRevisions(complaintId);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<void> requestMoreInfo({
    required int complaintId,
    required String message,
  }) async {
    try {
      await remoteDataSource.requestMoreInfo(
        complaintId: complaintId,
        message: message,
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }
}
