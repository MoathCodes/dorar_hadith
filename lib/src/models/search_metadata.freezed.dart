// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchMetadata {

/// Number of results returned
 int get length;/// Current page number
 int? get page;/// Whether HTML tags were removed from results
@JsonKey(name: 'removeHTML') bool? get removeHtml;/// Whether specialist/advanced hadiths are included
 bool? get specialist;/// Number of non-specialist hadiths
 int? get numberOfNonSpecialist;/// Number of specialist hadiths
 int? get numberOfSpecialist;/// Whether this result came from cache
 bool get isCached;/// Number of usul (sources) for usul hadith requests
 int? get usulSourcesCount;
/// Create a copy of SearchMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchMetadataCopyWith<SearchMetadata> get copyWith => _$SearchMetadataCopyWithImpl<SearchMetadata>(this as SearchMetadata, _$identity);

  /// Serializes this SearchMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchMetadata&&(identical(other.length, length) || other.length == length)&&(identical(other.page, page) || other.page == page)&&(identical(other.removeHtml, removeHtml) || other.removeHtml == removeHtml)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.numberOfNonSpecialist, numberOfNonSpecialist) || other.numberOfNonSpecialist == numberOfNonSpecialist)&&(identical(other.numberOfSpecialist, numberOfSpecialist) || other.numberOfSpecialist == numberOfSpecialist)&&(identical(other.isCached, isCached) || other.isCached == isCached)&&(identical(other.usulSourcesCount, usulSourcesCount) || other.usulSourcesCount == usulSourcesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,length,page,removeHtml,specialist,numberOfNonSpecialist,numberOfSpecialist,isCached,usulSourcesCount);

@override
String toString() {
  return 'SearchMetadata(length: $length, page: $page, removeHtml: $removeHtml, specialist: $specialist, numberOfNonSpecialist: $numberOfNonSpecialist, numberOfSpecialist: $numberOfSpecialist, isCached: $isCached, usulSourcesCount: $usulSourcesCount)';
}


}

