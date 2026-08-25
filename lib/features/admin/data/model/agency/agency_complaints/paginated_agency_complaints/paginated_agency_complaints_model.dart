import 'package:freezed_annotation/freezed_annotation.dart';

import '../agency_complaint_model/agency_complaint_model.dart';

part 'paginated_agency_complaints_model.freezed.dart';
part 'paginated_agency_complaints_model.g.dart';

@freezed
abstract class PaginatedAgencyComplaints with _$PaginatedAgencyComplaints {
  const factory PaginatedAgencyComplaints({
    @JsonKey(name: 'current_page') required int currentPage,
    required List<AgencyComplaintModel> data,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
  }) = _PaginatedAgencyComplaints;

  factory PaginatedAgencyComplaints.fromJson(Map<String, dynamic> json) =>
      _$PaginatedAgencyComplaintsFromJson(json);
}
