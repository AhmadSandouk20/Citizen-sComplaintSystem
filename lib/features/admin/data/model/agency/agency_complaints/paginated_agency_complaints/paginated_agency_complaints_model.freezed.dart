// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_agency_complaints_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedAgencyComplaints {

@JsonKey(name: 'current_page') int get currentPage; List<AgencyComplaintModel> get data;@JsonKey(name: 'last_page') int get lastPage;@JsonKey(name: 'per_page') int get perPage; int get total;
/// Create a copy of PaginatedAgencyComplaints
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedAgencyComplaintsCopyWith<PaginatedAgencyComplaints> get copyWith => _$PaginatedAgencyComplaintsCopyWithImpl<PaginatedAgencyComplaints>(this as PaginatedAgencyComplaints, _$identity);

  /// Serializes this PaginatedAgencyComplaints to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedAgencyComplaints&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,const DeepCollectionEquality().hash(data),lastPage,perPage,total);

@override
String toString() {
  return 'PaginatedAgencyComplaints(currentPage: $currentPage, data: $data, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $PaginatedAgencyComplaintsCopyWith<$Res>  {
  factory $PaginatedAgencyComplaintsCopyWith(PaginatedAgencyComplaints value, $Res Function(PaginatedAgencyComplaints) _then) = _$PaginatedAgencyComplaintsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, List<AgencyComplaintModel> data,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage, int total
});




}
/// @nodoc
class _$PaginatedAgencyComplaintsCopyWithImpl<$Res>
    implements $PaginatedAgencyComplaintsCopyWith<$Res> {
  _$PaginatedAgencyComplaintsCopyWithImpl(this._self, this._then);

  final PaginatedAgencyComplaints _self;
  final $Res Function(PaginatedAgencyComplaints) _then;

/// Create a copy of PaginatedAgencyComplaints
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? data = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(PaginatedAgencyComplaints(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<AgencyComplaintModel>,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedAgencyComplaints].
extension PaginatedAgencyComplaintsPatterns on PaginatedAgencyComplaints {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedAgencyComplaints value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedAgencyComplaints() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedAgencyComplaints value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedAgencyComplaints():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedAgencyComplaints value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedAgencyComplaints() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  List<AgencyComplaintModel> data, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedAgencyComplaints() when $default != null:
return $default(_that.currentPage,_that.data,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  List<AgencyComplaintModel> data, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)  $default,) {final _that = this;
switch (_that) {
case _PaginatedAgencyComplaints():
return $default(_that.currentPage,_that.data,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_page')  int currentPage,  List<AgencyComplaintModel> data, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedAgencyComplaints() when $default != null:
return $default(_that.currentPage,_that.data,_that.lastPage,_that.perPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedAgencyComplaints implements PaginatedAgencyComplaints {
  const _PaginatedAgencyComplaints({@JsonKey(name: 'current_page') required this.currentPage, required  List<AgencyComplaintModel> data, @JsonKey(name: 'last_page') required this.lastPage, @JsonKey(name: 'per_page') required this.perPage, required this.total}): _data = data;
  factory _PaginatedAgencyComplaints.fromJson(Map<String, dynamic> json) => _$PaginatedAgencyComplaintsFromJson(json);

@override@JsonKey(name: 'current_page') final  int currentPage;
 final  List<AgencyComplaintModel> _data;
@override List<AgencyComplaintModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'last_page') final  int lastPage;
@override@JsonKey(name: 'per_page') final  int perPage;
@override final  int total;

/// Create a copy of PaginatedAgencyComplaints
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedAgencyComplaintsCopyWith<_PaginatedAgencyComplaints> get copyWith => __$PaginatedAgencyComplaintsCopyWithImpl<_PaginatedAgencyComplaints>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedAgencyComplaintsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedAgencyComplaints&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,const DeepCollectionEquality().hash(_data),lastPage,perPage,total);

@override
String toString() {
  return 'PaginatedAgencyComplaints(currentPage: $currentPage, data: $data, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaginatedAgencyComplaintsCopyWith<$Res> implements $PaginatedAgencyComplaintsCopyWith<$Res> {
  factory _$PaginatedAgencyComplaintsCopyWith(_PaginatedAgencyComplaints value, $Res Function(_PaginatedAgencyComplaints) _then) = __$PaginatedAgencyComplaintsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, List<AgencyComplaintModel> data,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage, int total
});




}
/// @nodoc
class __$PaginatedAgencyComplaintsCopyWithImpl<$Res>
    implements _$PaginatedAgencyComplaintsCopyWith<$Res> {
  __$PaginatedAgencyComplaintsCopyWithImpl(this._self, this._then);

  final _PaginatedAgencyComplaints _self;
  final $Res Function(_PaginatedAgencyComplaints) _then;

/// Create a copy of PaginatedAgencyComplaints
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? data = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(_PaginatedAgencyComplaints(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<AgencyComplaintModel>,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
