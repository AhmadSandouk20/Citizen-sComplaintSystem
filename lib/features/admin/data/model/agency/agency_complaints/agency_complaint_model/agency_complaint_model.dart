import 'package:freezed_annotation/freezed_annotation.dart';

part 'agency_complaint_model.freezed.dart';
part 'agency_complaint_model.g.dart';

@freezed
abstract class AgencyComplaintModel with _$AgencyComplaintModel {
  const factory AgencyComplaintModel({
    required int id,
    @JsonKey(name: 'reference_code') required String referenceCode,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'agency_id') required int agencyId,
    required String title,
    required String description,
    @JsonKey(name: 'location_text') required String locationText,
    required String status,
    required String priority,
    @JsonKey(name: 'locked_by') int? lockedBy,
    @JsonKey(name: 'locked_at') String? lockedAt,
    @JsonKey(name: 'closed_at') String? closedAt,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    Map<String, dynamic>? user,
    Map<String, dynamic>? agency,
  }) = _AgencyComplaintModel;

  factory AgencyComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$AgencyComplaintModelFromJson(json);
}