/// @nodoc
abstract mixin class $SearchMetadataCopyWith<$Res>  {
  factory $SearchMetadataCopyWith(SearchMetadata value, $Res Function(SearchMetadata) _then) = _$SearchMetadataCopyWithImpl;
@useResult
$Res call({
 int length, int? page,@JsonKey(name: 'removeHTML') bool? removeHtml, bool? specialist, int? numberOfNonSpecialist, int? numberOfSpecialist, bool isCached, int? usulSourcesCount
});




}
/// @nodoc
class _$SearchMetadataCopyWithImpl<$Res>
    implements $SearchMetadataCopyWith<$Res> {
  _$SearchMetadataCopyWithImpl(this._self, this._then);

  final SearchMetadata _self;
  final $Res Function(SearchMetadata) _then;

/// Create a copy of SearchMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? length = null,Object? page = freezed,Object? removeHtml = freezed,Object? specialist = freezed,Object? numberOfNonSpecialist = freezed,Object? numberOfSpecialist = freezed,Object? isCached = null,Object? usulSourcesCount = freezed,}) {
  return _then(_self.copyWith(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,removeHtml: freezed == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
as bool?,specialist: freezed == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as bool?,numberOfNonSpecialist: freezed == numberOfNonSpecialist ? _self.numberOfNonSpecialist : numberOfNonSpecialist // ignore: cast_nullable_to_non_nullable
as int?,numberOfSpecialist: freezed == numberOfSpecialist ? _self.numberOfSpecialist : numberOfSpecialist // ignore: cast_nullable_to_non_nullable
as int?,isCached: null == isCached ? _self.isCached : isCached // ignore: cast_nullable_to_non_nullable
as bool,usulSourcesCount: freezed == usulSourcesCount ? _self.usulSourcesCount : usulSourcesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchMetadata].
extension SearchMetadataPatterns on SearchMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchMetadata value)  $default,){
final _that = this;
switch (_that) {
case _SearchMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _SearchMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int length,  int? page, @JsonKey(name: 'removeHTML')  bool? removeHtml,  bool? specialist,  int? numberOfNonSpecialist,  int? numberOfSpecialist,  bool isCached,  int? usulSourcesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchMetadata() when $default != null:
return $default(_that.length,_that.page,_that.removeHtml,_that.specialist,_that.numberOfNonSpecialist,_that.numberOfSpecialist,_that.isCached,_that.usulSourcesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int length,  int? page, @JsonKey(name: 'removeHTML')  bool? removeHtml,  bool? specialist,  int? numberOfNonSpecialist,  int? numberOfSpecialist,  bool isCached,  int? usulSourcesCount)  $default,) {final _that = this;
switch (_that) {
case _SearchMetadata():
return $default(_that.length,_that.page,_that.removeHtml,_that.specialist,_that.numberOfNonSpecialist,_that.numberOfSpecialist,_that.isCached,_that.usulSourcesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int length,  int? page, @JsonKey(name: 'removeHTML')  bool? removeHtml,  bool? specialist,  int? numberOfNonSpecialist,  int? numberOfSpecialist,  bool isCached,  int? usulSourcesCount)?  $default,) {final _that = this;
switch (_that) {
case _SearchMetadata() when $default != null:
return $default(_that.length,_that.page,_that.removeHtml,_that.specialist,_that.numberOfNonSpecialist,_that.numberOfSpecialist,_that.isCached,_that.usulSourcesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchMetadata implements SearchMetadata {
  const _SearchMetadata({this.length = 0, this.page, @JsonKey(name: 'removeHTML') this.removeHtml, this.specialist, this.numberOfNonSpecialist, this.numberOfSpecialist, this.isCached = false, this.usulSourcesCount});
  factory _SearchMetadata.fromJson(Map<String, dynamic> json) => _$SearchMetadataFromJson(json);

/// Number of results returned
@override@JsonKey() final  int length;
/// Current page number
@override final  int? page;
/// Whether HTML tags were removed from results
@override@JsonKey(name: 'removeHTML') final  bool? removeHtml;
/// Whether specialist/advanced hadiths are included
@override final  bool? specialist;
/// Number of non-specialist hadiths
@override final  int? numberOfNonSpecialist;
/// Number of specialist hadiths
@override final  int? numberOfSpecialist;
/// Whether this result came from cache
@override@JsonKey() final  bool isCached;
/// Number of usul (sources) for usul hadith requests
@override final  int? usulSourcesCount;

/// Create a copy of SearchMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchMetadataCopyWith<_SearchMetadata> get copyWith => __$SearchMetadataCopyWithImpl<_SearchMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchMetadata&&(identical(other.length, length) || other.length == length)&&(identical(other.page, page) || other.page == page)&&(identical(other.removeHtml, removeHtml) || other.removeHtml == removeHtml)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.numberOfNonSpecialist, numberOfNonSpecialist) || other.numberOfNonSpecialist == numberOfNonSpecialist)&&(identical(other.numberOfSpecialist, numberOfSpecialist) || other.numberOfSpecialist == numberOfSpecialist)&&(identical(other.isCached, isCached) || other.isCached == isCached)&&(identical(other.usulSourcesCount, usulSourcesCount) || other.usulSourcesCount == usulSourcesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,length,page,removeHtml,specialist,numberOfNonSpecialist,numberOfSpecialist,isCached,usulSourcesCount);

@override
String toString() {
  return 'SearchMetadata(length: $length, page: $page, removeHtml: $removeHtml, specialist: $specialist, numberOfNonSpecialist: $numberOfNonSpecialist, numberOfSpecialist: $numberOfSpecialist, isCached: $isCached, usulSourcesCount: $usulSourcesCount)';
}


}

/// @nodoc
abstract mixin class _$SearchMetadataCopyWith<$Res> implements $SearchMetadataCopyWith<$Res> {
  factory _$SearchMetadataCopyWith(_SearchMetadata value, $Res Function(_SearchMetadata) _then) = __$SearchMetadataCopyWithImpl;
@override @useResult
$Res call({
 int length, int? page,@JsonKey(name: 'removeHTML') bool? removeHtml, bool? specialist, int? numberOfNonSpecialist, int? numberOfSpecialist, bool isCached, int? usulSourcesCount
});




}
/// @nodoc
class __$SearchMetadataCopyWithImpl<$Res>
    implements _$SearchMetadataCopyWith<$Res> {
  __$SearchMetadataCopyWithImpl(this._self, this._then);

  final _SearchMetadata _self;
  final $Res Function(_SearchMetadata) _then;

/// Create a copy of SearchMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? length = null,Object? page = freezed,Object? removeHtml = freezed,Object? specialist = freezed,Object? numberOfNonSpecialist = freezed,Object? numberOfSpecialist = freezed,Object? isCached = null,Object? usulSourcesCount = freezed,}) {
  return _then(_SearchMetadata(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,removeHtml: freezed == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
as bool?,specialist: freezed == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as bool?,numberOfNonSpecialist: freezed == numberOfNonSpecialist ? _self.numberOfNonSpecialist : numberOfNonSpecialist // ignore: cast_nullable_to_non_nullable
as int?,numberOfSpecialist: freezed == numberOfSpecialist ? _self.numberOfSpecialist : numberOfSpecialist // ignore: cast_nullable_to_non_nullable
as int?,isCached: null == isCached ? _self.isCached : isCached // ignore: cast_nullable_to_non_nullable
as bool,usulSourcesCount: freezed == usulSourcesCount ? _self.usulSourcesCount : usulSourcesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
