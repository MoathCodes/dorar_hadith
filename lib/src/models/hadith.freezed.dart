// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DetailedHadith {

 String get hadith; String get rawi; String get mohdith; String get book; String get numberOrPage; String get grade; String? get mohdithId; String? get bookId; String? get explainGrade; String? get takhrij; String? get hadithId; SourcedDocument? get content; List<SourceMetadataField> get rawMetadata; ExplanationReference? get explanationReference; Availability get usulAvailability; Availability get asbabAvailability; String? get asbabDorar; ResultProvenance? get provenance;/// Thematic categories (التصنيف الموضوعي) for this hadith.
 List<HadithCategory> get categories; bool get hasSimilarHadith; bool get hasAlternateHadithSahih; bool get hasUsulHadith; String? get similarHadithDorar; String? get alternateHadithSahihDorar; String? get usulHadithDorar; bool get hasSharhMetadata; SharhMetadata? get sharhMetadata;
/// Create a copy of DetailedHadith
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailedHadithCopyWith<DetailedHadith> get copyWith => _$DetailedHadithCopyWithImpl<DetailedHadith>(this as DetailedHadith, _$identity);

  /// Serializes this DetailedHadith to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DetailedHadith;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailedHadith&&(identical(other.hadith, _this.hadith) || other.hadith == _this.hadith)&&(identical(other.rawi, _this.rawi) || other.rawi == _this.rawi)&&(identical(other.mohdith, _this.mohdith) || other.mohdith == _this.mohdith)&&(identical(other.book, _this.book) || other.book == _this.book)&&(identical(other.numberOrPage, _this.numberOrPage) || other.numberOrPage == _this.numberOrPage)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.mohdithId, _this.mohdithId) || other.mohdithId == _this.mohdithId)&&(identical(other.bookId, _this.bookId) || other.bookId == _this.bookId)&&(identical(other.explainGrade, _this.explainGrade) || other.explainGrade == _this.explainGrade)&&(identical(other.takhrij, _this.takhrij) || other.takhrij == _this.takhrij)&&(identical(other.hadithId, _this.hadithId) || other.hadithId == _this.hadithId)&&(identical(other.content, _this.content) || other.content == _this.content)&&const DeepCollectionEquality().equals(other.rawMetadata, _this.rawMetadata)&&(identical(other.explanationReference, _this.explanationReference) || other.explanationReference == _this.explanationReference)&&(identical(other.usulAvailability, _this.usulAvailability) || other.usulAvailability == _this.usulAvailability)&&(identical(other.asbabAvailability, _this.asbabAvailability) || other.asbabAvailability == _this.asbabAvailability)&&(identical(other.asbabDorar, _this.asbabDorar) || other.asbabDorar == _this.asbabDorar)&&(identical(other.provenance, _this.provenance) || other.provenance == _this.provenance)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.hasSimilarHadith, _this.hasSimilarHadith) || other.hasSimilarHadith == _this.hasSimilarHadith)&&(identical(other.hasAlternateHadithSahih, _this.hasAlternateHadithSahih) || other.hasAlternateHadithSahih == _this.hasAlternateHadithSahih)&&(identical(other.hasUsulHadith, _this.hasUsulHadith) || other.hasUsulHadith == _this.hasUsulHadith)&&(identical(other.similarHadithDorar, _this.similarHadithDorar) || other.similarHadithDorar == _this.similarHadithDorar)&&(identical(other.alternateHadithSahihDorar, _this.alternateHadithSahihDorar) || other.alternateHadithSahihDorar == _this.alternateHadithSahihDorar)&&(identical(other.usulHadithDorar, _this.usulHadithDorar) || other.usulHadithDorar == _this.usulHadithDorar)&&(identical(other.hasSharhMetadata, _this.hasSharhMetadata) || other.hasSharhMetadata == _this.hasSharhMetadata)&&(identical(other.sharhMetadata, _this.sharhMetadata) || other.sharhMetadata == _this.sharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DetailedHadith;
  return Object.hashAll([runtimeType,_this.hadith,_this.rawi,_this.mohdith,_this.book,_this.numberOrPage,_this.grade,_this.mohdithId,_this.bookId,_this.explainGrade,_this.takhrij,_this.hadithId,_this.content,const DeepCollectionEquality().hash(_this.rawMetadata),_this.explanationReference,_this.usulAvailability,_this.asbabAvailability,_this.asbabDorar,_this.provenance,const DeepCollectionEquality().hash(_this.categories),_this.hasSimilarHadith,_this.hasAlternateHadithSahih,_this.hasUsulHadith,_this.similarHadithDorar,_this.alternateHadithSahihDorar,_this.usulHadithDorar,_this.hasSharhMetadata,_this.sharhMetadata]);
}

