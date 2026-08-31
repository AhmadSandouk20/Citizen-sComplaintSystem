import 'package:equatable/equatable.dart';

class ComplaintRevisionEntity extends Equatable {
  final int id;
  final int complaintId;
  final int versionNumber;
  final Map<String, dynamic> data;
  final int changedById;
  final String changedByName;
  final DateTime? changedAt;

  const ComplaintRevisionEntity({
    required this.id,
    required this.complaintId,
    required this.versionNumber,
    required this.data,
    required this.changedById,
    required this.changedByName,
    this.changedAt,
  });

  String get status => data['status']?.toString() ?? '';

  String get priority => data['priority']?.toString() ?? '';

  String get title => data['title']?.toString() ?? '';

  String get description => data['description']?.toString() ?? '';

  @override
  List<Object?> get props => [
    id,
    complaintId,
    versionNumber,
    data,
    changedById,
    changedByName,
    changedAt,
  ];
}
