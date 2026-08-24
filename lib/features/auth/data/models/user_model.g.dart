// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  password: json['password'] as String?,
  type: $enumDecode(_$UserTypeEnumMap, json['type']),
  isActive: json['is_active'] as bool? ?? false,
  lastLoginAt: json['last_login_at'] == null
      ? null
      : DateTime.parse(json['last_login_at'] as String),
  failedLoginAttempts: (json['failed_login_attempts'] as num?)?.toInt(),
  lockedUntil: json['locked_until'] == null
      ? null
      : DateTime.parse(json['locked_until'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'type': _$UserTypeEnumMap[instance.type]!,
      'is_active': instance.isActive,
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'failed_login_attempts': instance.failedLoginAttempts,
      'locked_until': instance.lockedUntil?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$UserTypeEnumMap = {
  UserType.admin: 'admin',
  UserType.staff: 'staff',
  UserType.citizen: 'citizen',
};
