import 'package:equatable/equatable.dart';

import '../../domain/entities/attachment_entity.dart';

enum AttachmentGalleryStatus {
  initial,
  loading,
  success,
  error,
}

class AttachmentGalleryState extends Equatable {
  final AttachmentGalleryStatus status;
  final List<AttachmentEntity> attachments;
  final String? errorMessage;

  const AttachmentGalleryState({
    this.status = AttachmentGalleryStatus.initial,
    this.attachments = const [],
    this.errorMessage,
  });

  AttachmentGalleryState copyWith({
    AttachmentGalleryStatus? status,
    List<AttachmentEntity>? attachments,
    String? errorMessage,
  }) {
    return AttachmentGalleryState(
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    attachments,
    errorMessage,
  ];
}