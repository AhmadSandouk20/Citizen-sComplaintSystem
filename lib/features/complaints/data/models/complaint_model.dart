import '../../../attachments/data/models/attachment_model.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({
    required super.id,
    required super.referenceCode,
    required super.title,
    required super.description,
    super.locationText,
    required super.status,
    required super.priority,
    required super.agencyId,
    required super.agencyName,
    super.attachments,
    super.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final agency = json['agency'] as Map<String, dynamic>?;

    final attachmentsJson = json['attachments'] as List? ?? [];

    return ComplaintModel(
      id: json['id'] as int,
      referenceCode: json['reference_code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      locationText: json['location_text'] as String?,
      status: json['status'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
      agencyId: json['agency_id'] as int? ?? agency?['id'] as int? ?? 0,
      agencyName: agency?['name'] as String? ?? '',
      attachments: attachmentsJson
          .map((item) => AttachmentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