@override
String toString() {
  final _this = this as DetailedHadith;
  return 'DetailedHadith(hadith: ${_this.hadith}, rawi: ${_this.rawi}, mohdith: ${_this.mohdith}, book: ${_this.book}, numberOrPage: ${_this.numberOrPage}, grade: ${_this.grade}, mohdithId: ${_this.mohdithId}, bookId: ${_this.bookId}, explainGrade: ${_this.explainGrade}, takhrij: ${_this.takhrij}, hadithId: ${_this.hadithId}, content: ${_this.content}, rawMetadata: ${_this.rawMetadata}, explanationReference: ${_this.explanationReference}, usulAvailability: ${_this.usulAvailability}, asbabAvailability: ${_this.asbabAvailability}, asbabDorar: ${_this.asbabDorar}, provenance: ${_this.provenance}, categories: ${_this.categories}, hasSimilarHadith: ${_this.hasSimilarHadith}, hasAlternateHadithSahih: ${_this.hasAlternateHadithSahih}, hasUsulHadith: ${_this.hasUsulHadith}, similarHadithDorar: ${_this.similarHadithDorar}, alternateHadithSahihDorar: ${_this.alternateHadithSahihDorar}, usulHadithDorar: ${_this.usulHadithDorar}, hasSharhMetadata: ${_this.hasSharhMetadata}, sharhMetadata: ${_this.sharhMetadata})';
}


}

/// @nodoc
abstract mixin class $DetailedHadithCopyWith<$Res>  {
  factory $DetailedHadithCopyWith(DetailedHadith value, $Res Function(DetailedHadith) _then) = _$DetailedHadithCopyWithImpl;
@useResult
$Res call({
 String hadith, String rawi, String mohdith, String book, String numberOrPage, String grade, String? mohdithId, String? bookId, String? explainGrade, String? takhrij, String? hadithId, SourcedDocument? content, List<SourceMetadataField> rawMetadata, ExplanationReference? explanationReference, Availability usulAvailability, Availability asbabAvailability, String? asbabDorar, ResultProvenance? provenance, List<HadithCategory> categories, bool hasSimilarHadith, bool hasAlternateHadithSahih, bool hasUsulHadith, String? similarHadithDorar, String? alternateHadithSahihDorar, String? usulHadithDorar, bool hasSharhMetadata, SharhMetadata? sharhMetadata
});


$SharhMetadataCopyWith<$Res>? get sharhMetadata;

}
/// @nodoc
class _$DetailedHadithCopyWithImpl<$Res>
    implements $DetailedHadithCopyWith<$Res> {
  _$DetailedHadithCopyWithImpl(this._self, this._then);

  final DetailedHadith _self;
  final $Res Function(DetailedHadith) _then;

/// Create a copy of DetailedHadith
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hadith = null,Object? rawi = null,Object? mohdith = null,Object? book = null,Object? numberOrPage = null,Object? grade = null,Object? mohdithId = freezed,Object? bookId = freezed,Object? explainGrade = freezed,Object? takhrij = freezed,Object? hadithId = freezed,Object? content = freezed,Object? rawMetadata = null,Object? explanationReference = freezed,Object? usulAvailability = null,Object? asbabAvailability = null,Object? asbabDorar = freezed,Object? provenance = freezed,Object? categories = null,Object? hasSimilarHadith = null,Object? hasAlternateHadithSahih = null,Object? hasUsulHadith = null,Object? similarHadithDorar = freezed,Object? alternateHadithSahihDorar = freezed,Object? usulHadithDorar = freezed,Object? hasSharhMetadata = null,Object? sharhMetadata = freezed,}) {
  return _then(DetailedHadith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as String,rawi: null == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as String,mohdith: null == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as String,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as String,numberOrPage: null == numberOrPage ? _self.numberOrPage : numberOrPage // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,mohdithId: freezed == mohdithId ? _self.mohdithId : mohdithId // ignore: cast_nullable_to_non_nullable
as String?,bookId: freezed == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String?,explainGrade: freezed == explainGrade ? _self.explainGrade : explainGrade // ignore: cast_nullable_to_non_nullable
as String?,takhrij: freezed == takhrij ? _self.takhrij : takhrij // ignore: cast_nullable_to_non_nullable
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SourcedDocument?,rawMetadata: null == rawMetadata ? _self.rawMetadata : rawMetadata // ignore: cast_nullable_to_non_nullable
as List<SourceMetadataField>,explanationReference: freezed == explanationReference ? _self.explanationReference : explanationReference // ignore: cast_nullable_to_non_nullable
as ExplanationReference?,usulAvailability: null == usulAvailability ? _self.usulAvailability : usulAvailability // ignore: cast_nullable_to_non_nullable
as Availability,asbabAvailability: null == asbabAvailability ? _self.asbabAvailability : asbabAvailability // ignore: cast_nullable_to_non_nullable
as Availability,asbabDorar: freezed == asbabDorar ? _self.asbabDorar : asbabDorar // ignore: cast_nullable_to_non_nullable
as String?,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as ResultProvenance?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<HadithCategory>,hasSimilarHadith: null == hasSimilarHadith ? _self.hasSimilarHadith : hasSimilarHadith // ignore: cast_nullable_to_non_nullable
as bool,hasAlternateHadithSahih: null == hasAlternateHadithSahih ? _self.hasAlternateHadithSahih : hasAlternateHadithSahih // ignore: cast_nullable_to_non_nullable
as bool,hasUsulHadith: null == hasUsulHadith ? _self.hasUsulHadith : hasUsulHadith // ignore: cast_nullable_to_non_nullable
as bool,similarHadithDorar: freezed == similarHadithDorar ? _self.similarHadithDorar : similarHadithDorar // ignore: cast_nullable_to_non_nullable
as String?,alternateHadithSahihDorar: freezed == alternateHadithSahihDorar ? _self.alternateHadithSahihDorar : alternateHadithSahihDorar // ignore: cast_nullable_to_non_nullable
as String?,usulHadithDorar: freezed == usulHadithDorar ? _self.usulHadithDorar : usulHadithDorar // ignore: cast_nullable_to_non_nullable
as String?,hasSharhMetadata: null == hasSharhMetadata ? _self.hasSharhMetadata : hasSharhMetadata // ignore: cast_nullable_to_non_nullable
as bool,sharhMetadata: freezed == sharhMetadata ? _self.sharhMetadata : sharhMetadata // ignore: cast_nullable_to_non_nullable
as SharhMetadata?,
  ));
}
/// Create a copy of DetailedHadith
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


