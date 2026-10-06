// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchMetadata {

/// Number of results returned
 int get length; ParseDiagnostics? get diagnostics; ResultProvenance? get provenance; PageMetadata? get pagination; ReferenceCoverage? get referenceCoverage; List<String> get selectedScholarIds;/// Number of results on this page (same as length for consistency with Node.js API)
 int? get currentPageCount;/// Total number of results across all pages (site endpoint only)
 int? get total;/// Current page number
 int? get page;/// Total number of pages (site endpoint only)
 int? get totalPages;/// Whether there is a next page
 bool? get hasNextPage;/// Whether there is a previous page
 bool? get hasPrevPage;/// Whether HTML tags were removed from results
@JsonKey(name: 'removeHTML') bool? get removeHtml;/// Whether the specialist tab was used (`specialist: true` on Dorar.net).
 bool? get specialist;/// Result count on Dorar's default tab.
 int? get numberOfNonSpecialist;/// Result count on Dorar's specialist tab (hadiths with takhrij; site UI
/// label: "متخصص").
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
  final _this = this as SearchMetadata;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchMetadata&&(identical(other.length, _this.length) || other.length == _this.length)&&(identical(other.diagnostics, _this.diagnostics) || other.diagnostics == _this.diagnostics)&&(identical(other.provenance, _this.provenance) || other.provenance == _this.provenance)&&(identical(other.pagination, _this.pagination) || other.pagination == _this.pagination)&&(identical(other.referenceCoverage, _this.referenceCoverage) || other.referenceCoverage == _this.referenceCoverage)&&const DeepCollectionEquality().equals(other.selectedScholarIds, _this.selectedScholarIds)&&(identical(other.currentPageCount, _this.currentPageCount) || other.currentPageCount == _this.currentPageCount)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages)&&(identical(other.hasNextPage, _this.hasNextPage) || other.hasNextPage == _this.hasNextPage)&&(identical(other.hasPrevPage, _this.hasPrevPage) || other.hasPrevPage == _this.hasPrevPage)&&(identical(other.removeHtml, _this.removeHtml) || other.removeHtml == _this.removeHtml)&&(identical(other.specialist, _this.specialist) || other.specialist == _this.specialist)&&(identical(other.numberOfNonSpecialist, _this.numberOfNonSpecialist) || other.numberOfNonSpecialist == _this.numberOfNonSpecialist)&&(identical(other.numberOfSpecialist, _this.numberOfSpecialist) || other.numberOfSpecialist == _this.numberOfSpecialist)&&(identical(other.isCached, _this.isCached) || other.isCached == _this.isCached)&&(identical(other.usulSourcesCount, _this.usulSourcesCount) || other.usulSourcesCount == _this.usulSourcesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SearchMetadata;
  return Object.hash(runtimeType,_this.length,_this.diagnostics,_this.provenance,_this.pagination,_this.referenceCoverage,const DeepCollectionEquality().hash(_this.selectedScholarIds),_this.currentPageCount,_this.total,_this.page,_this.totalPages,_this.hasNextPage,_this.hasPrevPage,_this.removeHtml,_this.specialist,_this.numberOfNonSpecialist,_this.numberOfSpecialist,_this.isCached,_this.usulSourcesCount);
}

@override
String toString() {
  final _this = this as SearchMetadata;
  return 'SearchMetadata(length: ${_this.length}, diagnostics: ${_this.diagnostics}, provenance: ${_this.provenance}, pagination: ${_this.pagination}, referenceCoverage: ${_this.referenceCoverage}, selectedScholarIds: ${_this.selectedScholarIds}, currentPageCount: ${_this.currentPageCount}, total: ${_this.total}, page: ${_this.page}, totalPages: ${_this.totalPages}, hasNextPage: ${_this.hasNextPage}, hasPrevPage: ${_this.hasPrevPage}, removeHtml: ${_this.removeHtml}, specialist: ${_this.specialist}, numberOfNonSpecialist: ${_this.numberOfNonSpecialist}, numberOfSpecialist: ${_this.numberOfSpecialist}, isCached: ${_this.isCached}, usulSourcesCount: ${_this.usulSourcesCount})';
}


}

