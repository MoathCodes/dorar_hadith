// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HadithSearchParams {

/// The search query text
 String get value;/// Page number for pagination (default: 1)
 int get page;/// Whether to remove HTML tags from results (default: true)
 bool get removeHtml;/// When `true`, use Dorar.net's `#specialist` tab (`&all` URL flag): results
/// include takhrij metadata and only hadiths that have takhrij are returned.
/// Dorar labels this tab "متخصص" in its UI; the parameter name is historical.
 bool get specialist;/// Words or phrases to exclude from search
 String? get exclude;/// Search method (all words, any word, exact match)
 SearchMethod? get searchMethod;/// Hadith type classification (all, marfoo, qudsi, athar, sharh)
 SearchZone? get zone; Set<HadithTypeFilter> get types; HadithSort? get sort; List<String> get optionalPhrases; ParsePolicy get parsePolicy;/// Filter by hadith degrees (sahih, daif, etc.)
 List<HadithDegree>? get degrees;/// Filter by specific scholars (mohdith)
 List<MohdithReference>? get mohdith;/// Filter by specific books
 List<BookReference>? get books;/// Filter by specific narrators (rawi)
 List<RawiReference>? get rawi; List<ScholarId> get scholarIds; List<BookId> get bookIds; List<NarratorChoiceId> get narratorChoiceIds;
/// Create a copy of HadithSearchParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadithSearchParamsCopyWith<HadithSearchParams> get copyWith => _$HadithSearchParamsCopyWithImpl<HadithSearchParams>(this as HadithSearchParams, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HadithSearchParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadithSearchParams&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.removeHtml, _this.removeHtml) || other.removeHtml == _this.removeHtml)&&(identical(other.specialist, _this.specialist) || other.specialist == _this.specialist)&&(identical(other.exclude, _this.exclude) || other.exclude == _this.exclude)&&(identical(other.searchMethod, _this.searchMethod) || other.searchMethod == _this.searchMethod)&&(identical(other.zone, _this.zone) || other.zone == _this.zone)&&const DeepCollectionEquality().equals(other.types, _this.types)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&const DeepCollectionEquality().equals(other.optionalPhrases, _this.optionalPhrases)&&(identical(other.parsePolicy, _this.parsePolicy) || other.parsePolicy == _this.parsePolicy)&&const DeepCollectionEquality().equals(other.degrees, _this.degrees)&&const DeepCollectionEquality().equals(other.mohdith, _this.mohdith)&&const DeepCollectionEquality().equals(other.books, _this.books)&&const DeepCollectionEquality().equals(other.rawi, _this.rawi)&&const DeepCollectionEquality().equals(other.scholarIds, _this.scholarIds)&&const DeepCollectionEquality().equals(other.bookIds, _this.bookIds)&&const DeepCollectionEquality().equals(other.narratorChoiceIds, _this.narratorChoiceIds));
}


@override
int get hashCode {
  final _this = this as HadithSearchParams;
  return Object.hash(runtimeType,_this.value,_this.page,_this.removeHtml,_this.specialist,_this.exclude,_this.searchMethod,_this.zone,const DeepCollectionEquality().hash(_this.types),_this.sort,const DeepCollectionEquality().hash(_this.optionalPhrases),_this.parsePolicy,const DeepCollectionEquality().hash(_this.degrees),const DeepCollectionEquality().hash(_this.mohdith),const DeepCollectionEquality().hash(_this.books),const DeepCollectionEquality().hash(_this.rawi),const DeepCollectionEquality().hash(_this.scholarIds),const DeepCollectionEquality().hash(_this.bookIds),const DeepCollectionEquality().hash(_this.narratorChoiceIds));
}

@override
String toString() {
  final _this = this as HadithSearchParams;
  return 'HadithSearchParams(value: ${_this.value}, page: ${_this.page}, removeHtml: ${_this.removeHtml}, specialist: ${_this.specialist}, exclude: ${_this.exclude}, searchMethod: ${_this.searchMethod}, zone: ${_this.zone}, types: ${_this.types}, sort: ${_this.sort}, optionalPhrases: ${_this.optionalPhrases}, parsePolicy: ${_this.parsePolicy}, degrees: ${_this.degrees}, mohdith: ${_this.mohdith}, books: ${_this.books}, rawi: ${_this.rawi}, scholarIds: ${_this.scholarIds}, bookIds: ${_this.bookIds}, narratorChoiceIds: ${_this.narratorChoiceIds})';
}


}

