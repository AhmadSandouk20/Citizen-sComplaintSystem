// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_users_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedUsers {

@JsonKey(name: 'current_page') int get currentPage; List<UserModel> get data;@JsonKey(name: 'first_page_url') String? get firstPageUrl; int? get from;@JsonKey(name: 'last_page') int get lastPage;@JsonKey(name: 'last_page_url') String? get lastPageUrl; List<PaginatedUsersLinkModel>? get links;@JsonKey(name: 'next_page_url') String? get nextPageUrl; String? get path;@JsonKey(name: 'per_page') int get perPage;@JsonKey(name: 'prev_page_url') String? get prevPageUrl; int? get to; int get total;
/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedUsersCopyWith<PaginatedUsers> get copyWith => _$PaginatedUsersCopyWithImpl<PaginatedUsers>(this as PaginatedUsers, _$identity);

  /// Serializes this PaginatedUsers to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedUsers&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.firstPageUrl, firstPageUrl) || other.firstPageUrl == firstPageUrl)&&(identical(other.from, from) || other.from == from)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.lastPageUrl, lastPageUrl) || other.lastPageUrl == lastPageUrl)&&const DeepCollectionEquality().equals(other.links, links)&&(identical(other.nextPageUrl, nextPageUrl) || other.nextPageUrl == nextPageUrl)&&(identical(other.path, path) || other.path == path)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.prevPageUrl, prevPageUrl) || other.prevPageUrl == prevPageUrl)&&(identical(other.to, to) || other.to == to)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,const DeepCollectionEquality().hash(data),firstPageUrl,from,lastPage,lastPageUrl,const DeepCollectionEquality().hash(links),nextPageUrl,path,perPage,prevPageUrl,to,total);

@override
String toString() {
  return 'PaginatedUsers(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, links: $links, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
}


}

/// @nodoc
abstract mixin class $PaginatedUsersCopyWith<$Res>  {
  factory $PaginatedUsersCopyWith(PaginatedUsers value, $Res Function(PaginatedUsers) _then) = _$PaginatedUsersCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, List<UserModel> data,@JsonKey(name: 'first_page_url') String? firstPageUrl, int? from,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'last_page_url') String? lastPageUrl, List<PaginatedUsersLinkModel>? links,@JsonKey(name: 'next_page_url') String? nextPageUrl, String? path,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'prev_page_url') String? prevPageUrl, int? to, int total
});




}
/// @nodoc
class _$PaginatedUsersCopyWithImpl<$Res>
    implements $PaginatedUsersCopyWith<$Res> {
  _$PaginatedUsersCopyWithImpl(this._self, this._then);

  final PaginatedUsers _self;
  final $Res Function(PaginatedUsers) _then;

/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? data = null,Object? firstPageUrl = freezed,Object? from = freezed,Object? lastPage = null,Object? lastPageUrl = freezed,Object? links = freezed,Object? nextPageUrl = freezed,Object? path = freezed,Object? perPage = null,Object? prevPageUrl = freezed,Object? to = freezed,Object? total = null,}) {
  return _then(PaginatedUsers(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<UserModel>,firstPageUrl: freezed == firstPageUrl ? _self.firstPageUrl : firstPageUrl // ignore: cast_nullable_to_non_nullable
as String?,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int?,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,lastPageUrl: freezed == lastPageUrl ? _self.lastPageUrl : lastPageUrl // ignore: cast_nullable_to_non_nullable
as String?,links: freezed == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<PaginatedUsersLinkModel>?,nextPageUrl: freezed == nextPageUrl ? _self.nextPageUrl : nextPageUrl // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,prevPageUrl: freezed == prevPageUrl ? _self.prevPageUrl : prevPageUrl // ignore: cast_nullable_to_non_nullable
as String?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedUsers].
extension PaginatedUsersPatterns on PaginatedUsers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedUsers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedUsers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedUsers value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedUsers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedUsers value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedUsers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  List<UserModel> data, @JsonKey(name: 'first_page_url')  String? firstPageUrl,  int? from, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'last_page_url')  String? lastPageUrl,  List<PaginatedUsersLinkModel>? links, @JsonKey(name: 'next_page_url')  String? nextPageUrl,  String? path, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'prev_page_url')  String? prevPageUrl,  int? to,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedUsers() when $default != null:
return $default(_that.currentPage,_that.data,_that.firstPageUrl,_that.from,_that.lastPage,_that.lastPageUrl,_that.links,_that.nextPageUrl,_that.path,_that.perPage,_that.prevPageUrl,_that.to,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  List<UserModel> data, @JsonKey(name: 'first_page_url')  String? firstPageUrl,  int? from, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'last_page_url')  String? lastPageUrl,  List<PaginatedUsersLinkModel>? links, @JsonKey(name: 'next_page_url')  String? nextPageUrl,  String? path, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'prev_page_url')  String? prevPageUrl,  int? to,  int total)  $default,) {final _that = this;
switch (_that) {
case _PaginatedUsers():
return $default(_that.currentPage,_that.data,_that.firstPageUrl,_that.from,_that.lastPage,_that.lastPageUrl,_that.links,_that.nextPageUrl,_that.path,_that.perPage,_that.prevPageUrl,_that.to,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_page')  int currentPage,  List<UserModel> data, @JsonKey(name: 'first_page_url')  String? firstPageUrl,  int? from, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'last_page_url')  String? lastPageUrl,  List<PaginatedUsersLinkModel>? links, @JsonKey(name: 'next_page_url')  String? nextPageUrl,  String? path, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'prev_page_url')  String? prevPageUrl,  int? to,  int total)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedUsers() when $default != null:
return $default(_that.currentPage,_that.data,_that.firstPageUrl,_that.from,_that.lastPage,_that.lastPageUrl,_that.links,_that.nextPageUrl,_that.path,_that.perPage,_that.prevPageUrl,_that.to,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedUsers implements PaginatedUsers {
  const _PaginatedUsers({@JsonKey(name: 'current_page') required this.currentPage, required  List<UserModel> data, @JsonKey(name: 'first_page_url') this.firstPageUrl, this.from, @JsonKey(name: 'last_page') required this.lastPage, @JsonKey(name: 'last_page_url') this.lastPageUrl,  List<PaginatedUsersLinkModel>? links, @JsonKey(name: 'next_page_url') this.nextPageUrl, this.path, @JsonKey(name: 'per_page') required this.perPage, @JsonKey(name: 'prev_page_url') this.prevPageUrl, this.to, required this.total}): _data = data,_links = links;
  factory _PaginatedUsers.fromJson(Map<String, dynamic> json) => _$PaginatedUsersFromJson(json);

@override@JsonKey(name: 'current_page') final  int currentPage;
 final  List<UserModel> _data;
@override List<UserModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'first_page_url') final  String? firstPageUrl;
@override final  int? from;
@override@JsonKey(name: 'last_page') final  int lastPage;
@override@JsonKey(name: 'last_page_url') final  String? lastPageUrl;
 final  List<PaginatedUsersLinkModel>? _links;
@override List<PaginatedUsersLinkModel>? get links {
  final value = _links;
  if (value == null) return null;
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'next_page_url') final  String? nextPageUrl;
@override final  String? path;
@override@JsonKey(name: 'per_page') final  int perPage;
@override@JsonKey(name: 'prev_page_url') final  String? prevPageUrl;
@override final  int? to;
@override final  int total;

/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedUsersCopyWith<_PaginatedUsers> get copyWith => __$PaginatedUsersCopyWithImpl<_PaginatedUsers>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedUsersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedUsers&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.firstPageUrl, firstPageUrl) || other.firstPageUrl == firstPageUrl)&&(identical(other.from, from) || other.from == from)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.lastPageUrl, lastPageUrl) || other.lastPageUrl == lastPageUrl)&&const DeepCollectionEquality().equals(other._links, _links)&&(identical(other.nextPageUrl, nextPageUrl) || other.nextPageUrl == nextPageUrl)&&(identical(other.path, path) || other.path == path)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.prevPageUrl, prevPageUrl) || other.prevPageUrl == prevPageUrl)&&(identical(other.to, to) || other.to == to)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,const DeepCollectionEquality().hash(_data),firstPageUrl,from,lastPage,lastPageUrl,const DeepCollectionEquality().hash(_links),nextPageUrl,path,perPage,prevPageUrl,to,total);

