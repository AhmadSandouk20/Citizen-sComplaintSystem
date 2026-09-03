import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'package:final_flutter/features/agency_workspace/domain/entities/complaint_revision_entity.dart';
import 'package:final_flutter/features/agency_workspace/domain/entities/complaint_status_history_entity.dart';
import 'package:final_flutter/features/agency_workspace/presentation/cubit/staff_complaints_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/repositories/staff_complaints_repository.dart';

class StaffComplaintDetailsCubit extends Cubit<StaffComplaintDetailsState> {
  final StaffComplaintsRepository repository;

  StaffComplaintDetailsCubit({required this.repository})
    : super(const StaffComplaintDetailsState());

  Future<void> loadComplaint(int complaintId) async {
    emit(
      state.copyWith(
        status: StaffComplaintDetailsStatus.loading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final complaint = await repository.getComplaintDetails(complaintId);

      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          complaint: complaint,
          clearError: true,
        ),
      );

      // بعد نجاح تحميل تفاصيل الشكوى
      await loadHistoryAndRevisions(complaintId);
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.error,
          errorMessage: LocaleKeys.loadDetailsFailed.tr(),
        ),
      );
    }
  }

  Future<void> lockComplaint(int complaintId) async {
    emit(
      state.copyWith(
        status: StaffComplaintDetailsStatus.actionLoading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final complaint = await repository.lockComplaint(complaintId);

      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          complaint: complaint,
          successMessage: LocaleKeys.lockedOk.tr(),
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> unlockComplaint(int complaintId) async {
    emit(
      state.copyWith(
        status: StaffComplaintDetailsStatus.actionLoading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final complaint = await repository.unlockComplaint(complaintId);

      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          complaint: complaint,
          successMessage: LocaleKeys.unlockedOk.tr(),
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> updateComplaint({
    required int complaintId,
    required String status,
    required String priority,
    String? internalNote,
  }) async {
    emit(
      state.copyWith(
        status: StaffComplaintDetailsStatus.actionLoading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final complaint = await repository.updateComplaint(
        complaintId: complaintId,
        status: status,
        priority: priority,
        internalNote: internalNote,
      );

      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          complaint: complaint,
          successMessage: LocaleKeys.complaintUpdated.tr(),
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> loadHistoryAndRevisions(int complaintId) async {
    try {
      final results = await Future.wait([
        repository.getStatusHistory(complaintId),
        repository.getRevisions(complaintId),
      ]);

      emit(
        state.copyWith(
          statusHistory: results[0] as List<ComplaintStatusHistoryEntity>,
          revisions: results[1] as List<ComplaintRevisionEntity>,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
  }

  Future<bool> requestMoreInfo({
    required int complaintId,
    required String message,
  }) async {
    if (message.trim().isEmpty) {
      emit(
        state.copyWith(
          errorMessage: LocaleKeys.messageRequired.tr(),
          clearSuccess: true,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        status: StaffComplaintDetailsStatus.actionLoading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      await repository.requestMoreInfo(
        complaintId: complaintId,
        message: message.trim(),
      );

      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          successMessage: LocaleKeys.requestInfoSent.tr(),
          clearError: true,
        ),
      );

      return true;
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          errorMessage: e.message,
          clearSuccess: true,
        ),
      );

      return false;
    } catch (_) {
      emit(
        state.copyWith(
          status: StaffComplaintDetailsStatus.success,
          errorMessage: LocaleKeys.requestInfoFailed.tr(),
          clearSuccess: true,
        ),
      );

      return false;
    }
  }
}