/// @nodoc
abstract mixin class $HadithSearchParamsCopyWith<$Res>  {
  factory $HadithSearchParamsCopyWith(HadithSearchParams value, $Res Function(HadithSearchParams) _then) = _$HadithSearchParamsCopyWithImpl;
@useResult
$Res call({
 String value, int page, bool removeHtml, bool specialist, String? exclude, SearchMethod? searchMethod, SearchZone? zone, Set<HadithTypeFilter> types, HadithSort? sort, List<String> optionalPhrases, ParsePolicy parsePolicy, List<HadithDegree>? degrees, List<MohdithReference>? mohdith, List<BookReference>? books, List<RawiReference>? rawi, List<ScholarId> scholarIds, List<BookId> bookIds, List<NarratorChoiceId> narratorChoiceIds
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
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? page = null,Object? removeHtml = null,Object? specialist = null,Object? exclude = freezed,Object? searchMethod = freezed,Object? zone = freezed,Object? types = null,Object? sort = freezed,Object? optionalPhrases = null,Object? parsePolicy = null,Object? degrees = freezed,Object? mohdith = freezed,Object? books = freezed,Object? rawi = freezed,Object? scholarIds = null,Object? bookIds = null,Object? narratorChoiceIds = null,}) {
  return _then(HadithSearchParams(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,removeHtml: null == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
as bool,specialist: null == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as bool,exclude: freezed == exclude ? _self.exclude : exclude // ignore: cast_nullable_to_non_nullable
as String?,searchMethod: freezed == searchMethod ? _self.searchMethod : searchMethod // ignore: cast_nullable_to_non_nullable
as SearchMethod?,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as SearchZone?,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as Set<HadithTypeFilter>,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as HadithSort?,optionalPhrases: null == optionalPhrases ? _self.optionalPhrases : optionalPhrases // ignore: cast_nullable_to_non_nullable
as List<String>,parsePolicy: null == parsePolicy ? _self.parsePolicy : parsePolicy // ignore: cast_nullable_to_non_nullable
as ParsePolicy,degrees: freezed == degrees ? _self.degrees : degrees // ignore: cast_nullable_to_non_nullable
as List<HadithDegree>?,mohdith: freezed == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as List<MohdithReference>?,books: freezed == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<BookReference>?,rawi: freezed == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as List<RawiReference>?,scholarIds: null == scholarIds ? _self.scholarIds : scholarIds // ignore: cast_nullable_to_non_nullable
as List<ScholarId>,bookIds: null == bookIds ? _self.bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<BookId>,narratorChoiceIds: null == narratorChoiceIds ? _self.narratorChoiceIds : narratorChoiceIds // ignore: cast_nullable_to_non_nullable
as List<NarratorChoiceId>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  int page,  bool removeHtml,  bool specialist,  String? exclude,  SearchMethod? searchMethod,  SearchZone? zone,  Set<HadithTypeFilter> types,  HadithSort? sort,  List<String> optionalPhrases,  ParsePolicy parsePolicy,  List<HadithDegree>? degrees,  List<MohdithReference>? mohdith,  List<BookReference>? books,  List<RawiReference>? rawi,  List<ScholarId> scholarIds,  List<BookId> bookIds,  List<NarratorChoiceId> narratorChoiceIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadithSearchParams() when $default != null:
return $default(_that.value,_that.page,_that.removeHtml,_that.specialist,_that.exclude,_that.searchMethod,_that.zone,_that.types,_that.sort,_that.optionalPhrases,_that.parsePolicy,_that.degrees,_that.mohdith,_that.books,_that.rawi,_that.scholarIds,_that.bookIds,_that.narratorChoiceIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  int page,  bool removeHtml,  bool specialist,  String? exclude,  SearchMethod? searchMethod,  SearchZone? zone,  Set<HadithTypeFilter> types,  HadithSort? sort,  List<String> optionalPhrases,  ParsePolicy parsePolicy,  List<HadithDegree>? degrees,  List<MohdithReference>? mohdith,  List<BookReference>? books,  List<RawiReference>? rawi,  List<ScholarId> scholarIds,  List<BookId> bookIds,  List<NarratorChoiceId> narratorChoiceIds)  $default,) {final _that = this;
switch (_that) {
case _HadithSearchParams():
return $default(_that.value,_that.page,_that.removeHtml,_that.specialist,_that.exclude,_that.searchMethod,_that.zone,_that.types,_that.sort,_that.optionalPhrases,_that.parsePolicy,_that.degrees,_that.mohdith,_that.books,_that.rawi,_that.scholarIds,_that.bookIds,_that.narratorChoiceIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  int page,  bool removeHtml,  bool specialist,  String? exclude,  SearchMethod? searchMethod,  SearchZone? zone,  Set<HadithTypeFilter> types,  HadithSort? sort,  List<String> optionalPhrases,  ParsePolicy parsePolicy,  List<HadithDegree>? degrees,  List<MohdithReference>? mohdith,  List<BookReference>? books,  List<RawiReference>? rawi,  List<ScholarId> scholarIds,  List<BookId> bookIds,  List<NarratorChoiceId> narratorChoiceIds)?  $default,) {final _that = this;
switch (_that) {
case _HadithSearchParams() when $default != null:
return $default(_that.value,_that.page,_that.removeHtml,_that.specialist,_that.exclude,_that.searchMethod,_that.zone,_that.types,_that.sort,_that.optionalPhrases,_that.parsePolicy,_that.degrees,_that.mohdith,_that.books,_that.rawi,_that.scholarIds,_that.bookIds,_that.narratorChoiceIds);case _:
  return null;

}
}

}

/// @nodoc


class _HadithSearchParams implements HadithSearchParams {
  const _HadithSearchParams({required this.value, this.page = 1, this.removeHtml = true, this.specialist = false, this.exclude, this.searchMethod, this.zone, this.types = const <HadithTypeFilter>{}, this.sort, this.optionalPhrases = const <String>[], this.parsePolicy = ParsePolicy.strict, this.degrees, this.mohdith, this.books, this.rawi, this.scholarIds = const [], this.bookIds = const [], this.narratorChoiceIds = const []});
  

/// The search query text
@override final  String value;
/// Page number for pagination (default: 1)
@override@JsonKey() final  int page;
/// Whether to remove HTML tags from results (default: true)
@override@JsonKey() final  bool removeHtml;
/// When `true`, use Dorar.net's `#specialist` tab (`&all` URL flag): results
/// include takhrij metadata and only hadiths that have takhrij are returned.
/// Dorar labels this tab "متخصص" in its UI; the parameter name is historical.
@override@JsonKey() final  bool specialist;
/// Words or phrases to exclude from search
@override final  String? exclude;
/// Search method (all words, any word, exact match)
@override final  SearchMethod? searchMethod;
/// Hadith type classification (all, marfoo, qudsi, athar, sharh)
@override final  SearchZone? zone;
@override@JsonKey() final  Set<HadithTypeFilter> types;
@override final  HadithSort? sort;
@override@JsonKey() final  List<String> optionalPhrases;
@override@JsonKey() final  ParsePolicy parsePolicy;
/// Filter by hadith degrees (sahih, daif, etc.)
@override final  List<HadithDegree>? degrees;
/// Filter by specific scholars (mohdith)
@override final  List<MohdithReference>? mohdith;
/// Filter by specific books
@override final  List<BookReference>? books;
/// Filter by specific narrators (rawi)
@override final  List<RawiReference>? rawi;
@override@JsonKey() final  List<ScholarId> scholarIds;
@override@JsonKey() final  List<BookId> bookIds;
@override@JsonKey() final  List<NarratorChoiceId> narratorChoiceIds;

/// Create a copy of HadithSearchParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadithSearchParamsCopyWith<_HadithSearchParams> get copyWith => __$HadithSearchParamsCopyWithImpl<_HadithSearchParams>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadithSearchParams&&(identical(other.value, value) || other.value == value)&&(identical(other.page, page) || other.page == page)&&(identical(other.removeHtml, removeHtml) || other.removeHtml == removeHtml)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.exclude, exclude) || other.exclude == exclude)&&(identical(other.searchMethod, searchMethod) || other.searchMethod == searchMethod)&&(identical(other.zone, zone) || other.zone == zone)&&const DeepCollectionEquality().equals(other.types, types)&&(identical(other.sort, sort) || other.sort == sort)&&const DeepCollectionEquality().equals(other.optionalPhrases, optionalPhrases)&&(identical(other.parsePolicy, parsePolicy) || other.parsePolicy == parsePolicy)&&const DeepCollectionEquality().equals(other.degrees, degrees)&&const DeepCollectionEquality().equals(other.mohdith, mohdith)&&const DeepCollectionEquality().equals(other.books, books)&&const DeepCollectionEquality().equals(other.rawi, rawi)&&const DeepCollectionEquality().equals(other.scholarIds, scholarIds)&&const DeepCollectionEquality().equals(other.bookIds, bookIds)&&const DeepCollectionEquality().equals(other.narratorChoiceIds, narratorChoiceIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value,page,removeHtml,specialist,exclude,searchMethod,zone,const DeepCollectionEquality().hash(types),sort,const DeepCollectionEquality().hash(optionalPhrases),parsePolicy,const DeepCollectionEquality().hash(degrees),const DeepCollectionEquality().hash(mohdith),const DeepCollectionEquality().hash(books),const DeepCollectionEquality().hash(rawi),const DeepCollectionEquality().hash(scholarIds),const DeepCollectionEquality().hash(bookIds),const DeepCollectionEquality().hash(narratorChoiceIds));
}

@override
String toString() {
    return 'HadithSearchParams(value: $value, page: $page, removeHtml: $removeHtml, specialist: $specialist, exclude: $exclude, searchMethod: $searchMethod, zone: $zone, types: $types, sort: $sort, optionalPhrases: $optionalPhrases, parsePolicy: $parsePolicy, degrees: $degrees, mohdith: $mohdith, books: $books, rawi: $rawi, scholarIds: $scholarIds, bookIds: $bookIds, narratorChoiceIds: $narratorChoiceIds)';
}


}

/// @nodoc
abstract mixin class _$HadithSearchParamsCopyWith<$Res> implements $HadithSearchParamsCopyWith<$Res> {
  factory _$HadithSearchParamsCopyWith(_HadithSearchParams value, $Res Function(_HadithSearchParams) _then) = __$HadithSearchParamsCopyWithImpl;
@override @useResult
$Res call({
 String value, int page, bool removeHtml, bool specialist, String? exclude, SearchMethod? searchMethod, SearchZone? zone, Set<HadithTypeFilter> types, HadithSort? sort, List<String> optionalPhrases, ParsePolicy parsePolicy, List<HadithDegree>? degrees, List<MohdithReference>? mohdith, List<BookReference>? books, List<RawiReference>? rawi, List<ScholarId> scholarIds, List<BookId> bookIds, List<NarratorChoiceId> narratorChoiceIds
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
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? page = null,Object? removeHtml = null,Object? specialist = null,Object? exclude = freezed,Object? searchMethod = freezed,Object? zone = freezed,Object? types = null,Object? sort = freezed,Object? optionalPhrases = null,Object? parsePolicy = null,Object? degrees = freezed,Object? mohdith = freezed,Object? books = freezed,Object? rawi = freezed,Object? scholarIds = null,Object? bookIds = null,Object? narratorChoiceIds = null,}) {
  return _then(_HadithSearchParams(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,removeHtml: null == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
as bool,specialist: null == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as bool,exclude: freezed == exclude ? _self.exclude : exclude // ignore: cast_nullable_to_non_nullable
as String?,searchMethod: freezed == searchMethod ? _self.searchMethod : searchMethod // ignore: cast_nullable_to_non_nullable
as SearchMethod?,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as SearchZone?,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as Set<HadithTypeFilter>,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as HadithSort?,optionalPhrases: null == optionalPhrases ? _self.optionalPhrases : optionalPhrases // ignore: cast_nullable_to_non_nullable
as List<String>,parsePolicy: null == parsePolicy ? _self.parsePolicy : parsePolicy // ignore: cast_nullable_to_non_nullable
as ParsePolicy,degrees: freezed == degrees ? _self.degrees : degrees // ignore: cast_nullable_to_non_nullable
as List<HadithDegree>?,mohdith: freezed == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as List<MohdithReference>?,books: freezed == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<BookReference>?,rawi: freezed == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as List<RawiReference>?,scholarIds: null == scholarIds ? _self.scholarIds : scholarIds // ignore: cast_nullable_to_non_nullable
as List<ScholarId>,bookIds: null == bookIds ? _self.bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<BookId>,narratorChoiceIds: null == narratorChoiceIds ? _self.narratorChoiceIds : narratorChoiceIds // ignore: cast_nullable_to_non_nullable
as List<NarratorChoiceId>,
  ));
}


}

// dart format on