/// Adds pattern-matching-related methods to [DetailedHadith].
extension DetailedHadithPatterns on DetailedHadith {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailedHadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailedHadith() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailedHadith value)  $default,){
final _that = this;
switch (_that) {
case _DetailedHadith():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailedHadith value)?  $default,){
final _that = this;
switch (_that) {
case _DetailedHadith() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade,  String? mohdithId,  String? bookId,  String? explainGrade,  String? takhrij,  String? hadithId,  SourcedDocument? content,  List<SourceMetadataField> rawMetadata,  ExplanationReference? explanationReference,  Availability usulAvailability,  Availability asbabAvailability,  String? asbabDorar,  ResultProvenance? provenance,  List<HadithCategory> categories,  bool hasSimilarHadith,  bool hasAlternateHadithSahih,  bool hasUsulHadith,  String? similarHadithDorar,  String? alternateHadithSahihDorar,  String? usulHadithDorar,  bool hasSharhMetadata,  SharhMetadata? sharhMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailedHadith() when $default != null:
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade,_that.mohdithId,_that.bookId,_that.explainGrade,_that.takhrij,_that.hadithId,_that.content,_that.rawMetadata,_that.explanationReference,_that.usulAvailability,_that.asbabAvailability,_that.asbabDorar,_that.provenance,_that.categories,_that.hasSimilarHadith,_that.hasAlternateHadithSahih,_that.hasUsulHadith,_that.similarHadithDorar,_that.alternateHadithSahihDorar,_that.usulHadithDorar,_that.hasSharhMetadata,_that.sharhMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade,  String? mohdithId,  String? bookId,  String? explainGrade,  String? takhrij,  String? hadithId,  SourcedDocument? content,  List<SourceMetadataField> rawMetadata,  ExplanationReference? explanationReference,  Availability usulAvailability,  Availability asbabAvailability,  String? asbabDorar,  ResultProvenance? provenance,  List<HadithCategory> categories,  bool hasSimilarHadith,  bool hasAlternateHadithSahih,  bool hasUsulHadith,  String? similarHadithDorar,  String? alternateHadithSahihDorar,  String? usulHadithDorar,  bool hasSharhMetadata,  SharhMetadata? sharhMetadata)  $default,) {final _that = this;
switch (_that) {
case _DetailedHadith():
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade,_that.mohdithId,_that.bookId,_that.explainGrade,_that.takhrij,_that.hadithId,_that.content,_that.rawMetadata,_that.explanationReference,_that.usulAvailability,_that.asbabAvailability,_that.asbabDorar,_that.provenance,_that.categories,_that.hasSimilarHadith,_that.hasAlternateHadithSahih,_that.hasUsulHadith,_that.similarHadithDorar,_that.alternateHadithSahihDorar,_that.usulHadithDorar,_that.hasSharhMetadata,_that.sharhMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade,  String? mohdithId,  String? bookId,  String? explainGrade,  String? takhrij,  String? hadithId,  SourcedDocument? content,  List<SourceMetadataField> rawMetadata,  ExplanationReference? explanationReference,  Availability usulAvailability,  Availability asbabAvailability,  String? asbabDorar,  ResultProvenance? provenance,  List<HadithCategory> categories,  bool hasSimilarHadith,  bool hasAlternateHadithSahih,  bool hasUsulHadith,  String? similarHadithDorar,  String? alternateHadithSahihDorar,  String? usulHadithDorar,  bool hasSharhMetadata,  SharhMetadata? sharhMetadata)?  $default,) {final _that = this;
switch (_that) {
case _DetailedHadith() when $default != null:
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade,_that.mohdithId,_that.bookId,_that.explainGrade,_that.takhrij,_that.hadithId,_that.content,_that.rawMetadata,_that.explanationReference,_that.usulAvailability,_that.asbabAvailability,_that.asbabDorar,_that.provenance,_that.categories,_that.hasSimilarHadith,_that.hasAlternateHadithSahih,_that.hasUsulHadith,_that.similarHadithDorar,_that.alternateHadithSahihDorar,_that.usulHadithDorar,_that.hasSharhMetadata,_that.sharhMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DetailedHadith extends DetailedHadith {
  const _DetailedHadith({required this.hadith, required this.rawi, required this.mohdith, required this.book, required this.numberOrPage, required this.grade, this.mohdithId, this.bookId, this.explainGrade, this.takhrij, this.hadithId, this.content, this.rawMetadata = const [], this.explanationReference, this.usulAvailability = Availability.unknown, this.asbabAvailability = Availability.unknown, this.asbabDorar, this.provenance, this.categories = const [], this.hasSimilarHadith = false, this.hasAlternateHadithSahih = false, this.hasUsulHadith = false, this.similarHadithDorar, this.alternateHadithSahihDorar, this.usulHadithDorar, this.hasSharhMetadata = false, this.sharhMetadata}): super._();
  factory _DetailedHadith.fromJson(Map<String, dynamic> json) => _$DetailedHadithFromJson(json);

@override final  String hadith;
@override final  String rawi;
@override final  String mohdith;
@override final  String book;
@override final  String numberOrPage;
@override final  String grade;
@override final  String? mohdithId;
@override final  String? bookId;
@override final  String? explainGrade;
@override final  String? takhrij;
@override final  String? hadithId;
@override final  SourcedDocument? content;
@override@JsonKey() final  List<SourceMetadataField> rawMetadata;
@override final  ExplanationReference? explanationReference;
@override@JsonKey() final  Availability usulAvailability;
@override@JsonKey() final  Availability asbabAvailability;
@override final  String? asbabDorar;
@override final  ResultProvenance? provenance;
/// Thematic categories (التصنيف الموضوعي) for this hadith.
@override@JsonKey() final  List<HadithCategory> categories;
@override@JsonKey() final  bool hasSimilarHadith;
@override@JsonKey() final  bool hasAlternateHadithSahih;
@override@JsonKey() final  bool hasUsulHadith;
@override final  String? similarHadithDorar;
@override final  String? alternateHadithSahihDorar;
@override final  String? usulHadithDorar;
@override@JsonKey() final  bool hasSharhMetadata;
@override final  SharhMetadata? sharhMetadata;

/// Create a copy of DetailedHadith
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailedHadithCopyWith<_DetailedHadith> get copyWith => __$DetailedHadithCopyWithImpl<_DetailedHadith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DetailedHadithToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailedHadith&&(identical(other.hadith, hadith) || other.hadith == hadith)&&(identical(other.rawi, rawi) || other.rawi == rawi)&&(identical(other.mohdith, mohdith) || other.mohdith == mohdith)&&(identical(other.book, book) || other.book == book)&&(identical(other.numberOrPage, numberOrPage) || other.numberOrPage == numberOrPage)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.mohdithId, mohdithId) || other.mohdithId == mohdithId)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.explainGrade, explainGrade) || other.explainGrade == explainGrade)&&(identical(other.takhrij, takhrij) || other.takhrij == takhrij)&&(identical(other.hadithId, hadithId) || other.hadithId == hadithId)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.rawMetadata, rawMetadata)&&(identical(other.explanationReference, explanationReference) || other.explanationReference == explanationReference)&&(identical(other.usulAvailability, usulAvailability) || other.usulAvailability == usulAvailability)&&(identical(other.asbabAvailability, asbabAvailability) || other.asbabAvailability == asbabAvailability)&&(identical(other.asbabDorar, asbabDorar) || other.asbabDorar == asbabDorar)&&(identical(other.provenance, provenance) || other.provenance == provenance)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.hasSimilarHadith, hasSimilarHadith) || other.hasSimilarHadith == hasSimilarHadith)&&(identical(other.hasAlternateHadithSahih, hasAlternateHadithSahih) || other.hasAlternateHadithSahih == hasAlternateHadithSahih)&&(identical(other.hasUsulHadith, hasUsulHadith) || other.hasUsulHadith == hasUsulHadith)&&(identical(other.similarHadithDorar, similarHadithDorar) || other.similarHadithDorar == similarHadithDorar)&&(identical(other.alternateHadithSahihDorar, alternateHadithSahihDorar) || other.alternateHadithSahihDorar == alternateHadithSahihDorar)&&(identical(other.usulHadithDorar, usulHadithDorar) || other.usulHadithDorar == usulHadithDorar)&&(identical(other.hasSharhMetadata, hasSharhMetadata) || other.hasSharhMetadata == hasSharhMetadata)&&(identical(other.sharhMetadata, sharhMetadata) || other.sharhMetadata == sharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,hadith,rawi,mohdith,book,numberOrPage,grade,mohdithId,bookId,explainGrade,takhrij,hadithId,content,const DeepCollectionEquality().hash(rawMetadata),explanationReference,usulAvailability,asbabAvailability,asbabDorar,provenance,const DeepCollectionEquality().hash(categories),hasSimilarHadith,hasAlternateHadithSahih,hasUsulHadith,similarHadithDorar,alternateHadithSahihDorar,usulHadithDorar,hasSharhMetadata,sharhMetadata]);
}

