import 'package:equatable/equatable.dart';

import '../../data/models/create_complaint_result_model.dart';

enum CreateComplaintStatus { initial, submitting, success, error, cancelled }

class CreateComplaintState extends Equatable {
  final CreateComplaintStatus status;
  final double progress;
  final CreateComplaintResultModel? result;
  final String? errorMessage;

  const CreateComplaintState({
    this.status = CreateComplaintStatus.initial,
    this.progress = 0,
    this.result,
    this.errorMessage,
  });

  CreateComplaintState copyWith({
    CreateComplaintStatus? status,
    double? progress,
    CreateComplaintResultModel? result,
    String? errorMessage,
  }) {
    return CreateComplaintState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, progress, result, errorMessage];
}
