import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role_enum.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// The authenticated user plus the bearer token that identifies the session.
///
/// The token is part of the model on purpose: it is what `AuthCubit.token`
/// hands to the Dio interceptor and to the FCM registration call. It is not
/// part of the user JSON, so it is excluded from `fromJson` and attached with
/// `copyWith(token: ...)` after parsing.
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    // Laravel can serialise an id as a string depending on the driver, so the
    // parse is deliberate rather than a plain `as num` cast.
    @JsonKey(fromJson: _idFromJson) required int id,
    required String name,
    String? email,
    String? phone,

    /// Maps the backend `users.type` enum. Serialized as citizen/staff/admin.
    @JsonKey(name: 'type', unknownEnumValue: UserRole.citizen)
    required UserRole role,

    @Default(true) @JsonKey(name: 'is_active') bool isActive,

    // Login-attempt fields backing the "account locked" screen.
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'failed_login_attempts') int? failedLoginAttempts,
    @JsonKey(name: 'locked_until') DateTime? lockedUntil,

    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,

    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String token,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// True while the backend is still refusing logins for this account.
  bool get isLocked =>
      lockedUntil != null && lockedUntil!.isAfter(DateTime.now());
}

int _idFromJson(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
