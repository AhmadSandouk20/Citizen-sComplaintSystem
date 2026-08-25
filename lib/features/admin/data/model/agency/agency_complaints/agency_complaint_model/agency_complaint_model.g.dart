// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency_complaint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgencyComplaintModel _$AgencyComplaintModelFromJson(
  Map<String, dynamic> json,
) => _AgencyComplaintModel(
  id: (json['id'] as num).toInt(),
  referenceCode: json['reference_code'] as String,
  userId: (json['user_id'] as num).toInt(),
  agencyId: (json['agency_id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  locationText: json['location_text'] as String,
  status: json['status'] as String,
  priority: json['priority'] as String,
  lockedBy: (json['locked_by'] as num?)?.toInt(),
  lockedAt: json['locked_at'] as String?,
  closedAt: json['closed_at'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  user: json['user'] as Map<String, dynamic>?,
  agency: json['agency'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AgencyComplaintModelToJson(
  _AgencyComplaintModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference_code': instance.referenceCode,
  'user_id': instance.userId,
  'agency_id': instance.agencyId,
  'title': instance.title,
  'description': instance.description,
  'location_text': instance.locationText,
  'status': instance.status,
  'priority': instance.priority,
  'locked_by': instance.lockedBy,
  'locked_at': instance.lockedAt,
  'closed_at': instance.closedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'user': instance.user,
  'agency': instance.agency,
};
