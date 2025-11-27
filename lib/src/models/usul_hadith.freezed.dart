// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usul_hadith.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsulHadith {

/// The main hadith
 DetailedHadith get hadith;/// List of all sources for this hadith
 List<UsulSource> get sources;/// Total count of sources
 int get count;
/// Create a copy of UsulHadith
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsulHadithCopyWith<UsulHadith> get copyWith => _$UsulHadithCopyWithImpl<UsulHadith>(this as UsulHadith, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsulHadith&&(identical(other.hadith, hadith) || other.hadith == hadith)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,hadith,const DeepCollectionEquality().hash(sources),count);

@override
String toString() {
  return 'UsulHadith(hadith: $hadith, sources: $sources, count: $count)';
}


}

/// @nodoc
abstract mixin class $UsulHadithCopyWith<$Res>  {
  factory $UsulHadithCopyWith(UsulHadith value, $Res Function(UsulHadith) _then) = _$UsulHadithCopyWithImpl;
@useResult
$Res call({
 DetailedHadith hadith, List<UsulSource> sources, int count
});


$DetailedHadithCopyWith<$Res> get hadith;

}
/// @nodoc
class _$UsulHadithCopyWithImpl<$Res>
    implements $UsulHadithCopyWith<$Res> {
  _$UsulHadithCopyWithImpl(this._self, this._then);

  final UsulHadith _self;
  final $Res Function(UsulHadith) _then;

/// Create a copy of UsulHadith
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hadith = null,Object? sources = null,Object? count = null,}) {
  return _then(_self.copyWith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as DetailedHadith,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<UsulSource>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of UsulHadith
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailedHadithCopyWith<$Res> get hadith {
  
  return $DetailedHadithCopyWith<$Res>(_self.hadith, (value) {
    return _then(_self.copyWith(hadith: value));
  });
}
}


/// Adds pattern-matching-related methods to [UsulHadith].
extension UsulHadithPatterns on UsulHadith {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsulHadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsulHadith() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsulHadith value)  $default,){
final _that = this;
switch (_that) {
case _UsulHadith():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsulHadith value)?  $default,){
final _that = this;
switch (_that) {
case _UsulHadith() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DetailedHadith hadith,  List<UsulSource> sources,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsulHadith() when $default != null:
return $default(_that.hadith,_that.sources,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DetailedHadith hadith,  List<UsulSource> sources,  int count)  $default,) {final _that = this;
switch (_that) {
case _UsulHadith():
return $default(_that.hadith,_that.sources,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DetailedHadith hadith,  List<UsulSource> sources,  int count)?  $default,) {final _that = this;
switch (_that) {
case _UsulHadith() when $default != null:
return $default(_that.hadith,_that.sources,_that.count);case _:
  return null;

}
}

}

/// @nodoc


class _UsulHadith extends UsulHadith {
  const _UsulHadith({required this.hadith, required final  List<UsulSource> sources, required this.count}): _sources = sources,super._();
  

/// The main hadith
@override final  DetailedHadith hadith;
/// List of all sources for this hadith
 final  List<UsulSource> _sources;
/// List of all sources for this hadith
@override List<UsulSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

/// Total count of sources
@override final  int count;

/// Create a copy of UsulHadith
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsulHadithCopyWith<_UsulHadith> get copyWith => __$UsulHadithCopyWithImpl<_UsulHadith>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsulHadith&&(identical(other.hadith, hadith) || other.hadith == hadith)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,hadith,const DeepCollectionEquality().hash(_sources),count);

@override
String toString() {
  return 'UsulHadith(hadith: $hadith, sources: $sources, count: $count)';
}


}

