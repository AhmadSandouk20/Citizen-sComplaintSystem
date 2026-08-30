import 'package:equatable/equatable.dart';

class ComplaintStatusHistoryEntity extends Equatable {
  final int id;
  final int complaintId;
  final String? oldStatus;
  final String newStatus;
  final int changedById;
  final String changedByName;
  final String? note;
  final DateTime? changedAt;

  const ComplaintStatusHistoryEntity({
    required this.id,
    required this.complaintId,
    this.oldStatus,
    required this.newStatus,
    required this.changedById,
    required this.changedByName,
    this.note,
    this.changedAt,
  });

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
