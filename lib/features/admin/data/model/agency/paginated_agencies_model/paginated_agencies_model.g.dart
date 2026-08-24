// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_agencies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedAgencies _$PaginatedAgenciesFromJson(Map<String, dynamic> json) =>
    _PaginatedAgencies(
      agencies: (json['data'] as List<dynamic>)
          .map((e) => AgencyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PaginatedAgenciesToJson(_PaginatedAgencies instance) =>
    <String, dynamic>{
      'data': instance.agencies,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };
