// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sharh.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sharh {

 DetailedHadith get hadith; SourcedDocument? get document; DetailedHadith? get embeddedHadith; String? get requestedHadithId; ExplanationReference? get explanationReference; ResultProvenance? get provenance;/// The sharh metadata (including the explanation text)
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
  final _this = this as Sharh;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sharh&&(identical(other.hadith, _this.hadith) || other.hadith == _this.hadith)&&(identical(other.document, _this.document) || other.document == _this.document)&&(identical(other.embeddedHadith, _this.embeddedHadith) || other.embeddedHadith == _this.embeddedHadith)&&(identical(other.requestedHadithId, _this.requestedHadithId) || other.requestedHadithId == _this.requestedHadithId)&&(identical(other.explanationReference, _this.explanationReference) || other.explanationReference == _this.explanationReference)&&(identical(other.provenance, _this.provenance) || other.provenance == _this.provenance)&&(identical(other.sharhMetadata, _this.sharhMetadata) || other.sharhMetadata == _this.sharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Sharh;
  return Object.hash(runtimeType,_this.hadith,_this.document,_this.embeddedHadith,_this.requestedHadithId,_this.explanationReference,_this.provenance,_this.sharhMetadata);
}

@override
String toString() {
  final _this = this as Sharh;
  return 'Sharh(hadith: ${_this.hadith}, document: ${_this.document}, embeddedHadith: ${_this.embeddedHadith}, requestedHadithId: ${_this.requestedHadithId}, explanationReference: ${_this.explanationReference}, provenance: ${_this.provenance}, sharhMetadata: ${_this.sharhMetadata})';
}


}

/// @nodoc
abstract mixin class $SharhCopyWith<$Res>  {
  factory $SharhCopyWith(Sharh value, $Res Function(Sharh) _then) = _$SharhCopyWithImpl;
@useResult
$Res call({
 DetailedHadith hadith, SourcedDocument? document, DetailedHadith? embeddedHadith, String? requestedHadithId, ExplanationReference? explanationReference, ResultProvenance? provenance, SharhMetadata? sharhMetadata
});


$DetailedHadithCopyWith<$Res> get hadith;$DetailedHadithCopyWith<$Res>? get embeddedHadith;$SharhMetadataCopyWith<$Res>? get sharhMetadata;

}
/// @nodoc
class _$SharhCopyWithImpl<$Res>
    implements $SharhCopyWith<$Res> {
  _$SharhCopyWithImpl(this._self, this._then);

  final Sharh _self;
  final $Res Function(Sharh) _then;

/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hadith = null,Object? document = freezed,Object? embeddedHadith = freezed,Object? requestedHadithId = freezed,Object? explanationReference = freezed,Object? provenance = freezed,Object? sharhMetadata = freezed,}) {
  return _then(Sharh(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as DetailedHadith,document: freezed == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as SourcedDocument?,embeddedHadith: freezed == embeddedHadith ? _self.embeddedHadith : embeddedHadith // ignore: cast_nullable_to_non_nullable
as DetailedHadith?,requestedHadithId: freezed == requestedHadithId ? _self.requestedHadithId : requestedHadithId // ignore: cast_nullable_to_non_nullable
as String?,explanationReference: freezed == explanationReference ? _self.explanationReference : explanationReference // ignore: cast_nullable_to_non_nullable
as ExplanationReference?,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as ResultProvenance?,sharhMetadata: freezed == sharhMetadata ? _self.sharhMetadata : sharhMetadata // ignore: cast_nullable_to_non_nullable
as SharhMetadata?,
  ));
}
/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailedHadithCopyWith<$Res> get hadith {
  
  return $DetailedHadithCopyWith<$Res>(_self.hadith, (value) {
    return _then(_self.copyWith(hadith: value));
  });
}/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailedHadithCopyWith<$Res>? get embeddedHadith {
    if (_self.embeddedHadith == null) {
    return null;
  }

  return $DetailedHadithCopyWith<$Res>(_self.embeddedHadith!, (value) {
    return _then(_self.copyWith(embeddedHadith: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DetailedHadith hadith,  SourcedDocument? document,  DetailedHadith? embeddedHadith,  String? requestedHadithId,  ExplanationReference? explanationReference,  ResultProvenance? provenance,  SharhMetadata? sharhMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sharh() when $default != null:
return $default(_that.hadith,_that.document,_that.embeddedHadith,_that.requestedHadithId,_that.explanationReference,_that.provenance,_that.sharhMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DetailedHadith hadith,  SourcedDocument? document,  DetailedHadith? embeddedHadith,  String? requestedHadithId,  ExplanationReference? explanationReference,  ResultProvenance? provenance,  SharhMetadata? sharhMetadata)  $default,) {final _that = this;
switch (_that) {
case _Sharh():
return $default(_that.hadith,_that.document,_that.embeddedHadith,_that.requestedHadithId,_that.explanationReference,_that.provenance,_that.sharhMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DetailedHadith hadith,  SourcedDocument? document,  DetailedHadith? embeddedHadith,  String? requestedHadithId,  ExplanationReference? explanationReference,  ResultProvenance? provenance,  SharhMetadata? sharhMetadata)?  $default,) {final _that = this;
switch (_that) {
case _Sharh() when $default != null:
return $default(_that.hadith,_that.document,_that.embeddedHadith,_that.requestedHadithId,_that.explanationReference,_that.provenance,_that.sharhMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sharh extends Sharh {
  const _Sharh({required this.hadith, this.document, this.embeddedHadith, this.requestedHadithId, this.explanationReference, this.provenance, this.sharhMetadata}): super._();
  factory _Sharh.fromJson(Map<String, dynamic> json) => _$SharhFromJson(json);

@override final  DetailedHadith hadith;
@override final  SourcedDocument? document;
@override final  DetailedHadith? embeddedHadith;
@override final  String? requestedHadithId;
@override final  ExplanationReference? explanationReference;
@override final  ResultProvenance? provenance;
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sharh&&(identical(other.hadith, hadith) || other.hadith == hadith)&&(identical(other.document, document) || other.document == document)&&(identical(other.embeddedHadith, embeddedHadith) || other.embeddedHadith == embeddedHadith)&&(identical(other.requestedHadithId, requestedHadithId) || other.requestedHadithId == requestedHadithId)&&(identical(other.explanationReference, explanationReference) || other.explanationReference == explanationReference)&&(identical(other.provenance, provenance) || other.provenance == provenance)&&(identical(other.sharhMetadata, sharhMetadata) || other.sharhMetadata == sharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hadith,document,embeddedHadith,requestedHadithId,explanationReference,provenance,sharhMetadata);
}

@override
String toString() {
    return 'Sharh(hadith: $hadith, document: $document, embeddedHadith: $embeddedHadith, requestedHadithId: $requestedHadithId, explanationReference: $explanationReference, provenance: $provenance, sharhMetadata: $sharhMetadata)';
}


}

/// @nodoc
abstract mixin class _$SharhCopyWith<$Res> implements $SharhCopyWith<$Res> {
  factory _$SharhCopyWith(_Sharh value, $Res Function(_Sharh) _then) = __$SharhCopyWithImpl;
@override @useResult
$Res call({
 DetailedHadith hadith, SourcedDocument? document, DetailedHadith? embeddedHadith, String? requestedHadithId, ExplanationReference? explanationReference, ResultProvenance? provenance, SharhMetadata? sharhMetadata
});


@override $DetailedHadithCopyWith<$Res> get hadith;@override $DetailedHadithCopyWith<$Res>? get embeddedHadith;@override $SharhMetadataCopyWith<$Res>? get sharhMetadata;

}
/// @nodoc
class __$SharhCopyWithImpl<$Res>
    implements _$SharhCopyWith<$Res> {
  __$SharhCopyWithImpl(this._self, this._then);

  final _Sharh _self;
  final $Res Function(_Sharh) _then;

/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hadith = null,Object? document = freezed,Object? embeddedHadith = freezed,Object? requestedHadithId = freezed,Object? explanationReference = freezed,Object? provenance = freezed,Object? sharhMetadata = freezed,}) {
  return _then(_Sharh(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as DetailedHadith,document: freezed == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as SourcedDocument?,embeddedHadith: freezed == embeddedHadith ? _self.embeddedHadith : embeddedHadith // ignore: cast_nullable_to_non_nullable
as DetailedHadith?,requestedHadithId: freezed == requestedHadithId ? _self.requestedHadithId : requestedHadithId // ignore: cast_nullable_to_non_nullable
as String?,explanationReference: freezed == explanationReference ? _self.explanationReference : explanationReference // ignore: cast_nullable_to_non_nullable
as ExplanationReference?,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as ResultProvenance?,sharhMetadata: freezed == sharhMetadata ? _self.sharhMetadata : sharhMetadata // ignore: cast_nullable_to_non_nullable
as SharhMetadata?,
  ));
}

/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailedHadithCopyWith<$Res> get hadith {
  
  return $DetailedHadithCopyWith<$Res>(_self.hadith, (value) {
    return _then(_self.copyWith(hadith: value));
  });
}/// Create a copy of Sharh
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailedHadithCopyWith<$Res>? get embeddedHadith {
    if (_self.embeddedHadith == null) {
    return null;
  }

  return $DetailedHadithCopyWith<$Res>(_self.embeddedHadith!, (value) {
    return _then(_self.copyWith(embeddedHadith: value));
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
