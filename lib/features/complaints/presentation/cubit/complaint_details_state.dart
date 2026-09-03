import 'package:equatable/equatable.dart';

import '../../domain/entities/complaint_entity.dart';

enum ComplaintDetailsStatus {
  initial,
  loading,
  success,
  deleting,
  deleted,
  error,
}

class ComplaintDetailsState extends Equatable {
  final ComplaintDetailsStatus status;
  final ComplaintEntity? complaint;
  final String? errorMessage;

  const ComplaintDetailsState({
    this.status = ComplaintDetailsStatus.initial,
    this.complaint,
    this.errorMessage,
  });

  ComplaintDetailsState copyWith({
    ComplaintDetailsStatus? status,
    ComplaintEntity? complaint,
    String? errorMessage,
  }) {
    return ComplaintDetailsState(
      status: status ?? this.status,
      complaint: complaint ?? this.complaint,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, complaint, errorMessage];
}
