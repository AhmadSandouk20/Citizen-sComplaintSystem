import 'package:equatable/equatable.dart';

enum UpdateComplaintStatus { initial, loading, success, error }

class UpdateComplaintState extends Equatable {
  final UpdateComplaintStatus status;
  final String? errorMessage;

  const UpdateComplaintState({
    this.status = UpdateComplaintStatus.initial,
    this.errorMessage,
  });

  UpdateComplaintState copyWith({
    UpdateComplaintStatus? status,
    String? errorMessage,
  }) {
    return UpdateComplaintState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
