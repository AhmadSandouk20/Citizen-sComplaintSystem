import 'package:equatable/equatable.dart';

class StatusHistoryModel extends Equatable {
  final int id;
  final int complaintId;
  final String? oldStatus;
  final String newStatus;
  final int? changedById;
  final String? changedByName;
  final String? note;
  final DateTime? changedAt;

  const StatusHistoryModel({
    required this.id,
    required this.complaintId,
    required this.oldStatus,
    required this.newStatus,
    this.changedById,
    this.changedByName,
    this.note,
    this.changedAt,
  });

  factory StatusHistoryModel.fromJson(Map<String, dynamic> json) {
    final changedBy = json['changed_by'] as Map<String, dynamic>?;

    return StatusHistoryModel(
      id: json['id'] as int,
      complaintId: json['complaint_id'] as int,
      oldStatus: json['old_status'] as String?,
      newStatus: json['new_status'] as String? ?? '',
      changedById: changedBy?['id'] as int?,
      changedByName: changedBy?['name'] as String?,
      note: json['note'] as String?,
      changedAt: json['changed_at'] != null
          ? DateTime.tryParse(json['changed_at'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    complaintId,
    oldStatus,
    newStatus,
    changedById,
    changedByName,
    note,
    changedAt,
  ];
}
