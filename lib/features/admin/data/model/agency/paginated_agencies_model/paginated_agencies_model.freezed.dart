// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_agencies_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedAgencies {

@JsonKey(name: "data") List<AgencyModel> get agencies;@JsonKey(name: 'current_page') int get currentPage;@JsonKey(name: 'last_page') int get lastPage;@JsonKey(name: 'per_page') int get perPage; int get total;
/// Create a copy of PaginatedAgencies
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedAgenciesCopyWith<PaginatedAgencies> get copyWith => _$PaginatedAgenciesCopyWithImpl<PaginatedAgencies>(this as PaginatedAgencies, _$identity);

  /// Serializes this PaginatedAgencies to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedAgencies&&const DeepCollectionEquality().equals(other.agencies, agencies)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(agencies),currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'PaginatedAgencies(agencies: $agencies, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $PaginatedAgenciesCopyWith<$Res>  {
  factory $PaginatedAgenciesCopyWith(PaginatedAgencies value, $Res Function(PaginatedAgencies) _then) = _$PaginatedAgenciesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "data") List<AgencyModel> agencies,@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage, int total
});




}
/// @nodoc
class _$PaginatedAgenciesCopyWithImpl<$Res>
    implements $PaginatedAgenciesCopyWith<$Res> {
  _$PaginatedAgenciesCopyWithImpl(this._self, this._then);

  final PaginatedAgencies _self;
  final $Res Function(PaginatedAgencies) _then;

/// Create a copy of PaginatedAgencies
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agencies = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(PaginatedAgencies(
agencies: null == agencies ? _self.agencies : agencies // ignore: cast_nullable_to_non_nullable
as List<AgencyModel>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedAgencies].
extension PaginatedAgenciesPatterns on PaginatedAgencies {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedAgencies value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedAgencies() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedAgencies value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedAgencies():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedAgencies value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedAgencies() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "data")  List<AgencyModel> agencies, @JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedAgencies() when $default != null:
return $default(_that.agencies,_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "data")  List<AgencyModel> agencies, @JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)  $default,) {final _that = this;
switch (_that) {
case _PaginatedAgencies():
return $default(_that.agencies,_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "data")  List<AgencyModel> agencies, @JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedAgencies() when $default != null:
return $default(_that.agencies,_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedAgencies implements PaginatedAgencies {
  const _PaginatedAgencies({@JsonKey(name: "data") required  List<AgencyModel> agencies, @JsonKey(name: 'current_page') required this.currentPage, @JsonKey(name: 'last_page') required this.lastPage, @JsonKey(name: 'per_page') required this.perPage, required this.total}): _agencies = agencies;
  factory _PaginatedAgencies.fromJson(Map<String, dynamic> json) => _$PaginatedAgenciesFromJson(json);

 final  List<AgencyModel> _agencies;
@override@JsonKey(name: "data") List<AgencyModel> get agencies {
  if (_agencies is EqualUnmodifiableListView) return _agencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agencies);
}

@override@JsonKey(name: 'current_page') final  int currentPage;
@override@JsonKey(name: 'last_page') final  int lastPage;
@override@JsonKey(name: 'per_page') final  int perPage;
@override final  int total;

/// Create a copy of PaginatedAgencies
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedAgenciesCopyWith<_PaginatedAgencies> get copyWith => __$PaginatedAgenciesCopyWithImpl<_PaginatedAgencies>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedAgenciesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedAgencies&&const DeepCollectionEquality().equals(other._agencies, _agencies)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_agencies),currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'PaginatedAgencies(agencies: $agencies, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaginatedAgenciesCopyWith<$Res> implements $PaginatedAgenciesCopyWith<$Res> {
  factory _$PaginatedAgenciesCopyWith(_PaginatedAgencies value, $Res Function(_PaginatedAgencies) _then) = __$PaginatedAgenciesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "data") List<AgencyModel> agencies,@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage, int total
});




}
/// @nodoc
class __$PaginatedAgenciesCopyWithImpl<$Res>
    implements _$PaginatedAgenciesCopyWith<$Res> {
  __$PaginatedAgenciesCopyWithImpl(this._self, this._then);

  final _PaginatedAgencies _self;
  final $Res Function(_PaginatedAgencies) _then;

/// Create a copy of PaginatedAgencies
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agencies = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(_PaginatedAgencies(
agencies: null == agencies ? _self._agencies : agencies // ignore: cast_nullable_to_non_nullable
as List<AgencyModel>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
