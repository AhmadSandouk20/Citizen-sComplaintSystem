import '../../domain/entities/complaint_status_history_entity.dart';

class ComplaintStatusHistoryModel extends ComplaintStatusHistoryEntity {
  const ComplaintStatusHistoryModel({
    required super.id,
    required super.complaintId,
    super.oldStatus,
    required super.newStatus,
    required super.changedById,
    required super.changedByName,
    super.note,
    super.changedAt,
  });

  factory ComplaintStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    final changedBy = Map<String, dynamic>.from(json['changed_by'] as Map);

    return ComplaintStatusHistoryModel(
      id: json['id'] as int,
      complaintId: json['complaint_id'] as int,
      oldStatus: json['old_status'] as String?,
      newStatus: json['new_status'] as String? ?? '',
      changedById: changedBy['id'] as int,
      changedByName: changedBy['name'] as String? ?? '',
      note: json['note'] as String?,
      changedAt: json['changed_at'] != null
          ? DateTime.tryParse(json['changed_at'].toString())
          : null,
    );
  }
}