@override
String toString() {
    return 'DetailedHadith(hadith: $hadith, rawi: $rawi, mohdith: $mohdith, book: $book, numberOrPage: $numberOrPage, grade: $grade, mohdithId: $mohdithId, bookId: $bookId, explainGrade: $explainGrade, takhrij: $takhrij, hadithId: $hadithId, content: $content, rawMetadata: $rawMetadata, explanationReference: $explanationReference, usulAvailability: $usulAvailability, asbabAvailability: $asbabAvailability, asbabDorar: $asbabDorar, provenance: $provenance, categories: $categories, hasSimilarHadith: $hasSimilarHadith, hasAlternateHadithSahih: $hasAlternateHadithSahih, hasUsulHadith: $hasUsulHadith, similarHadithDorar: $similarHadithDorar, alternateHadithSahihDorar: $alternateHadithSahihDorar, usulHadithDorar: $usulHadithDorar, hasSharhMetadata: $hasSharhMetadata, sharhMetadata: $sharhMetadata)';
}


}

/// @nodoc
abstract mixin class _$DetailedHadithCopyWith<$Res> implements $DetailedHadithCopyWith<$Res> {
  factory _$DetailedHadithCopyWith(_DetailedHadith value, $Res Function(_DetailedHadith) _then) = __$DetailedHadithCopyWithImpl;
@override @useResult
$Res call({
 String hadith, String rawi, String mohdith, String book, String numberOrPage, String grade, String? mohdithId, String? bookId, String? explainGrade, String? takhrij, String? hadithId, SourcedDocument? content, List<SourceMetadataField> rawMetadata, ExplanationReference? explanationReference, Availability usulAvailability, Availability asbabAvailability, String? asbabDorar, ResultProvenance? provenance, List<HadithCategory> categories, bool hasSimilarHadith, bool hasAlternateHadithSahih, bool hasUsulHadith, String? similarHadithDorar, String? alternateHadithSahihDorar, String? usulHadithDorar, bool hasSharhMetadata, SharhMetadata? sharhMetadata
});


@override $SharhMetadataCopyWith<$Res>? get sharhMetadata;

}
/// @nodoc
class __$DetailedHadithCopyWithImpl<$Res>
    implements _$DetailedHadithCopyWith<$Res> {
  __$DetailedHadithCopyWithImpl(this._self, this._then);

  final _DetailedHadith _self;
  final $Res Function(_DetailedHadith) _then;

/// Create a copy of DetailedHadith
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hadith = null,Object? rawi = null,Object? mohdith = null,Object? book = null,Object? numberOrPage = null,Object? grade = null,Object? mohdithId = freezed,Object? bookId = freezed,Object? explainGrade = freezed,Object? takhrij = freezed,Object? hadithId = freezed,Object? content = freezed,Object? rawMetadata = null,Object? explanationReference = freezed,Object? usulAvailability = null,Object? asbabAvailability = null,Object? asbabDorar = freezed,Object? provenance = freezed,Object? categories = null,Object? hasSimilarHadith = null,Object? hasAlternateHadithSahih = null,Object? hasUsulHadith = null,Object? similarHadithDorar = freezed,Object? alternateHadithSahihDorar = freezed,Object? usulHadithDorar = freezed,Object? hasSharhMetadata = null,Object? sharhMetadata = freezed,}) {
  return _then(_DetailedHadith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as String,rawi: null == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as String,mohdith: null == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as String,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as String,numberOrPage: null == numberOrPage ? _self.numberOrPage : numberOrPage // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,mohdithId: freezed == mohdithId ? _self.mohdithId : mohdithId // ignore: cast_nullable_to_non_nullable
as String?,bookId: freezed == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String?,explainGrade: freezed == explainGrade ? _self.explainGrade : explainGrade // ignore: cast_nullable_to_non_nullable
as String?,takhrij: freezed == takhrij ? _self.takhrij : takhrij // ignore: cast_nullable_to_non_nullable
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SourcedDocument?,rawMetadata: null == rawMetadata ? _self.rawMetadata : rawMetadata // ignore: cast_nullable_to_non_nullable
as List<SourceMetadataField>,explanationReference: freezed == explanationReference ? _self.explanationReference : explanationReference // ignore: cast_nullable_to_non_nullable
as ExplanationReference?,usulAvailability: null == usulAvailability ? _self.usulAvailability : usulAvailability // ignore: cast_nullable_to_non_nullable
as Availability,asbabAvailability: null == asbabAvailability ? _self.asbabAvailability : asbabAvailability // ignore: cast_nullable_to_non_nullable
as Availability,asbabDorar: freezed == asbabDorar ? _self.asbabDorar : asbabDorar // ignore: cast_nullable_to_non_nullable
as String?,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as ResultProvenance?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<HadithCategory>,hasSimilarHadith: null == hasSimilarHadith ? _self.hasSimilarHadith : hasSimilarHadith // ignore: cast_nullable_to_non_nullable
as bool,hasAlternateHadithSahih: null == hasAlternateHadithSahih ? _self.hasAlternateHadithSahih : hasAlternateHadithSahih // ignore: cast_nullable_to_non_nullable
as bool,hasUsulHadith: null == hasUsulHadith ? _self.hasUsulHadith : hasUsulHadith // ignore: cast_nullable_to_non_nullable
as bool,similarHadithDorar: freezed == similarHadithDorar ? _self.similarHadithDorar : similarHadithDorar // ignore: cast_nullable_to_non_nullable
as String?,alternateHadithSahihDorar: freezed == alternateHadithSahihDorar ? _self.alternateHadithSahihDorar : alternateHadithSahihDorar // ignore: cast_nullable_to_non_nullable
as String?,usulHadithDorar: freezed == usulHadithDorar ? _self.usulHadithDorar : usulHadithDorar // ignore: cast_nullable_to_non_nullable
as String?,hasSharhMetadata: null == hasSharhMetadata ? _self.hasSharhMetadata : hasSharhMetadata // ignore: cast_nullable_to_non_nullable
as bool,sharhMetadata: freezed == sharhMetadata ? _self.sharhMetadata : sharhMetadata // ignore: cast_nullable_to_non_nullable
as SharhMetadata?,
  ));
}

