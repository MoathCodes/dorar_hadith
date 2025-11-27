// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CacheEntry {

 String get key;/// The cached data
 String get body; String get header;/// The timestamp when the data was cached
 DateTime get createdAt; DateTime get expiresAt;
/// Create a copy of CacheEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheEntryCopyWith<CacheEntry> get copyWith => _$CacheEntryCopyWithImpl<CacheEntry>(this as CacheEntry, _$identity);

  /// Serializes this CacheEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheEntry&&(identical(other.key, key) || other.key == key)&&(identical(other.body, body) || other.body == body)&&(identical(other.header, header) || other.header == header)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,body,header,createdAt,expiresAt);

@override
String toString() {
  return 'CacheEntry(key: $key, body: $body, header: $header, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $CacheEntryCopyWith<$Res>  {
  factory $CacheEntryCopyWith(CacheEntry value, $Res Function(CacheEntry) _then) = _$CacheEntryCopyWithImpl;
@useResult
$Res call({
 String key, String body, String header, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class _$CacheEntryCopyWithImpl<$Res>
    implements $CacheEntryCopyWith<$Res> {
  _$CacheEntryCopyWithImpl(this._self, this._then);

  final CacheEntry _self;
  final $Res Function(CacheEntry) _then;

/// Create a copy of CacheEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? body = null,Object? header = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,header: null == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CacheEntry].
extension CacheEntryPatterns on CacheEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacheEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacheEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacheEntry value)  $default,){
final _that = this;
switch (_that) {
case _CacheEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacheEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CacheEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String body,  String header,  DateTime createdAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacheEntry() when $default != null:
return $default(_that.key,_that.body,_that.header,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String body,  String header,  DateTime createdAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _CacheEntry():
return $default(_that.key,_that.body,_that.header,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String body,  String header,  DateTime createdAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _CacheEntry() when $default != null:
return $default(_that.key,_that.body,_that.header,_that.createdAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CacheEntry implements CacheEntry {
  const _CacheEntry({required this.key, required this.body, required this.header, required this.createdAt, required this.expiresAt});
  factory _CacheEntry.fromJson(Map<String, dynamic> json) => _$CacheEntryFromJson(json);

@override final  String key;
/// The cached data
@override final  String body;
@override final  String header;
/// The timestamp when the data was cached
@override final  DateTime createdAt;
@override final  DateTime expiresAt;

/// Create a copy of CacheEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheEntryCopyWith<_CacheEntry> get copyWith => __$CacheEntryCopyWithImpl<_CacheEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CacheEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacheEntry&&(identical(other.key, key) || other.key == key)&&(identical(other.body, body) || other.body == body)&&(identical(other.header, header) || other.header == header)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,body,header,createdAt,expiresAt);

@override
String toString() {
  return 'CacheEntry(key: $key, body: $body, header: $header, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$CacheEntryCopyWith<$Res> implements $CacheEntryCopyWith<$Res> {
  factory _$CacheEntryCopyWith(_CacheEntry value, $Res Function(_CacheEntry) _then) = __$CacheEntryCopyWithImpl;
@override @useResult
$Res call({
 String key, String body, String header, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class __$CacheEntryCopyWithImpl<$Res>
    implements _$CacheEntryCopyWith<$Res> {
  __$CacheEntryCopyWithImpl(this._self, this._then);

  final _CacheEntry _self;
  final $Res Function(_CacheEntry) _then;

/// Create a copy of CacheEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? body = null,Object? header = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_CacheEntry(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,header: null == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