/// @nodoc
abstract mixin class _$UsulHadithCopyWith<$Res> implements $UsulHadithCopyWith<$Res> {
  factory _$UsulHadithCopyWith(_UsulHadith value, $Res Function(_UsulHadith) _then) = __$UsulHadithCopyWithImpl;
@override @useResult
$Res call({
 DetailedHadith hadith, List<UsulSource> sources, int count
});


@override $DetailedHadithCopyWith<$Res> get hadith;

}
/// @nodoc
class __$UsulHadithCopyWithImpl<$Res>
    implements _$UsulHadithCopyWith<$Res> {
  __$UsulHadithCopyWithImpl(this._self, this._then);

  final _UsulHadith _self;
  final $Res Function(_UsulHadith) _then;

/// Create a copy of UsulHadith
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hadith = null,Object? sources = null,Object? count = null,}) {
  return _then(_UsulHadith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as DetailedHadith,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<UsulSource>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of UsulHadith
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailedHadithCopyWith<$Res> get hadith {
  
  return $DetailedHadithCopyWith<$Res>(_self.hadith, (value) {
    return _then(_self.copyWith(hadith: value));
  });
}
}


/// @nodoc
mixin _$UsulSource {

/// The source book and page reference
 String get source;/// The chain of narration (isnad)
 String get chain;/// The text of the hadith in this source
 String get hadithText;
/// Create a copy of UsulSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsulSourceCopyWith<UsulSource> get copyWith => _$UsulSourceCopyWithImpl<UsulSource>(this as UsulSource, _$identity);

  /// Serializes this UsulSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsulSource&&(identical(other.source, source) || other.source == source)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.hadithText, hadithText) || other.hadithText == hadithText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,chain,hadithText);

@override
String toString() {
  return 'UsulSource(source: $source, chain: $chain, hadithText: $hadithText)';
}


}

/// @nodoc
abstract mixin class $UsulSourceCopyWith<$Res>  {
  factory $UsulSourceCopyWith(UsulSource value, $Res Function(UsulSource) _then) = _$UsulSourceCopyWithImpl;
@useResult
$Res call({
 String source, String chain, String hadithText
});




}
/// @nodoc
class _$UsulSourceCopyWithImpl<$Res>
    implements $UsulSourceCopyWith<$Res> {
  _$UsulSourceCopyWithImpl(this._self, this._then);

  final UsulSource _self;
  final $Res Function(UsulSource) _then;

/// Create a copy of UsulSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? chain = null,Object? hadithText = null,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,hadithText: null == hadithText ? _self.hadithText : hadithText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UsulSource].
extension UsulSourcePatterns on UsulSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsulSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsulSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsulSource value)  $default,){
final _that = this;
switch (_that) {
case _UsulSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsulSource value)?  $default,){
final _that = this;
switch (_that) {
case _UsulSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  String chain,  String hadithText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsulSource() when $default != null:
return $default(_that.source,_that.chain,_that.hadithText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  String chain,  String hadithText)  $default,) {final _that = this;
switch (_that) {
case _UsulSource():
return $default(_that.source,_that.chain,_that.hadithText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  String chain,  String hadithText)?  $default,) {final _that = this;
switch (_that) {
case _UsulSource() when $default != null:
return $default(_that.source,_that.chain,_that.hadithText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsulSource implements UsulSource {
  const _UsulSource({required this.source, required this.chain, required this.hadithText});
  factory _UsulSource.fromJson(Map<String, dynamic> json) => _$UsulSourceFromJson(json);

/// The source book and page reference
@override final  String source;
/// The chain of narration (isnad)
@override final  String chain;
/// The text of the hadith in this source
@override final  String hadithText;

/// Create a copy of UsulSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsulSourceCopyWith<_UsulSource> get copyWith => __$UsulSourceCopyWithImpl<_UsulSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsulSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsulSource&&(identical(other.source, source) || other.source == source)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.hadithText, hadithText) || other.hadithText == hadithText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,chain,hadithText);

@override
String toString() {
  return 'UsulSource(source: $source, chain: $chain, hadithText: $hadithText)';
}


}

/// @nodoc
abstract mixin class _$UsulSourceCopyWith<$Res> implements $UsulSourceCopyWith<$Res> {
  factory _$UsulSourceCopyWith(_UsulSource value, $Res Function(_UsulSource) _then) = __$UsulSourceCopyWithImpl;
@override @useResult
$Res call({
 String source, String chain, String hadithText
});




}
/// @nodoc
class __$UsulSourceCopyWithImpl<$Res>
    implements _$UsulSourceCopyWith<$Res> {
  __$UsulSourceCopyWithImpl(this._self, this._then);

  final _UsulSource _self;
  final $Res Function(_UsulSource) _then;

/// Create a copy of UsulSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? chain = null,Object? hadithText = null,}) {
  return _then(_UsulSource(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,hadithText: null == hadithText ? _self.hadithText : hadithText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