/// Create a copy of DetailedHadith
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


/// @nodoc
mixin _$ExplainedHadith {

 String get hadith; String get rawi; String get mohdith; String get book; String get numberOrPage; String get grade; String? get takhrij; bool get hasSharhMetadata;
/// Create a copy of ExplainedHadith
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExplainedHadithCopyWith<ExplainedHadith> get copyWith => _$ExplainedHadithCopyWithImpl<ExplainedHadith>(this as ExplainedHadith, _$identity);

  /// Serializes this ExplainedHadith to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExplainedHadith;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExplainedHadith&&(identical(other.hadith, _this.hadith) || other.hadith == _this.hadith)&&(identical(other.rawi, _this.rawi) || other.rawi == _this.rawi)&&(identical(other.mohdith, _this.mohdith) || other.mohdith == _this.mohdith)&&(identical(other.book, _this.book) || other.book == _this.book)&&(identical(other.numberOrPage, _this.numberOrPage) || other.numberOrPage == _this.numberOrPage)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.takhrij, _this.takhrij) || other.takhrij == _this.takhrij)&&(identical(other.hasSharhMetadata, _this.hasSharhMetadata) || other.hasSharhMetadata == _this.hasSharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExplainedHadith;
  return Object.hash(runtimeType,_this.hadith,_this.rawi,_this.mohdith,_this.book,_this.numberOrPage,_this.grade,_this.takhrij,_this.hasSharhMetadata);
}

