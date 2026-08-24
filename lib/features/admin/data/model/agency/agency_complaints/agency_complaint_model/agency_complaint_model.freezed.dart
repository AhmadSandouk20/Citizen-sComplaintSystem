// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agency_complaint_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgencyComplaintModel {

 int get id;@JsonKey(name: 'reference_code') String get referenceCode;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'agency_id') int get agencyId; String get title; String get description;@JsonKey(name: 'location_text') String get locationText; String get status; String get priority;@JsonKey(name: 'locked_by') int? get lockedBy;@JsonKey(name: 'locked_at') String? get lockedAt;@JsonKey(name: 'closed_at') String? get closedAt;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt; Map<String, dynamic>? get user; Map<String, dynamic>? get agency;
/// Create a copy of AgencyComplaintModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgencyComplaintModelCopyWith<AgencyComplaintModel> get copyWith => _$AgencyComplaintModelCopyWithImpl<AgencyComplaintModel>(this as AgencyComplaintModel, _$identity);

  /// Serializes this AgencyComplaintModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgencyComplaintModel&&(identical(other.id, id) || other.id == id)&&(identical(other.referenceCode, referenceCode) || other.referenceCode == referenceCode)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.agencyId, agencyId) || other.agencyId == agencyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.lockedBy, lockedBy) || other.lockedBy == lockedBy)&&(identical(other.lockedAt, lockedAt) || other.lockedAt == lockedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.user, user)&&const DeepCollectionEquality().equals(other.agency, agency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referenceCode,userId,agencyId,title,description,locationText,status,priority,lockedBy,lockedAt,closedAt,createdAt,updatedAt,const DeepCollectionEquality().hash(user),const DeepCollectionEquality().hash(agency));

@override
String toString() {
  return 'AgencyComplaintModel(id: $id, referenceCode: $referenceCode, userId: $userId, agencyId: $agencyId, title: $title, description: $description, locationText: $locationText, status: $status, priority: $priority, lockedBy: $lockedBy, lockedAt: $lockedAt, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, agency: $agency)';
}


}

/// @nodoc
abstract mixin class $AgencyComplaintModelCopyWith<$Res>  {
  factory $AgencyComplaintModelCopyWith(AgencyComplaintModel value, $Res Function(AgencyComplaintModel) _then) = _$AgencyComplaintModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'reference_code') String referenceCode,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'agency_id') int agencyId, String title, String description,@JsonKey(name: 'location_text') String locationText, String status, String priority,@JsonKey(name: 'locked_by') int? lockedBy,@JsonKey(name: 'locked_at') String? lockedAt,@JsonKey(name: 'closed_at') String? closedAt,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt, Map<String, dynamic>? user, Map<String, dynamic>? agency
});




}
/// @nodoc
class _$AgencyComplaintModelCopyWithImpl<$Res>
    implements $AgencyComplaintModelCopyWith<$Res> {
  _$AgencyComplaintModelCopyWithImpl(this._self, this._then);

  final AgencyComplaintModel _self;
  final $Res Function(AgencyComplaintModel) _then;

/// Create a copy of AgencyComplaintModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referenceCode = null,Object? userId = null,Object? agencyId = null,Object? title = null,Object? description = null,Object? locationText = null,Object? status = null,Object? priority = null,Object? lockedBy = freezed,Object? lockedAt = freezed,Object? closedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? user = freezed,Object? agency = freezed,}) {
  return _then(AgencyComplaintModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,referenceCode: null == referenceCode ? _self.referenceCode : referenceCode // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,agencyId: null == agencyId ? _self.agencyId : agencyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,lockedBy: freezed == lockedBy ? _self.lockedBy : lockedBy // ignore: cast_nullable_to_non_nullable
as int?,lockedAt: freezed == lockedAt ? _self.lockedAt : lockedAt // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,agency: freezed == agency ? _self.agency : agency // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgencyComplaintModel].
extension AgencyComplaintModelPatterns on AgencyComplaintModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgencyComplaintModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgencyComplaintModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgencyComplaintModel value)  $default,){
final _that = this;
switch (_that) {
case _AgencyComplaintModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgencyComplaintModel value)?  $default,){
final _that = this;
switch (_that) {
case _AgencyComplaintModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'reference_code')  String referenceCode, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'agency_id')  int agencyId,  String title,  String description, @JsonKey(name: 'location_text')  String locationText,  String status,  String priority, @JsonKey(name: 'locked_by')  int? lockedBy, @JsonKey(name: 'locked_at')  String? lockedAt, @JsonKey(name: 'closed_at')  String? closedAt, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt,  Map<String, dynamic>? user,  Map<String, dynamic>? agency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgencyComplaintModel() when $default != null:
return $default(_that.id,_that.referenceCode,_that.userId,_that.agencyId,_that.title,_that.description,_that.locationText,_that.status,_that.priority,_that.lockedBy,_that.lockedAt,_that.closedAt,_that.createdAt,_that.updatedAt,_that.user,_that.agency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'reference_code')  String referenceCode, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'agency_id')  int agencyId,  String title,  String description, @JsonKey(name: 'location_text')  String locationText,  String status,  String priority, @JsonKey(name: 'locked_by')  int? lockedBy, @JsonKey(name: 'locked_at')  String? lockedAt, @JsonKey(name: 'closed_at')  String? closedAt, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt,  Map<String, dynamic>? user,  Map<String, dynamic>? agency)  $default,) {final _that = this;
switch (_that) {
case _AgencyComplaintModel():
return $default(_that.id,_that.referenceCode,_that.userId,_that.agencyId,_that.title,_that.description,_that.locationText,_that.status,_that.priority,_that.lockedBy,_that.lockedAt,_that.closedAt,_that.createdAt,_that.updatedAt,_that.user,_that.agency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'reference_code')  String referenceCode, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'agency_id')  int agencyId,  String title,  String description, @JsonKey(name: 'location_text')  String locationText,  String status,  String priority, @JsonKey(name: 'locked_by')  int? lockedBy, @JsonKey(name: 'locked_at')  String? lockedAt, @JsonKey(name: 'closed_at')  String? closedAt, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt,  Map<String, dynamic>? user,  Map<String, dynamic>? agency)?  $default,) {final _that = this;
switch (_that) {
case _AgencyComplaintModel() when $default != null:
return $default(_that.id,_that.referenceCode,_that.userId,_that.agencyId,_that.title,_that.description,_that.locationText,_that.status,_that.priority,_that.lockedBy,_that.lockedAt,_that.closedAt,_that.createdAt,_that.updatedAt,_that.user,_that.agency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgencyComplaintModel implements AgencyComplaintModel {
  const _AgencyComplaintModel({required this.id, @JsonKey(name: 'reference_code') required this.referenceCode, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'agency_id') required this.agencyId, required this.title, required this.description, @JsonKey(name: 'location_text') required this.locationText, required this.status, required this.priority, @JsonKey(name: 'locked_by') this.lockedBy, @JsonKey(name: 'locked_at') this.lockedAt, @JsonKey(name: 'closed_at') this.closedAt, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt,  Map<String, dynamic>? user,  Map<String, dynamic>? agency}): _user = user,_agency = agency;
  factory _AgencyComplaintModel.fromJson(Map<String, dynamic> json) => _$AgencyComplaintModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'reference_code') final  String referenceCode;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'agency_id') final  int agencyId;
@override final  String title;
@override final  String description;
@override@JsonKey(name: 'location_text') final  String locationText;
@override final  String status;
@override final  String priority;
@override@JsonKey(name: 'locked_by') final  int? lockedBy;
@override@JsonKey(name: 'locked_at') final  String? lockedAt;
@override@JsonKey(name: 'closed_at') final  String? closedAt;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
 final  Map<String, dynamic>? _user;
@override Map<String, dynamic>? get user {
  final value = _user;
  if (value == null) return null;
  if (_user is EqualUnmodifiableMapView) return _user;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _agency;
@override Map<String, dynamic>? get agency {
  final value = _agency;
  if (value == null) return null;
  if (_agency is EqualUnmodifiableMapView) return _agency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AgencyComplaintModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgencyComplaintModelCopyWith<_AgencyComplaintModel> get copyWith => __$AgencyComplaintModelCopyWithImpl<_AgencyComplaintModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgencyComplaintModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgencyComplaintModel&&(identical(other.id, id) || other.id == id)&&(identical(other.referenceCode, referenceCode) || other.referenceCode == referenceCode)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.agencyId, agencyId) || other.agencyId == agencyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.lockedBy, lockedBy) || other.lockedBy == lockedBy)&&(identical(other.lockedAt, lockedAt) || other.lockedAt == lockedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._user, _user)&&const DeepCollectionEquality().equals(other._agency, _agency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referenceCode,userId,agencyId,title,description,locationText,status,priority,lockedBy,lockedAt,closedAt,createdAt,updatedAt,const DeepCollectionEquality().hash(_user),const DeepCollectionEquality().hash(_agency));

