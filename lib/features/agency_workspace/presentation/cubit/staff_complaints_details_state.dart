import 'package:equatable/equatable.dart';

import '../../domain/entities/staff_complaint_entity.dart';
import '../../domain/entities/complaint_revision_entity.dart';
import '../../domain/entities/complaint_status_history_entity.dart';

enum StaffComplaintDetailsStatus {
  initial,
  loading,
  success,
  actionLoading,
  error,
}

class StaffComplaintDetailsState extends Equatable {
  final StaffComplaintDetailsStatus status;
  final StaffComplaintEntity? complaint;
  final String? errorMessage;
  final String? successMessage;
  final List<ComplaintStatusHistoryEntity> statusHistory;

  final List<ComplaintRevisionEntity> revisions;

  const StaffComplaintDetailsState({
    this.status = StaffComplaintDetailsStatus.initial,
    this.complaint,
    this.errorMessage,
    this.successMessage,
    this.statusHistory = const [],
    this.revisions = const [],
  });

  bool get isActionLoading =>
      status == StaffComplaintDetailsStatus.actionLoading;

  StaffComplaintDetailsState copyWith({
    StaffComplaintDetailsStatus? status,
    StaffComplaintEntity? complaint,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    List<ComplaintStatusHistoryEntity>? statusHistory,
    List<ComplaintRevisionEntity>? revisions,
  }) {
    return StaffComplaintDetailsState(
      status: status ?? this.status,
      complaint: complaint ?? this.complaint,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      statusHistory: statusHistory ?? this.statusHistory,

      revisions: revisions ?? this.revisions,
    );
  }

  @override
  List<Object?> get props => [
    status,
    complaint,
    errorMessage,
    successMessage,
    statusHistory,
    revisions,
  ];
}