@override
String toString() {
  final _this = this as ExplainedHadith;
  return 'ExplainedHadith(hadith: ${_this.hadith}, rawi: ${_this.rawi}, mohdith: ${_this.mohdith}, book: ${_this.book}, numberOrPage: ${_this.numberOrPage}, grade: ${_this.grade}, takhrij: ${_this.takhrij}, hasSharhMetadata: ${_this.hasSharhMetadata})';
}


}

/// @nodoc
abstract mixin class $ExplainedHadithCopyWith<$Res>  {
  factory $ExplainedHadithCopyWith(ExplainedHadith value, $Res Function(ExplainedHadith) _then) = _$ExplainedHadithCopyWithImpl;
@useResult
$Res call({
 String hadith, String rawi, String mohdith, String book, String numberOrPage, String grade, String? takhrij, bool hasSharhMetadata
});




}
/// @nodoc
class _$ExplainedHadithCopyWithImpl<$Res>
    implements $ExplainedHadithCopyWith<$Res> {
  _$ExplainedHadithCopyWithImpl(this._self, this._then);

  final ExplainedHadith _self;
  final $Res Function(ExplainedHadith) _then;

/// Create a copy of ExplainedHadith
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hadith = null,Object? rawi = null,Object? mohdith = null,Object? book = null,Object? numberOrPage = null,Object? grade = null,Object? takhrij = freezed,Object? hasSharhMetadata = null,}) {
  return _then(ExplainedHadith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as String,rawi: null == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as String,mohdith: null == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as String,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as String,numberOrPage: null == numberOrPage ? _self.numberOrPage : numberOrPage // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,takhrij: freezed == takhrij ? _self.takhrij : takhrij // ignore: cast_nullable_to_non_nullable
as String?,hasSharhMetadata: null == hasSharhMetadata ? _self.hasSharhMetadata : hasSharhMetadata // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExplainedHadith].
extension ExplainedHadithPatterns on ExplainedHadith {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExplainedHadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExplainedHadith() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExplainedHadith value)  $default,){
final _that = this;
switch (_that) {
case _ExplainedHadith():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExplainedHadith value)?  $default,){
final _that = this;
switch (_that) {
case _ExplainedHadith() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade,  String? takhrij,  bool hasSharhMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExplainedHadith() when $default != null:
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade,_that.takhrij,_that.hasSharhMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade,  String? takhrij,  bool hasSharhMetadata)  $default,) {final _that = this;
switch (_that) {
case _ExplainedHadith():
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade,_that.takhrij,_that.hasSharhMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade,  String? takhrij,  bool hasSharhMetadata)?  $default,) {final _that = this;
switch (_that) {
case _ExplainedHadith() when $default != null:
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade,_that.takhrij,_that.hasSharhMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExplainedHadith extends ExplainedHadith {
  const _ExplainedHadith({required this.hadith, required this.rawi, required this.mohdith, required this.book, required this.numberOrPage, required this.grade, this.takhrij, this.hasSharhMetadata = false}): super._();
  factory _ExplainedHadith.fromJson(Map<String, dynamic> json) => _$ExplainedHadithFromJson(json);

@override final  String hadith;
@override final  String rawi;
@override final  String mohdith;
@override final  String book;
@override final  String numberOrPage;
@override final  String grade;
@override final  String? takhrij;
@override@JsonKey() final  bool hasSharhMetadata;

/// Create a copy of ExplainedHadith
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExplainedHadithCopyWith<_ExplainedHadith> get copyWith => __$ExplainedHadithCopyWithImpl<_ExplainedHadith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExplainedHadithToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExplainedHadith&&(identical(other.hadith, hadith) || other.hadith == hadith)&&(identical(other.rawi, rawi) || other.rawi == rawi)&&(identical(other.mohdith, mohdith) || other.mohdith == mohdith)&&(identical(other.book, book) || other.book == book)&&(identical(other.numberOrPage, numberOrPage) || other.numberOrPage == numberOrPage)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.takhrij, takhrij) || other.takhrij == takhrij)&&(identical(other.hasSharhMetadata, hasSharhMetadata) || other.hasSharhMetadata == hasSharhMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hadith,rawi,mohdith,book,numberOrPage,grade,takhrij,hasSharhMetadata);
}

@override
String toString() {
    return 'ExplainedHadith(hadith: $hadith, rawi: $rawi, mohdith: $mohdith, book: $book, numberOrPage: $numberOrPage, grade: $grade, takhrij: $takhrij, hasSharhMetadata: $hasSharhMetadata)';
}


}

