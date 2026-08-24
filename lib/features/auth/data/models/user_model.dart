import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_type_enum.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    String? email,
    String? phone,
    String? password,
    required UserType type,
    @Default(false) @JsonKey(name: "is_active") bool isActive,
    @JsonKey(name: "last_login_at") DateTime? lastLoginAt,
    @JsonKey(name: "failed_login_attempts") int? failedLoginAttempts,
    @JsonKey(name: "locked_until") DateTime? lockedUntil,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(includeFromJson: false) String? token,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
