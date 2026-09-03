import '../../../attachments/data/models/attachment_model.dart';
import '../../domain/entities/staff_complaint_entity.dart';

class StaffComplaintModel extends StaffComplaintEntity {
  const StaffComplaintModel({
    required super.id,
    required super.referenceCode,
    required super.title,
    required super.description,
    super.locationText,
    required super.status,
    required super.priority,
    super.lockedById,
    super.lockedByName,
    super.lockedAt,
    super.closedAt,
    required super.user,
    required super.agency,
    super.attachments,
    super.createdAt,
    super.updatedAt,
  });

  factory StaffComplaintModel.fromJson(Map<String, dynamic> json) {
    final lockedBy = json['locked_by'];

    int? lockedById;
    String? lockedByName;

    if (lockedBy is int) {
      lockedById = lockedBy;
    } else if (lockedBy is Map) {
      final lockMap = Map<String, dynamic>.from(lockedBy);

      lockedById = lockMap['id'] as int?;
      lockedByName = lockMap['name'] as String?;
    }

    final userJson = Map<String, dynamic>.from(json['user'] as Map);

    final agencyJson = Map<String, dynamic>.from(json['agency'] as Map);

    final attachmentsJson = json['attachments'] as List<dynamic>? ?? const [];

    return StaffComplaintModel(
      id: json['id'] as int,
      referenceCode: json['reference_code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      locationText: json['location_text'] as String?,
      status: json['status'] as String? ?? '',
      priority: json['priority'] as String? ?? '',

      lockedById: lockedById,
      lockedByName: lockedByName,

      lockedAt: json['locked_at'] != null
          ? DateTime.tryParse(json['locked_at'].toString())
          : null,

      closedAt: json['closed_at'] != null
          ? DateTime.tryParse(json['closed_at'].toString())
          : null,

      user: ComplaintUserEntity(
        id: userJson['id'] as int,
        name: userJson['name'] as String? ?? '',
        email: userJson['email'] as String?,
        phone: userJson['phone'] as String?,
      ),

      agency: ComplaintAgencyEntity(
        id: agencyJson['id'] as int,
        name: agencyJson['name'] as String? ?? '',
      ),

      attachments: attachmentsJson
          .whereType<Map<String, dynamic>>()
          .map(AttachmentModel.fromJson)
          .toList(),

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}