@override
String toString() {
  return 'AgencyComplaintModel(id: $id, referenceCode: $referenceCode, userId: $userId, agencyId: $agencyId, title: $title, description: $description, locationText: $locationText, status: $status, priority: $priority, lockedBy: $lockedBy, lockedAt: $lockedAt, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, agency: $agency)';
}


}

/// @nodoc
abstract mixin class _$AgencyComplaintModelCopyWith<$Res> implements $AgencyComplaintModelCopyWith<$Res> {
  factory _$AgencyComplaintModelCopyWith(_AgencyComplaintModel value, $Res Function(_AgencyComplaintModel) _then) = __$AgencyComplaintModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'reference_code') String referenceCode,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'agency_id') int agencyId, String title, String description,@JsonKey(name: 'location_text') String locationText, String status, String priority,@JsonKey(name: 'locked_by') int? lockedBy,@JsonKey(name: 'locked_at') String? lockedAt,@JsonKey(name: 'closed_at') String? closedAt,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt, Map<String, dynamic>? user, Map<String, dynamic>? agency
});




}
/// @nodoc
class __$AgencyComplaintModelCopyWithImpl<$Res>
    implements _$AgencyComplaintModelCopyWith<$Res> {
  __$AgencyComplaintModelCopyWithImpl(this._self, this._then);

  final _AgencyComplaintModel _self;
  final $Res Function(_AgencyComplaintModel) _then;

/// Create a copy of AgencyComplaintModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referenceCode = null,Object? userId = null,Object? agencyId = null,Object? title = null,Object? description = null,Object? locationText = null,Object? status = null,Object? priority = null,Object? lockedBy = freezed,Object? lockedAt = freezed,Object? closedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? user = freezed,Object? agency = freezed,}) {
  return _then(_AgencyComplaintModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,referenceCode: null == referenceCode ? _self.referenceCode : referenceCode // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,agencyId: null == agencyId ? _self.agencyId : agencyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,lockedBy: freezed == lockedBy ? _self.lockedBy : lockedBy // ignore: cast_nullable_to_non_nullable
as int?,lockedAt: freezed == lockedAt ? _self.lockedAt : lockedAt // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self._user : user // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,agency: freezed == agency ? _self._agency : agency // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
