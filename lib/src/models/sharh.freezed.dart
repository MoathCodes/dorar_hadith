// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sharh.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sharh {

 ExplainedHadith get hadith;/// The sharh metadata (including the explanation text)
 SharhMetadata? get sharhMetadata;
/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharhCopyWith<Sharh> get copyWith => _$SharhCopyWithImpl<Sharh>(this as Sharh, _$identity);

  /// Serializes this Sharh to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sharh&&(identical(other.hadith, hadith) || other.hadith == hadith)&&(identical(other.sharhMetadata, sharhMetadata) || other.sharhMetadata == sharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hadith,sharhMetadata);

@override
String toString() {
  return 'Sharh(hadith: $hadith, sharhMetadata: $sharhMetadata)';
}


}

/// @nodoc
abstract mixin class $SharhCopyWith<$Res>  {
  factory $SharhCopyWith(Sharh value, $Res Function(Sharh) _then) = _$SharhCopyWithImpl;
@useResult
$Res call({
 ExplainedHadith hadith, SharhMetadata? sharhMetadata
});


$ExplainedHadithCopyWith<$Res> get hadith;$SharhMetadataCopyWith<$Res>? get sharhMetadata;

}
/// @nodoc
class _$SharhCopyWithImpl<$Res>
    implements $SharhCopyWith<$Res> {
  _$SharhCopyWithImpl(this._self, this._then);

  final Sharh _self;
  final $Res Function(Sharh) _then;

/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hadith = null,Object? sharhMetadata = freezed,}) {
  return _then(_self.copyWith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as ExplainedHadith,sharhMetadata: freezed == sharhMetadata ? _self.sharhMetadata : sharhMetadata // ignore: cast_nullable_to_non_nullable
as SharhMetadata?,
  ));
}
/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExplainedHadithCopyWith<$Res> get hadith {
  
  return $ExplainedHadithCopyWith<$Res>(_self.hadith, (value) {
    return _then(_self.copyWith(hadith: value));
  });
}/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SharhMetadataCopyWith<$Res>? get sharhMetadata {
    if (_self.sharhMetadata == null) {
    return null;
  }

  return $SharhMetadataCopyWith<$Res>(_self.sharhMetadata!, (value) {
    return _then(_self.copyWith(sharhMetadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Sharh].
extension SharhPatterns on Sharh {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sharh value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sharh() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sharh value)  $default,){
final _that = this;
switch (_that) {
case _Sharh():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sharh value)?  $default,){
final _that = this;
switch (_that) {
case _Sharh() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExplainedHadith hadith,  SharhMetadata? sharhMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sharh() when $default != null:
return $default(_that.hadith,_that.sharhMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExplainedHadith hadith,  SharhMetadata? sharhMetadata)  $default,) {final _that = this;
switch (_that) {
case _Sharh():
return $default(_that.hadith,_that.sharhMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExplainedHadith hadith,  SharhMetadata? sharhMetadata)?  $default,) {final _that = this;
switch (_that) {
case _Sharh() when $default != null:
return $default(_that.hadith,_that.sharhMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sharh extends Sharh {
  const _Sharh({required this.hadith, this.sharhMetadata}): super._();
  factory _Sharh.fromJson(Map<String, dynamic> json) => _$SharhFromJson(json);

@override final  ExplainedHadith hadith;
/// The sharh metadata (including the explanation text)
@override final  SharhMetadata? sharhMetadata;

/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharhCopyWith<_Sharh> get copyWith => __$SharhCopyWithImpl<_Sharh>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharhToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sharh&&(identical(other.hadith, hadith) || other.hadith == hadith)&&(identical(other.sharhMetadata, sharhMetadata) || other.sharhMetadata == sharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hadith,sharhMetadata);

@override
String toString() {
  return 'Sharh(hadith: $hadith, sharhMetadata: $sharhMetadata)';
}


}

/// @nodoc
abstract mixin class _$SharhCopyWith<$Res> implements $SharhCopyWith<$Res> {
  factory _$SharhCopyWith(_Sharh value, $Res Function(_Sharh) _then) = __$SharhCopyWithImpl;
@override @useResult
$Res call({
 ExplainedHadith hadith, SharhMetadata? sharhMetadata
});


@override $ExplainedHadithCopyWith<$Res> get hadith;@override $SharhMetadataCopyWith<$Res>? get sharhMetadata;

}
/// @nodoc
class __$SharhCopyWithImpl<$Res>
    implements _$SharhCopyWith<$Res> {
  __$SharhCopyWithImpl(this._self, this._then);

  final _Sharh _self;
  final $Res Function(_Sharh) _then;

/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hadith = null,Object? sharhMetadata = freezed,}) {
  return _then(_Sharh(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as ExplainedHadith,sharhMetadata: freezed == sharhMetadata ? _self.sharhMetadata : sharhMetadata // ignore: cast_nullable_to_non_nullable
as SharhMetadata?,
  ));
}

/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExplainedHadithCopyWith<$Res> get hadith {
  
  return $ExplainedHadithCopyWith<$Res>(_self.hadith, (value) {
    return _then(_self.copyWith(hadith: value));
  });
}/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SharhMetadataCopyWith<$Res>? get sharhMetadata {
    if (_self.sharhMetadata == null) {
    return null;
  }

  return $SharhMetadataCopyWith<$Res>(_self.sharhMetadata!, (value) {
    return _then(_self.copyWith(sharhMetadata: value));
  });
}
}

// dart format on