/// @nodoc
abstract mixin class _$ExplainedHadithCopyWith<$Res> implements $ExplainedHadithCopyWith<$Res> {
  factory _$ExplainedHadithCopyWith(_ExplainedHadith value, $Res Function(_ExplainedHadith) _then) = __$ExplainedHadithCopyWithImpl;
@override @useResult
$Res call({
 String hadith, String rawi, String mohdith, String book, String numberOrPage, String grade, String? takhrij, bool hasSharhMetadata
});




}
/// @nodoc
class __$ExplainedHadithCopyWithImpl<$Res>
    implements _$ExplainedHadithCopyWith<$Res> {
  __$ExplainedHadithCopyWithImpl(this._self, this._then);

  final _ExplainedHadith _self;
  final $Res Function(_ExplainedHadith) _then;

/// Create a copy of ExplainedHadith
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hadith = null,Object? rawi = null,Object? mohdith = null,Object? book = null,Object? numberOrPage = null,Object? grade = null,Object? takhrij = freezed,Object? hasSharhMetadata = null,}) {
  return _then(_ExplainedHadith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as String,rawi: null == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as String,mohdith: null == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as String,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as String,numberOrPage: null == numberOrPage ? _self.numberOrPage : numberOrPage // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,takhrij: freezed == takhrij ? _self.takhrij : takhrij // ignore: cast_nullable_to_non_nullable
as String?,hasSharhMetadata: null == hasSharhMetadata ? _self.hasSharhMetadata : hasSharhMetadata // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Hadith {

 String get hadith; String get rawi; String get mohdith; String get book; String get numberOrPage; String get grade;
/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadithCopyWith<Hadith> get copyWith => _$HadithCopyWithImpl<Hadith>(this as Hadith, _$identity);

  /// Serializes this Hadith to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Hadith;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hadith&&(identical(other.hadith, _this.hadith) || other.hadith == _this.hadith)&&(identical(other.rawi, _this.rawi) || other.rawi == _this.rawi)&&(identical(other.mohdith, _this.mohdith) || other.mohdith == _this.mohdith)&&(identical(other.book, _this.book) || other.book == _this.book)&&(identical(other.numberOrPage, _this.numberOrPage) || other.numberOrPage == _this.numberOrPage)&&(identical(other.grade, _this.grade) || other.grade == _this.grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Hadith;
  return Object.hash(runtimeType,_this.hadith,_this.rawi,_this.mohdith,_this.book,_this.numberOrPage,_this.grade);
}

@override
String toString() {
  final _this = this as Hadith;
  return 'Hadith(hadith: ${_this.hadith}, rawi: ${_this.rawi}, mohdith: ${_this.mohdith}, book: ${_this.book}, numberOrPage: ${_this.numberOrPage}, grade: ${_this.grade})';
}


}

