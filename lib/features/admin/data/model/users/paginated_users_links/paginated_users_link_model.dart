import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_users_link_model.freezed.dart';
part 'paginated_users_link_model.g.dart';

@freezed
abstract class PaginatedUsersLinkModel with _$PaginatedUsersLinkModel {
  const factory PaginatedUsersLinkModel({
    String? url,
    String? label,
    bool? active,
  }) = _PaginatedUsersLinkModel;

  factory PaginatedUsersLinkModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUsersLinkModelFromJson(json);
}
