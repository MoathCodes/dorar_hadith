// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HadithSearchParams {

/// The search query text
 String get value;/// Page number for pagination (default: 1)
 int get page;/// Whether to remove HTML tags from results (default: true)
 bool get removeHtml;/// Include specialist/advanced hadiths (default: false)
 bool get specialist;/// Words or phrases to exclude from search
 String? get exclude;/// Search method (all words, any word, exact match)
 SearchMethod? get searchMethod;/// Hadith type classification (all, marfoo, qudsi, athar, sharh)
 SearchZone? get zone;/// Filter by hadith degrees (sahih, daif, etc.)
 List<HadithDegree>? get degrees;/// Filter by specific scholars (mohdith)
 List<MohdithReference>? get mohdith;/// Filter by specific books
 List<BookReference>? get books;/// Filter by specific narrators (rawi)
 List<RawiReference>? get rawi;
/// Create a copy of HadithSearchParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadithSearchParamsCopyWith<HadithSearchParams> get copyWith => _$HadithSearchParamsCopyWithImpl<HadithSearchParams>(this as HadithSearchParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadithSearchParams&&(identical(other.value, value) || other.value == value)&&(identical(other.page, page) || other.page == page)&&(identical(other.removeHtml, removeHtml) || other.removeHtml == removeHtml)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.exclude, exclude) || other.exclude == exclude)&&(identical(other.searchMethod, searchMethod) || other.searchMethod == searchMethod)&&(identical(other.zone, zone) || other.zone == zone)&&const DeepCollectionEquality().equals(other.degrees, degrees)&&const DeepCollectionEquality().equals(other.mohdith, mohdith)&&const DeepCollectionEquality().equals(other.books, books)&&const DeepCollectionEquality().equals(other.rawi, rawi));
}


@override
int get hashCode => Object.hash(runtimeType,value,page,removeHtml,specialist,exclude,searchMethod,zone,const DeepCollectionEquality().hash(degrees),const DeepCollectionEquality().hash(mohdith),const DeepCollectionEquality().hash(books),const DeepCollectionEquality().hash(rawi));

@override
String toString() {
  return 'HadithSearchParams(value: $value, page: $page, removeHtml: $removeHtml, specialist: $specialist, exclude: $exclude, searchMethod: $searchMethod, zone: $zone, degrees: $degrees, mohdith: $mohdith, books: $books, rawi: $rawi)';
}


}

