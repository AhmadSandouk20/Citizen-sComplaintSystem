import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import '../paginated_users_links/paginated_users_link_model.dart';

part 'paginated_users_model.freezed.dart';
part 'paginated_users_model.g.dart';

@freezed
abstract class PaginatedUsers with _$PaginatedUsers {
  const factory PaginatedUsers({
    @JsonKey(name: 'current_page') required int currentPage,
    required List<UserModel> data,
    @JsonKey(name: 'first_page_url') String? firstPageUrl,
    int? from,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'last_page_url') String? lastPageUrl,
    List<PaginatedUsersLinkModel>? links,
    @JsonKey(name: 'next_page_url') String? nextPageUrl,
    String? path,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'prev_page_url') String? prevPageUrl,
    int? to,
    required int total,
  }) = _PaginatedUsers;

  factory PaginatedUsers.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUsersFromJson(json);
}
