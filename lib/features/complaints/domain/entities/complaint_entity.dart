import 'package:equatable/equatable.dart';

import '../../../attachments/domain/entities/attachment_entity.dart';

class ComplaintEntity extends Equatable {
  final int id;
  final String referenceCode;
  final String title;
  final String description;
  final String? locationText;
  final String status;
  final String priority;
  final int agencyId;
  final String agencyName;
  final List<AttachmentEntity> attachments;
  final DateTime? createdAt;

  const ComplaintEntity({
    required this.id,
    required this.referenceCode,
    required this.title,
    required this.description,
    this.locationText,
    required this.status,
    required this.priority,
    required this.agencyId,
    required this.agencyName,
    this.attachments = const [],
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    referenceCode,
    title,
    description,
    locationText,
    status,
    priority,
    agencyId,
    agencyName,
    attachments,
    createdAt,
  ];
}