/// @nodoc
abstract mixin class $SearchMetadataCopyWith<$Res>  {
  factory $SearchMetadataCopyWith(SearchMetadata value, $Res Function(SearchMetadata) _then) = _$SearchMetadataCopyWithImpl;
@useResult
$Res call({
 int length, ParseDiagnostics? diagnostics, ResultProvenance? provenance, PageMetadata? pagination, ReferenceCoverage? referenceCoverage, List<String> selectedScholarIds, int? currentPageCount, int? total, int? page, int? totalPages, bool? hasNextPage, bool? hasPrevPage,@JsonKey(name: 'removeHTML') bool? removeHtml, bool? specialist, int? numberOfNonSpecialist, int? numberOfSpecialist, bool isCached, int? usulSourcesCount
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
@pragma('vm:prefer-inline') @override $Res call({Object? length = null,Object? diagnostics = freezed,Object? provenance = freezed,Object? pagination = freezed,Object? referenceCoverage = freezed,Object? selectedScholarIds = null,Object? currentPageCount = freezed,Object? total = freezed,Object? page = freezed,Object? totalPages = freezed,Object? hasNextPage = freezed,Object? hasPrevPage = freezed,Object? removeHtml = freezed,Object? specialist = freezed,Object? numberOfNonSpecialist = freezed,Object? numberOfSpecialist = freezed,Object? isCached = null,Object? usulSourcesCount = freezed,}) {
  return _then(SearchMetadata(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,diagnostics: freezed == diagnostics ? _self.diagnostics : diagnostics // ignore: cast_nullable_to_non_nullable
as ParseDiagnostics?,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as ResultProvenance?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PageMetadata?,referenceCoverage: freezed == referenceCoverage ? _self.referenceCoverage : referenceCoverage // ignore: cast_nullable_to_non_nullable
as ReferenceCoverage?,selectedScholarIds: null == selectedScholarIds ? _self.selectedScholarIds : selectedScholarIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentPageCount: freezed == currentPageCount ? _self.currentPageCount : currentPageCount // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,hasNextPage: freezed == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool?,hasPrevPage: freezed == hasPrevPage ? _self.hasPrevPage : hasPrevPage // ignore: cast_nullable_to_non_nullable
as bool?,removeHtml: freezed == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int length,  ParseDiagnostics? diagnostics,  ResultProvenance? provenance,  PageMetadata? pagination,  ReferenceCoverage? referenceCoverage,  List<String> selectedScholarIds,  int? currentPageCount,  int? total,  int? page,  int? totalPages,  bool? hasNextPage,  bool? hasPrevPage, @JsonKey(name: 'removeHTML')  bool? removeHtml,  bool? specialist,  int? numberOfNonSpecialist,  int? numberOfSpecialist,  bool isCached,  int? usulSourcesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchMetadata() when $default != null:
return $default(_that.length,_that.diagnostics,_that.provenance,_that.pagination,_that.referenceCoverage,_that.selectedScholarIds,_that.currentPageCount,_that.total,_that.page,_that.totalPages,_that.hasNextPage,_that.hasPrevPage,_that.removeHtml,_that.specialist,_that.numberOfNonSpecialist,_that.numberOfSpecialist,_that.isCached,_that.usulSourcesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int length,  ParseDiagnostics? diagnostics,  ResultProvenance? provenance,  PageMetadata? pagination,  ReferenceCoverage? referenceCoverage,  List<String> selectedScholarIds,  int? currentPageCount,  int? total,  int? page,  int? totalPages,  bool? hasNextPage,  bool? hasPrevPage, @JsonKey(name: 'removeHTML')  bool? removeHtml,  bool? specialist,  int? numberOfNonSpecialist,  int? numberOfSpecialist,  bool isCached,  int? usulSourcesCount)  $default,) {final _that = this;
switch (_that) {
case _SearchMetadata():
return $default(_that.length,_that.diagnostics,_that.provenance,_that.pagination,_that.referenceCoverage,_that.selectedScholarIds,_that.currentPageCount,_that.total,_that.page,_that.totalPages,_that.hasNextPage,_that.hasPrevPage,_that.removeHtml,_that.specialist,_that.numberOfNonSpecialist,_that.numberOfSpecialist,_that.isCached,_that.usulSourcesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int length,  ParseDiagnostics? diagnostics,  ResultProvenance? provenance,  PageMetadata? pagination,  ReferenceCoverage? referenceCoverage,  List<String> selectedScholarIds,  int? currentPageCount,  int? total,  int? page,  int? totalPages,  bool? hasNextPage,  bool? hasPrevPage, @JsonKey(name: 'removeHTML')  bool? removeHtml,  bool? specialist,  int? numberOfNonSpecialist,  int? numberOfSpecialist,  bool isCached,  int? usulSourcesCount)?  $default,) {final _that = this;
switch (_that) {
case _SearchMetadata() when $default != null:
return $default(_that.length,_that.diagnostics,_that.provenance,_that.pagination,_that.referenceCoverage,_that.selectedScholarIds,_that.currentPageCount,_that.total,_that.page,_that.totalPages,_that.hasNextPage,_that.hasPrevPage,_that.removeHtml,_that.specialist,_that.numberOfNonSpecialist,_that.numberOfSpecialist,_that.isCached,_that.usulSourcesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchMetadata implements SearchMetadata {
  const _SearchMetadata({this.length = 0, this.diagnostics, this.provenance, this.pagination, this.referenceCoverage, this.selectedScholarIds = const [], this.currentPageCount, this.total, this.page, this.totalPages, this.hasNextPage, this.hasPrevPage, @JsonKey(name: 'removeHTML') this.removeHtml, this.specialist, this.numberOfNonSpecialist, this.numberOfSpecialist, this.isCached = false, this.usulSourcesCount});
  factory _SearchMetadata.fromJson(Map<String, dynamic> json) => _$SearchMetadataFromJson(json);

/// Number of results returned
@override@JsonKey() final  int length;
@override final  ParseDiagnostics? diagnostics;
@override final  ResultProvenance? provenance;
@override final  PageMetadata? pagination;
@override final  ReferenceCoverage? referenceCoverage;
@override@JsonKey() final  List<String> selectedScholarIds;
/// Number of results on this page (same as length for consistency with Node.js API)
@override final  int? currentPageCount;
/// Total number of results across all pages (site endpoint only)
@override final  int? total;
/// Current page number
@override final  int? page;
/// Total number of pages (site endpoint only)
@override final  int? totalPages;
/// Whether there is a next page
@override final  bool? hasNextPage;
/// Whether there is a previous page
@override final  bool? hasPrevPage;
/// Whether HTML tags were removed from results
@override@JsonKey(name: 'removeHTML') final  bool? removeHtml;
/// Whether the specialist tab was used (`specialist: true` on Dorar.net).
@override final  bool? specialist;
/// Result count on Dorar's default tab.
@override final  int? numberOfNonSpecialist;
/// Result count on Dorar's specialist tab (hadiths with takhrij; site UI
/// label: "متخصص").
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchMetadata&&(identical(other.length, length) || other.length == length)&&(identical(other.diagnostics, diagnostics) || other.diagnostics == diagnostics)&&(identical(other.provenance, provenance) || other.provenance == provenance)&&(identical(other.pagination, pagination) || other.pagination == pagination)&&(identical(other.referenceCoverage, referenceCoverage) || other.referenceCoverage == referenceCoverage)&&const DeepCollectionEquality().equals(other.selectedScholarIds, selectedScholarIds)&&(identical(other.currentPageCount, currentPageCount) || other.currentPageCount == currentPageCount)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.hasPrevPage, hasPrevPage) || other.hasPrevPage == hasPrevPage)&&(identical(other.removeHtml, removeHtml) || other.removeHtml == removeHtml)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.numberOfNonSpecialist, numberOfNonSpecialist) || other.numberOfNonSpecialist == numberOfNonSpecialist)&&(identical(other.numberOfSpecialist, numberOfSpecialist) || other.numberOfSpecialist == numberOfSpecialist)&&(identical(other.isCached, isCached) || other.isCached == isCached)&&(identical(other.usulSourcesCount, usulSourcesCount) || other.usulSourcesCount == usulSourcesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,length,diagnostics,provenance,pagination,referenceCoverage,const DeepCollectionEquality().hash(selectedScholarIds),currentPageCount,total,page,totalPages,hasNextPage,hasPrevPage,removeHtml,specialist,numberOfNonSpecialist,numberOfSpecialist,isCached,usulSourcesCount);
}

@override
String toString() {
    return 'SearchMetadata(length: $length, diagnostics: $diagnostics, provenance: $provenance, pagination: $pagination, referenceCoverage: $referenceCoverage, selectedScholarIds: $selectedScholarIds, currentPageCount: $currentPageCount, total: $total, page: $page, totalPages: $totalPages, hasNextPage: $hasNextPage, hasPrevPage: $hasPrevPage, removeHtml: $removeHtml, specialist: $specialist, numberOfNonSpecialist: $numberOfNonSpecialist, numberOfSpecialist: $numberOfSpecialist, isCached: $isCached, usulSourcesCount: $usulSourcesCount)';
}


}

/// @nodoc
abstract mixin class _$SearchMetadataCopyWith<$Res> implements $SearchMetadataCopyWith<$Res> {
  factory _$SearchMetadataCopyWith(_SearchMetadata value, $Res Function(_SearchMetadata) _then) = __$SearchMetadataCopyWithImpl;
@override @useResult
$Res call({
 int length, ParseDiagnostics? diagnostics, ResultProvenance? provenance, PageMetadata? pagination, ReferenceCoverage? referenceCoverage, List<String> selectedScholarIds, int? currentPageCount, int? total, int? page, int? totalPages, bool? hasNextPage, bool? hasPrevPage,@JsonKey(name: 'removeHTML') bool? removeHtml, bool? specialist, int? numberOfNonSpecialist, int? numberOfSpecialist, bool isCached, int? usulSourcesCount
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
@override @pragma('vm:prefer-inline') $Res call({Object? length = null,Object? diagnostics = freezed,Object? provenance = freezed,Object? pagination = freezed,Object? referenceCoverage = freezed,Object? selectedScholarIds = null,Object? currentPageCount = freezed,Object? total = freezed,Object? page = freezed,Object? totalPages = freezed,Object? hasNextPage = freezed,Object? hasPrevPage = freezed,Object? removeHtml = freezed,Object? specialist = freezed,Object? numberOfNonSpecialist = freezed,Object? numberOfSpecialist = freezed,Object? isCached = null,Object? usulSourcesCount = freezed,}) {
  return _then(_SearchMetadata(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,diagnostics: freezed == diagnostics ? _self.diagnostics : diagnostics // ignore: cast_nullable_to_non_nullable
as ParseDiagnostics?,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as ResultProvenance?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PageMetadata?,referenceCoverage: freezed == referenceCoverage ? _self.referenceCoverage : referenceCoverage // ignore: cast_nullable_to_non_nullable
as ReferenceCoverage?,selectedScholarIds: null == selectedScholarIds ? _self.selectedScholarIds : selectedScholarIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentPageCount: freezed == currentPageCount ? _self.currentPageCount : currentPageCount // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,hasNextPage: freezed == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool?,hasPrevPage: freezed == hasPrevPage ? _self.hasPrevPage : hasPrevPage // ignore: cast_nullable_to_non_nullable
as bool?,removeHtml: freezed == removeHtml ? _self.removeHtml : removeHtml // ignore: cast_nullable_to_non_nullable
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