/// @nodoc
abstract mixin class $HadithSearchParamsCopyWith<$Res>  {
  factory $HadithSearchParamsCopyWith(HadithSearchParams value, $Res Function(HadithSearchParams) _then) = _$HadithSearchParamsCopyWithImpl;
@useResult
$Res call({
 String value, int page, bool removeHtml, bool specialist, String? exclude, SearchMethod? searchMethod, SearchZone? zone, List<HadithDegree>? degrees, List<MohdithReference>? mohdith, List<BookReference>? books, List<RawiReference>? rawi
});




}
/// @nodoc
class _$HadithSearchParamsCopyWithImpl<$Res>
    implements $HadithSearchParamsCopyWith<$Res> {
  _$HadithSearchParamsCopyWithImpl(this._self, this._then);

  final HadithSearchParams _self;
  final $Res Function(HadithSearchParams) _then;

/// Create a copy of HadithSearchParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? page = null,Object? removeHtml = null,Object? specialist = null,Object? exclude = freezed,Object? searchMethod = freezed,Object? zone = freezed,Object? degrees = freezed,Object? mohdith = freezed,Object? books = freezed,Object? rawi = freezed,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,removeHtml: null == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
as bool,specialist: null == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as bool,exclude: freezed == exclude ? _self.exclude : exclude // ignore: cast_nullable_to_non_nullable
as String?,searchMethod: freezed == searchMethod ? _self.searchMethod : searchMethod // ignore: cast_nullable_to_non_nullable
as SearchMethod?,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as SearchZone?,degrees: freezed == degrees ? _self.degrees : degrees // ignore: cast_nullable_to_non_nullable
as List<HadithDegree>?,mohdith: freezed == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as List<MohdithReference>?,books: freezed == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<BookReference>?,rawi: freezed == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as List<RawiReference>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HadithSearchParams].
extension HadithSearchParamsPatterns on HadithSearchParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadithSearchParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadithSearchParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadithSearchParams value)  $default,){
final _that = this;
switch (_that) {
case _HadithSearchParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadithSearchParams value)?  $default,){
final _that = this;
switch (_that) {
case _HadithSearchParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  int page,  bool removeHtml,  bool specialist,  String? exclude,  SearchMethod? searchMethod,  SearchZone? zone,  List<HadithDegree>? degrees,  List<MohdithReference>? mohdith,  List<BookReference>? books,  List<RawiReference>? rawi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadithSearchParams() when $default != null:
return $default(_that.value,_that.page,_that.removeHtml,_that.specialist,_that.exclude,_that.searchMethod,_that.zone,_that.degrees,_that.mohdith,_that.books,_that.rawi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  int page,  bool removeHtml,  bool specialist,  String? exclude,  SearchMethod? searchMethod,  SearchZone? zone,  List<HadithDegree>? degrees,  List<MohdithReference>? mohdith,  List<BookReference>? books,  List<RawiReference>? rawi)  $default,) {final _that = this;
switch (_that) {
case _HadithSearchParams():
return $default(_that.value,_that.page,_that.removeHtml,_that.specialist,_that.exclude,_that.searchMethod,_that.zone,_that.degrees,_that.mohdith,_that.books,_that.rawi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  int page,  bool removeHtml,  bool specialist,  String? exclude,  SearchMethod? searchMethod,  SearchZone? zone,  List<HadithDegree>? degrees,  List<MohdithReference>? mohdith,  List<BookReference>? books,  List<RawiReference>? rawi)?  $default,) {final _that = this;
switch (_that) {
case _HadithSearchParams() when $default != null:
return $default(_that.value,_that.page,_that.removeHtml,_that.specialist,_that.exclude,_that.searchMethod,_that.zone,_that.degrees,_that.mohdith,_that.books,_that.rawi);case _:
  return null;

}
}

}

/// @nodoc


class _HadithSearchParams implements HadithSearchParams {
  const _HadithSearchParams({required this.value, this.page = 1, this.removeHtml = true, this.specialist = false, this.exclude, this.searchMethod, this.zone, final  List<HadithDegree>? degrees, final  List<MohdithReference>? mohdith, final  List<BookReference>? books, final  List<RawiReference>? rawi}): _degrees = degrees,_mohdith = mohdith,_books = books,_rawi = rawi;
  

/// The search query text
@override final  String value;
/// Page number for pagination (default: 1)
@override@JsonKey() final  int page;
/// Whether to remove HTML tags from results (default: true)
@override@JsonKey() final  bool removeHtml;
/// Include specialist/advanced hadiths (default: false)
@override@JsonKey() final  bool specialist;
/// Words or phrases to exclude from search
@override final  String? exclude;
/// Search method (all words, any word, exact match)
@override final  SearchMethod? searchMethod;
/// Hadith type classification (all, marfoo, qudsi, athar, sharh)
@override final  SearchZone? zone;
/// Filter by hadith degrees (sahih, daif, etc.)
 final  List<HadithDegree>? _degrees;
/// Filter by hadith degrees (sahih, daif, etc.)
@override List<HadithDegree>? get degrees {
  final value = _degrees;
  if (value == null) return null;
  if (_degrees is EqualUnmodifiableListView) return _degrees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Filter by specific scholars (mohdith)
 final  List<MohdithReference>? _mohdith;
/// Filter by specific scholars (mohdith)
@override List<MohdithReference>? get mohdith {
  final value = _mohdith;
  if (value == null) return null;
  if (_mohdith is EqualUnmodifiableListView) return _mohdith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Filter by specific books
 final  List<BookReference>? _books;
/// Filter by specific books
@override List<BookReference>? get books {
  final value = _books;
  if (value == null) return null;
  if (_books is EqualUnmodifiableListView) return _books;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Filter by specific narrators (rawi)
 final  List<RawiReference>? _rawi;
/// Filter by specific narrators (rawi)
@override List<RawiReference>? get rawi {
  final value = _rawi;
  if (value == null) return null;
  if (_rawi is EqualUnmodifiableListView) return _rawi;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HadithSearchParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadithSearchParamsCopyWith<_HadithSearchParams> get copyWith => __$HadithSearchParamsCopyWithImpl<_HadithSearchParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadithSearchParams&&(identical(other.value, value) || other.value == value)&&(identical(other.page, page) || other.page == page)&&(identical(other.removeHtml, removeHtml) || other.removeHtml == removeHtml)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.exclude, exclude) || other.exclude == exclude)&&(identical(other.searchMethod, searchMethod) || other.searchMethod == searchMethod)&&(identical(other.zone, zone) || other.zone == zone)&&const DeepCollectionEquality().equals(other._degrees, _degrees)&&const DeepCollectionEquality().equals(other._mohdith, _mohdith)&&const DeepCollectionEquality().equals(other._books, _books)&&const DeepCollectionEquality().equals(other._rawi, _rawi));
}


@override
int get hashCode => Object.hash(runtimeType,value,page,removeHtml,specialist,exclude,searchMethod,zone,const DeepCollectionEquality().hash(_degrees),const DeepCollectionEquality().hash(_mohdith),const DeepCollectionEquality().hash(_books),const DeepCollectionEquality().hash(_rawi));

@override
String toString() {
  return 'HadithSearchParams(value: $value, page: $page, removeHtml: $removeHtml, specialist: $specialist, exclude: $exclude, searchMethod: $searchMethod, zone: $zone, degrees: $degrees, mohdith: $mohdith, books: $books, rawi: $rawi)';
}


}

/// @nodoc
abstract mixin class _$HadithSearchParamsCopyWith<$Res> implements $HadithSearchParamsCopyWith<$Res> {
  factory _$HadithSearchParamsCopyWith(_HadithSearchParams value, $Res Function(_HadithSearchParams) _then) = __$HadithSearchParamsCopyWithImpl;
@override @useResult
$Res call({
 String value, int page, bool removeHtml, bool specialist, String? exclude, SearchMethod? searchMethod, SearchZone? zone, List<HadithDegree>? degrees, List<MohdithReference>? mohdith, List<BookReference>? books, List<RawiReference>? rawi
});




}
/// @nodoc
class __$HadithSearchParamsCopyWithImpl<$Res>
    implements _$HadithSearchParamsCopyWith<$Res> {
  __$HadithSearchParamsCopyWithImpl(this._self, this._then);

  final _HadithSearchParams _self;
  final $Res Function(_HadithSearchParams) _then;

/// Create a copy of HadithSearchParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? page = null,Object? removeHtml = null,Object? specialist = null,Object? exclude = freezed,Object? searchMethod = freezed,Object? zone = freezed,Object? degrees = freezed,Object? mohdith = freezed,Object? books = freezed,Object? rawi = freezed,}) {
  return _then(_HadithSearchParams(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,removeHtml: null == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
as bool,specialist: null == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as bool,exclude: freezed == exclude ? _self.exclude : exclude // ignore: cast_nullable_to_non_nullable
as String?,searchMethod: freezed == searchMethod ? _self.searchMethod : searchMethod // ignore: cast_nullable_to_non_nullable
as SearchMethod?,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as SearchZone?,degrees: freezed == degrees ? _self._degrees : degrees // ignore: cast_nullable_to_non_nullable
as List<HadithDegree>?,mohdith: freezed == mohdith ? _self._mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as List<MohdithReference>?,books: freezed == books ? _self._books : books // ignore: cast_nullable_to_non_nullable
as List<BookReference>?,rawi: freezed == rawi ? _self._rawi : rawi // ignore: cast_nullable_to_non_nullable
as List<RawiReference>?,
  ));
}


}

// dart format on
