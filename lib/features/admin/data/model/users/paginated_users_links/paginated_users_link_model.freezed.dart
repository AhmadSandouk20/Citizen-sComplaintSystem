// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_users_link_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedUsersLinkModel {

 String? get url; String? get label; bool? get active;
/// Create a copy of PaginatedUsersLinkModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedUsersLinkModelCopyWith<PaginatedUsersLinkModel> get copyWith => _$PaginatedUsersLinkModelCopyWithImpl<PaginatedUsersLinkModel>(this as PaginatedUsersLinkModel, _$identity);

  /// Serializes this PaginatedUsersLinkModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedUsersLinkModel&&(identical(other.url, url) || other.url == url)&&(identical(other.label, label) || other.label == label)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,label,active);

@override
String toString() {
  return 'PaginatedUsersLinkModel(url: $url, label: $label, active: $active)';
}


}

/// @nodoc
abstract mixin class $PaginatedUsersLinkModelCopyWith<$Res>  {
  factory $PaginatedUsersLinkModelCopyWith(PaginatedUsersLinkModel value, $Res Function(PaginatedUsersLinkModel) _then) = _$PaginatedUsersLinkModelCopyWithImpl;
@useResult
$Res call({
 String? url, String? label, bool? active
});




}
/// @nodoc
class _$PaginatedUsersLinkModelCopyWithImpl<$Res>
    implements $PaginatedUsersLinkModelCopyWith<$Res> {
  _$PaginatedUsersLinkModelCopyWithImpl(this._self, this._then);

  final PaginatedUsersLinkModel _self;
  final $Res Function(PaginatedUsersLinkModel) _then;

/// Create a copy of PaginatedUsersLinkModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? label = freezed,Object? active = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedUsersLinkModel].
extension PaginatedUsersLinkModelPatterns on PaginatedUsersLinkModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedUsersLinkModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedUsersLinkModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedUsersLinkModel value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedUsersLinkModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedUsersLinkModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedUsersLinkModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? url,  String? label,  bool? active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedUsersLinkModel() when $default != null:
return $default(_that.url,_that.label,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? url,  String? label,  bool? active)  $default,) {final _that = this;
switch (_that) {
case _PaginatedUsersLinkModel():
return $default(_that.url,_that.label,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? url,  String? label,  bool? active)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedUsersLinkModel() when $default != null:
return $default(_that.url,_that.label,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedUsersLinkModel implements PaginatedUsersLinkModel {
  const _PaginatedUsersLinkModel({this.url, this.label, this.active});
  factory _PaginatedUsersLinkModel.fromJson(Map<String, dynamic> json) => _$PaginatedUsersLinkModelFromJson(json);

@override final  String? url;
@override final  String? label;
@override final  bool? active;

/// Create a copy of PaginatedUsersLinkModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedUsersLinkModelCopyWith<_PaginatedUsersLinkModel> get copyWith => __$PaginatedUsersLinkModelCopyWithImpl<_PaginatedUsersLinkModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedUsersLinkModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedUsersLinkModel&&(identical(other.url, url) || other.url == url)&&(identical(other.label, label) || other.label == label)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,label,active);

@override
String toString() {
  return 'PaginatedUsersLinkModel(url: $url, label: $label, active: $active)';
}


}

/// @nodoc
abstract mixin class _$PaginatedUsersLinkModelCopyWith<$Res> implements $PaginatedUsersLinkModelCopyWith<$Res> {
  factory _$PaginatedUsersLinkModelCopyWith(_PaginatedUsersLinkModel value, $Res Function(_PaginatedUsersLinkModel) _then) = __$PaginatedUsersLinkModelCopyWithImpl;
@override @useResult
$Res call({
 String? url, String? label, bool? active
});




}
/// @nodoc
class __$PaginatedUsersLinkModelCopyWithImpl<$Res>
    implements _$PaginatedUsersLinkModelCopyWith<$Res> {
  __$PaginatedUsersLinkModelCopyWithImpl(this._self, this._then);

  final _PaginatedUsersLinkModel _self;
  final $Res Function(_PaginatedUsersLinkModel) _then;

/// Create a copy of PaginatedUsersLinkModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? label = freezed,Object? active = freezed,}) {
  return _then(_PaginatedUsersLinkModel(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