/// @nodoc
abstract mixin class $HadithCopyWith<$Res>  {
  factory $HadithCopyWith(Hadith value, $Res Function(Hadith) _then) = _$HadithCopyWithImpl;
@useResult
$Res call({
 String hadith, String rawi, String mohdith, String book, String numberOrPage, String grade
});




}
/// @nodoc
class _$HadithCopyWithImpl<$Res>
    implements $HadithCopyWith<$Res> {
  _$HadithCopyWithImpl(this._self, this._then);

  final Hadith _self;
  final $Res Function(Hadith) _then;

/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hadith = null,Object? rawi = null,Object? mohdith = null,Object? book = null,Object? numberOrPage = null,Object? grade = null,}) {
  return _then(Hadith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as String,rawi: null == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as String,mohdith: null == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as String,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as String,numberOrPage: null == numberOrPage ? _self.numberOrPage : numberOrPage // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Hadith].
extension HadithPatterns on Hadith {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hadith() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hadith value)  $default,){
final _that = this;
switch (_that) {
case _Hadith():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hadith value)?  $default,){
final _that = this;
switch (_that) {
case _Hadith() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade)  $default,) {final _that = this;
switch (_that) {
case _Hadith():
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hadith,  String rawi,  String mohdith,  String book,  String numberOrPage,  String grade)?  $default,) {final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that.hadith,_that.rawi,_that.mohdith,_that.book,_that.numberOrPage,_that.grade);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hadith extends Hadith {
  const _Hadith({required this.hadith, required this.rawi, required this.mohdith, required this.book, required this.numberOrPage, required this.grade}): super._();
  factory _Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);

@override final  String hadith;
@override final  String rawi;
@override final  String mohdith;
@override final  String book;
@override final  String numberOrPage;
@override final  String grade;

/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadithCopyWith<_Hadith> get copyWith => __$HadithCopyWithImpl<_Hadith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HadithToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hadith&&(identical(other.hadith, hadith) || other.hadith == hadith)&&(identical(other.rawi, rawi) || other.rawi == rawi)&&(identical(other.mohdith, mohdith) || other.mohdith == mohdith)&&(identical(other.book, book) || other.book == book)&&(identical(other.numberOrPage, numberOrPage) || other.numberOrPage == numberOrPage)&&(identical(other.grade, grade) || other.grade == grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hadith,rawi,mohdith,book,numberOrPage,grade);
}

@override
String toString() {
    return 'Hadith(hadith: $hadith, rawi: $rawi, mohdith: $mohdith, book: $book, numberOrPage: $numberOrPage, grade: $grade)';
}


}

/// @nodoc
abstract mixin class _$HadithCopyWith<$Res> implements $HadithCopyWith<$Res> {
  factory _$HadithCopyWith(_Hadith value, $Res Function(_Hadith) _then) = __$HadithCopyWithImpl;
@override @useResult
$Res call({
 String hadith, String rawi, String mohdith, String book, String numberOrPage, String grade
});




}
/// @nodoc
class __$HadithCopyWithImpl<$Res>
    implements _$HadithCopyWith<$Res> {
  __$HadithCopyWithImpl(this._self, this._then);

  final _Hadith _self;
  final $Res Function(_Hadith) _then;

/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hadith = null,Object? rawi = null,Object? mohdith = null,Object? book = null,Object? numberOrPage = null,Object? grade = null,}) {
  return _then(_Hadith(
hadith: null == hadith ? _self.hadith : hadith // ignore: cast_nullable_to_non_nullable
as String,rawi: null == rawi ? _self.rawi : rawi // ignore: cast_nullable_to_non_nullable
as String,mohdith: null == mohdith ? _self.mohdith : mohdith // ignore: cast_nullable_to_non_nullable
as String,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as String,numberOrPage: null == numberOrPage ? _self.numberOrPage : numberOrPage // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
