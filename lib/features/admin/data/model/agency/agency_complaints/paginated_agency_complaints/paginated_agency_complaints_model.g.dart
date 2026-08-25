// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_agency_complaints_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedAgencyComplaints _$PaginatedAgencyComplaintsFromJson(
  Map<String, dynamic> json,
) => _PaginatedAgencyComplaints(
  currentPage: (json['current_page'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => AgencyComplaintModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  lastPage: (json['last_page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedAgencyComplaintsToJson(
  _PaginatedAgencyComplaints instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'data': instance.data,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
};