@override
String toString() {
  return 'PaginatedUsers(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, links: $links, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaginatedUsersCopyWith<$Res> implements $PaginatedUsersCopyWith<$Res> {
  factory _$PaginatedUsersCopyWith(_PaginatedUsers value, $Res Function(_PaginatedUsers) _then) = __$PaginatedUsersCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, List<UserModel> data,@JsonKey(name: 'first_page_url') String? firstPageUrl, int? from,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'last_page_url') String? lastPageUrl, List<PaginatedUsersLinkModel>? links,@JsonKey(name: 'next_page_url') String? nextPageUrl, String? path,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'prev_page_url') String? prevPageUrl, int? to, int total
});




}
/// @nodoc
class __$PaginatedUsersCopyWithImpl<$Res>
    implements _$PaginatedUsersCopyWith<$Res> {
  __$PaginatedUsersCopyWithImpl(this._self, this._then);

  final _PaginatedUsers _self;
  final $Res Function(_PaginatedUsers) _then;

/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? data = null,Object? firstPageUrl = freezed,Object? from = freezed,Object? lastPage = null,Object? lastPageUrl = freezed,Object? links = freezed,Object? nextPageUrl = freezed,Object? path = freezed,Object? perPage = null,Object? prevPageUrl = freezed,Object? to = freezed,Object? total = null,}) {
  return _then(_PaginatedUsers(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<UserModel>,firstPageUrl: freezed == firstPageUrl ? _self.firstPageUrl : firstPageUrl // ignore: cast_nullable_to_non_nullable
as String?,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int?,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,lastPageUrl: freezed == lastPageUrl ? _self.lastPageUrl : lastPageUrl // ignore: cast_nullable_to_non_nullable
as String?,links: freezed == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<PaginatedUsersLinkModel>?,nextPageUrl: freezed == nextPageUrl ? _self.nextPageUrl : nextPageUrl // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,prevPageUrl: freezed == prevPageUrl ? _self.prevPageUrl : prevPageUrl // ignore: cast_nullable_to_non_nullable
as String?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
