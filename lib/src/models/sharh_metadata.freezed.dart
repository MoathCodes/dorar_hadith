// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sharh_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharhMetadata {

/// Unique identifier for the sharh
 String get id;/// Whether this response contains the actual sharh text
 bool get isContainSharh;/// The actual sharh text (if available)
 String? get sharh;
/// Create a copy of SharhMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharhMetadataCopyWith<SharhMetadata> get copyWith => _$SharhMetadataCopyWithImpl<SharhMetadata>(this as SharhMetadata, _$identity);

  /// Serializes this SharhMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharhMetadata&&(identical(other.id, id) || other.id == id)&&(identical(other.isContainSharh, isContainSharh) || other.isContainSharh == isContainSharh)&&(identical(other.sharh, sharh) || other.sharh == sharh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isContainSharh,sharh);

@override
String toString() {
  return 'SharhMetadata(id: $id, isContainSharh: $isContainSharh, sharh: $sharh)';
}


}

/// @nodoc
abstract mixin class $SharhMetadataCopyWith<$Res>  {
  factory $SharhMetadataCopyWith(SharhMetadata value, $Res Function(SharhMetadata) _then) = _$SharhMetadataCopyWithImpl;
@useResult
$Res call({
 String id, bool isContainSharh, String? sharh
});




}
/// @nodoc
class _$SharhMetadataCopyWithImpl<$Res>
    implements $SharhMetadataCopyWith<$Res> {
  _$SharhMetadataCopyWithImpl(this._self, this._then);

  final SharhMetadata _self;
  final $Res Function(SharhMetadata) _then;

/// Create a copy of SharhMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isContainSharh = null,Object? sharh = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isContainSharh: null == isContainSharh ? _self.isContainSharh : isContainSharh // ignore: cast_nullable_to_non_nullable
as bool,sharh: freezed == sharh ? _self.sharh : sharh // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharhMetadata].
extension SharhMetadataPatterns on SharhMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharhMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharhMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharhMetadata value)  $default,){
final _that = this;
switch (_that) {
case _SharhMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharhMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _SharhMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool isContainSharh,  String? sharh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharhMetadata() when $default != null:
return $default(_that.id,_that.isContainSharh,_that.sharh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool isContainSharh,  String? sharh)  $default,) {final _that = this;
switch (_that) {
case _SharhMetadata():
return $default(_that.id,_that.isContainSharh,_that.sharh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool isContainSharh,  String? sharh)?  $default,) {final _that = this;
switch (_that) {
case _SharhMetadata() when $default != null:
return $default(_that.id,_that.isContainSharh,_that.sharh);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharhMetadata implements SharhMetadata {
  const _SharhMetadata({required this.id, this.isContainSharh = false, this.sharh});
  factory _SharhMetadata.fromJson(Map<String, dynamic> json) => _$SharhMetadataFromJson(json);

/// Unique identifier for the sharh
@override final  String id;
/// Whether this response contains the actual sharh text
@override@JsonKey() final  bool isContainSharh;
/// The actual sharh text (if available)
@override final  String? sharh;

/// Create a copy of SharhMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharhMetadataCopyWith<_SharhMetadata> get copyWith => __$SharhMetadataCopyWithImpl<_SharhMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharhMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharhMetadata&&(identical(other.id, id) || other.id == id)&&(identical(other.isContainSharh, isContainSharh) || other.isContainSharh == isContainSharh)&&(identical(other.sharh, sharh) || other.sharh == sharh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isContainSharh,sharh);

@override
String toString() {
  return 'SharhMetadata(id: $id, isContainSharh: $isContainSharh, sharh: $sharh)';
}


}

/// @nodoc
abstract mixin class _$SharhMetadataCopyWith<$Res> implements $SharhMetadataCopyWith<$Res> {
  factory _$SharhMetadataCopyWith(_SharhMetadata value, $Res Function(_SharhMetadata) _then) = __$SharhMetadataCopyWithImpl;
@override @useResult
$Res call({
 String id, bool isContainSharh, String? sharh
});




}
/// @nodoc
class __$SharhMetadataCopyWithImpl<$Res>
    implements _$SharhMetadataCopyWith<$Res> {
  __$SharhMetadataCopyWithImpl(this._self, this._then);

  final _SharhMetadata _self;
  final $Res Function(_SharhMetadata) _then;

/// Create a copy of SharhMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isContainSharh = null,Object? sharh = freezed,}) {
  return _then(_SharhMetadata(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isContainSharh: null == isContainSharh ? _self.isContainSharh : isContainSharh // ignore: cast_nullable_to_non_nullable
as bool,sharh: freezed == sharh ? _self.sharh : sharh // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
