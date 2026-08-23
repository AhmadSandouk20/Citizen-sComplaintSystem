import 'package:equatable/equatable.dart';

import '../../../../core/files/models/selected_attachment.dart';

enum AttachmentStatus {
  initial,
  selecting,
  ready,
  uploading,
  success,
  error,
  cancelled,
}

class AttachmentState extends Equatable {
  final AttachmentStatus status;
  final List<SelectedAttachment> files;
  final double progress;
  final String? message;
  final String? errorMessage;

  const AttachmentState({
    this.status = AttachmentStatus.initial,
    this.files = const [],
    this.progress = 0,
    this.message,
    this.errorMessage,
  });

  AttachmentState copyWith({
    AttachmentStatus? status,
    List<SelectedAttachment>? files,
    double? progress,
    String? message,
    String? errorMessage,
  }) {
    return AttachmentState(
      status: status ?? this.status,
      files: files ?? this.files,
      progress: progress ?? this.progress,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    files,
    progress,
    message,
    errorMessage,
  ];
}