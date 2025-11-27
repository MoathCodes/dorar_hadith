// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mohdith.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MohdithInfo {

/// Name of the scholar
 String get name;/// Unique identifier
 String get mohdithId;/// Biographical information about the scholar
 String get info;
/// Create a copy of MohdithInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MohdithInfoCopyWith<MohdithInfo> get copyWith => _$MohdithInfoCopyWithImpl<MohdithInfo>(this as MohdithInfo, _$identity);

  /// Serializes this MohdithInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MohdithInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.mohdithId, mohdithId) || other.mohdithId == mohdithId)&&(identical(other.info, info) || other.info == info));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,mohdithId,info);

@override
String toString() {
  return 'MohdithInfo(name: $name, mohdithId: $mohdithId, info: $info)';
}


}

/// @nodoc
abstract mixin class $MohdithInfoCopyWith<$Res>  {
  factory $MohdithInfoCopyWith(MohdithInfo value, $Res Function(MohdithInfo) _then) = _$MohdithInfoCopyWithImpl;
@useResult
$Res call({
 String name, String mohdithId, String info
});




}
/// @nodoc
class _$MohdithInfoCopyWithImpl<$Res>
    implements $MohdithInfoCopyWith<$Res> {
  _$MohdithInfoCopyWithImpl(this._self, this._then);

  final MohdithInfo _self;
  final $Res Function(MohdithInfo) _then;

/// Create a copy of MohdithInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? mohdithId = null,Object? info = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mohdithId: null == mohdithId ? _self.mohdithId : mohdithId // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MohdithInfo].
extension MohdithInfoPatterns on MohdithInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MohdithInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MohdithInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MohdithInfo value)  $default,){
final _that = this;
switch (_that) {
case _MohdithInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MohdithInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MohdithInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String mohdithId,  String info)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MohdithInfo() when $default != null:
return $default(_that.name,_that.mohdithId,_that.info);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String mohdithId,  String info)  $default,) {final _that = this;
switch (_that) {
case _MohdithInfo():
return $default(_that.name,_that.mohdithId,_that.info);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String mohdithId,  String info)?  $default,) {final _that = this;
switch (_that) {
case _MohdithInfo() when $default != null:
return $default(_that.name,_that.mohdithId,_that.info);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MohdithInfo implements MohdithInfo {
  const _MohdithInfo({required this.name, required this.mohdithId, required this.info});
  factory _MohdithInfo.fromJson(Map<String, dynamic> json) => _$MohdithInfoFromJson(json);

/// Name of the scholar
@override final  String name;
/// Unique identifier
@override final  String mohdithId;
/// Biographical information about the scholar
@override final  String info;

/// Create a copy of MohdithInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MohdithInfoCopyWith<_MohdithInfo> get copyWith => __$MohdithInfoCopyWithImpl<_MohdithInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MohdithInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MohdithInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.mohdithId, mohdithId) || other.mohdithId == mohdithId)&&(identical(other.info, info) || other.info == info));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,mohdithId,info);

@override
String toString() {
  return 'MohdithInfo(name: $name, mohdithId: $mohdithId, info: $info)';
}


}

/// @nodoc
abstract mixin class _$MohdithInfoCopyWith<$Res> implements $MohdithInfoCopyWith<$Res> {
  factory _$MohdithInfoCopyWith(_MohdithInfo value, $Res Function(_MohdithInfo) _then) = __$MohdithInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String mohdithId, String info
});




}
/// @nodoc
class __$MohdithInfoCopyWithImpl<$Res>
    implements _$MohdithInfoCopyWith<$Res> {
  __$MohdithInfoCopyWithImpl(this._self, this._then);

  final _MohdithInfo _self;
  final $Res Function(_MohdithInfo) _then;

/// Create a copy of MohdithInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? mohdithId = null,Object? info = null,}) {
  return _then(_MohdithInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mohdithId: null == mohdithId ? _self.mohdithId : mohdithId // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
