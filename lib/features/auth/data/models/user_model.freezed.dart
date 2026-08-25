// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

// Laravel can serialise an id as a string depending on the driver, so the
// parse is deliberate rather than a plain `as num` cast.
@JsonKey(fromJson: _idFromJson) int get id; String get name; String? get email; String? get phone;/// Maps the backend `users.type` enum. Serialized as citizen/staff/admin.
@JsonKey(name: 'type', unknownEnumValue: UserRole.citizen) UserRole get role;@JsonKey(name: 'is_active') bool get isActive;// Login-attempt fields backing the "account locked" screen.
@JsonKey(name: 'last_login_at') DateTime? get lastLoginAt;@JsonKey(name: 'failed_login_attempts') int? get failedLoginAttempts;@JsonKey(name: 'locked_until') DateTime? get lockedUntil;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(includeFromJson: false, includeToJson: false) String get token;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.failedLoginAttempts, failedLoginAttempts) || other.failedLoginAttempts == failedLoginAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,role,isActive,lastLoginAt,failedLoginAttempts,lockedUntil,createdAt,updatedAt,token);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, role: $role, isActive: $isActive, lastLoginAt: $lastLoginAt, failedLoginAttempts: $failedLoginAttempts, lockedUntil: $lockedUntil, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) int id, String name, String? email, String? phone,@JsonKey(name: 'type', unknownEnumValue: UserRole.citizen) UserRole role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_login_at') DateTime? lastLoginAt,@JsonKey(name: 'failed_login_attempts') int? failedLoginAttempts,@JsonKey(name: 'locked_until') DateTime? lockedUntil,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(includeFromJson: false, includeToJson: false) String token
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? role = null,Object? isActive = null,Object? lastLoginAt = freezed,Object? failedLoginAttempts = freezed,Object? lockedUntil = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? token = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failedLoginAttempts: freezed == failedLoginAttempts ? _self.failedLoginAttempts : failedLoginAttempts // ignore: cast_nullable_to_non_nullable
as int?,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  int id,  String name,  String? email,  String? phone, @JsonKey(name: 'type', unknownEnumValue: UserRole.citizen)  UserRole role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')  DateTime? lastLoginAt, @JsonKey(name: 'failed_login_attempts')  int? failedLoginAttempts, @JsonKey(name: 'locked_until')  DateTime? lockedUntil, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.isActive,_that.lastLoginAt,_that.failedLoginAttempts,_that.lockedUntil,_that.createdAt,_that.updatedAt,_that.token);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  int id,  String name,  String? email,  String? phone, @JsonKey(name: 'type', unknownEnumValue: UserRole.citizen)  UserRole role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')  DateTime? lastLoginAt, @JsonKey(name: 'failed_login_attempts')  int? failedLoginAttempts, @JsonKey(name: 'locked_until')  DateTime? lockedUntil, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  String token)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.isActive,_that.lastLoginAt,_that.failedLoginAttempts,_that.lockedUntil,_that.createdAt,_that.updatedAt,_that.token);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  int id,  String name,  String? email,  String? phone, @JsonKey(name: 'type', unknownEnumValue: UserRole.citizen)  UserRole role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')  DateTime? lastLoginAt, @JsonKey(name: 'failed_login_attempts')  int? failedLoginAttempts, @JsonKey(name: 'locked_until')  DateTime? lockedUntil, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  String token)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.isActive,_that.lastLoginAt,_that.failedLoginAttempts,_that.lockedUntil,_that.createdAt,_that.updatedAt,_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({@JsonKey(fromJson: _idFromJson) required this.id, required this.name, this.email, this.phone, @JsonKey(name: 'type', unknownEnumValue: UserRole.citizen) required this.role, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'last_login_at') this.lastLoginAt, @JsonKey(name: 'failed_login_attempts') this.failedLoginAttempts, @JsonKey(name: 'locked_until') this.lockedUntil, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(includeFromJson: false, includeToJson: false) this.token = ''}): super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

// Laravel can serialise an id as a string depending on the driver, so the
// parse is deliberate rather than a plain `as num` cast.
@override@JsonKey(fromJson: _idFromJson) final  int id;
@override final  String name;
@override final  String? email;
@override final  String? phone;
/// Maps the backend `users.type` enum. Serialized as citizen/staff/admin.
@override@JsonKey(name: 'type', unknownEnumValue: UserRole.citizen) final  UserRole role;
@override@JsonKey(name: 'is_active') final  bool isActive;
// Login-attempt fields backing the "account locked" screen.
@override@JsonKey(name: 'last_login_at') final  DateTime? lastLoginAt;
@override@JsonKey(name: 'failed_login_attempts') final  int? failedLoginAttempts;
@override@JsonKey(name: 'locked_until') final  DateTime? lockedUntil;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String token;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.failedLoginAttempts, failedLoginAttempts) || other.failedLoginAttempts == failedLoginAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,role,isActive,lastLoginAt,failedLoginAttempts,lockedUntil,createdAt,updatedAt,token);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, role: $role, isActive: $isActive, lastLoginAt: $lastLoginAt, failedLoginAttempts: $failedLoginAttempts, lockedUntil: $lockedUntil, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) int id, String name, String? email, String? phone,@JsonKey(name: 'type', unknownEnumValue: UserRole.citizen) UserRole role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_login_at') DateTime? lastLoginAt,@JsonKey(name: 'failed_login_attempts') int? failedLoginAttempts,@JsonKey(name: 'locked_until') DateTime? lockedUntil,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(includeFromJson: false, includeToJson: false) String token
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? role = null,Object? isActive = null,Object? lastLoginAt = freezed,Object? failedLoginAttempts = freezed,Object? lockedUntil = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? token = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failedLoginAttempts: freezed == failedLoginAttempts ? _self.failedLoginAttempts : failedLoginAttempts // ignore: cast_nullable_to_non_nullable
as int?,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
