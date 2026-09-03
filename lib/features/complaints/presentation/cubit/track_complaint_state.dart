import 'package:equatable/equatable.dart';

import '../../data/models/track_complaint_model.dart';

enum TrackComplaintStatus { initial, loading, success, error }

class TrackComplaintState extends Equatable {
  final TrackComplaintStatus status;
  final TrackComplaintModel? complaint;
  final String? errorMessage;

  const TrackComplaintState({
    this.status = TrackComplaintStatus.initial,
    this.complaint,
    this.errorMessage,
  });

  TrackComplaintState copyWith({
    TrackComplaintStatus? status,
    TrackComplaintModel? complaint,
    String? errorMessage,
  }) {
    return TrackComplaintState(
      status: status ?? this.status,
      complaint: complaint ?? this.complaint,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, complaint, errorMessage];
}
