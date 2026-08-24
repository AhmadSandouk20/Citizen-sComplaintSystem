import 'package:freezed_annotation/freezed_annotation.dart';

import '../agency_model/agency_model.dart';

part 'paginated_agencies_model.freezed.dart';
part 'paginated_agencies_model.g.dart';

@freezed
abstract class PaginatedAgencies with _$PaginatedAgencies {
  const factory PaginatedAgencies({
    @JsonKey(name: "data") required List<AgencyModel> agencies,
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
  }) = _PaginatedAgencies;

  factory PaginatedAgencies.fromJson(Map<String, dynamic> json) =>
      _$PaginatedAgenciesFromJson(json);
}
