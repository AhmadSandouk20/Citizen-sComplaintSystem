import 'package:equatable/equatable.dart';

import '../../../attachments/domain/entities/attachment_entity.dart';

class StaffComplaintEntity extends Equatable {
  final int id;
  final String referenceCode;
  final String title;
  final String description;
  final String? locationText;

  final String status;
  final String priority;

  final int? lockedById;
  final String? lockedByName;
  final DateTime? lockedAt;
  final DateTime? closedAt;

  final ComplaintUserEntity user;
  final ComplaintAgencyEntity agency;

  final List<AttachmentEntity> attachments;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StaffComplaintEntity({
    required this.id,
    required this.referenceCode,
    required this.title,
    required this.description,
    this.locationText,
    required this.status,
    required this.priority,
    this.lockedById,
    this.lockedByName,
    this.lockedAt,
    this.closedAt,
    required this.user,
    required this.agency,
    this.attachments = const [],
    this.createdAt,
    this.updatedAt,
  });

  bool get isLocked => lockedById != null;

  bool isLockedByMe(int currentUserId) {
    return lockedById == currentUserId;
  }

  bool isLockedByAnother(int currentUserId) {
    return lockedById != null && lockedById != currentUserId;
  }

  @override
  List<Object?> get props => [
    id,
    referenceCode,
    title,
    description,
    locationText,
    status,
    priority,
    lockedById,
    lockedByName,
    lockedAt,
    closedAt,
    user,
    agency,
    attachments,
    createdAt,
    updatedAt,
  ];
}

class ComplaintUserEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;

  const ComplaintUserEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, email, phone];
}

class ComplaintAgencyEntity extends Equatable {
  final int id;
  final String name;

  const ComplaintAgencyEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
