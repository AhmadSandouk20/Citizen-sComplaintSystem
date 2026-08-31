import '../../domain/entities/complaint_revision_entity.dart';

class ComplaintRevisionModel extends ComplaintRevisionEntity {
  const ComplaintRevisionModel({
    required super.id,
    required super.complaintId,
    required super.versionNumber,
    required super.data,
    required super.changedById,
    required super.changedByName,
    super.changedAt,
  });

  factory ComplaintRevisionModel.fromJson(Map<String, dynamic> json) {
    final changedBy = Map<String, dynamic>.from(json['changed_by'] as Map);

    final revisionData = Map<String, dynamic>.from(json['data'] as Map);

    return ComplaintRevisionModel(
      id: json['id'] as int,
      complaintId: json['complaint_id'] as int,
      versionNumber: json['version_number'] as int,
      data: revisionData,
      changedById: changedBy['id'] as int,
      changedByName: changedBy['name'] as String? ?? '',
      changedAt: json['changed_at'] != null
          ? DateTime.tryParse(json['changed_at'].toString())
          : null,
    );
  }
}
