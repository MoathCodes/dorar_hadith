// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookInfo {

/// Name of the book
 String get name;/// Unique identifier
 String get bookId;/// Author of the book
 String get author;/// Reviewer/editor of the book
 String get reviewer;/// Publisher
 String get publisher;/// Edition number
 String get edition;/// Year of the edition
 String get editionYear;
/// Create a copy of BookInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookInfoCopyWith<BookInfo> get copyWith => _$BookInfoCopyWithImpl<BookInfo>(this as BookInfo, _$identity);

  /// Serializes this BookInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.author, author) || other.author == author)&&(identical(other.reviewer, reviewer) || other.reviewer == reviewer)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.edition, edition) || other.edition == edition)&&(identical(other.editionYear, editionYear) || other.editionYear == editionYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,bookId,author,reviewer,publisher,edition,editionYear);

@override
String toString() {
  return 'BookInfo(name: $name, bookId: $bookId, author: $author, reviewer: $reviewer, publisher: $publisher, edition: $edition, editionYear: $editionYear)';
}


}

/// @nodoc
abstract mixin class $BookInfoCopyWith<$Res>  {
  factory $BookInfoCopyWith(BookInfo value, $Res Function(BookInfo) _then) = _$BookInfoCopyWithImpl;
@useResult
$Res call({
 String name, String bookId, String author, String reviewer, String publisher, String edition, String editionYear
});




}
/// @nodoc
class _$BookInfoCopyWithImpl<$Res>
    implements $BookInfoCopyWith<$Res> {
  _$BookInfoCopyWithImpl(this._self, this._then);

  final BookInfo _self;
  final $Res Function(BookInfo) _then;

/// Create a copy of BookInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? bookId = null,Object? author = null,Object? reviewer = null,Object? publisher = null,Object? edition = null,Object? editionYear = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,reviewer: null == reviewer ? _self.reviewer : reviewer // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,edition: null == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as String,editionYear: null == editionYear ? _self.editionYear : editionYear // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookInfo].
extension BookInfoPatterns on BookInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookInfo value)  $default,){
final _that = this;
switch (_that) {
case _BookInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BookInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String bookId,  String author,  String reviewer,  String publisher,  String edition,  String editionYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookInfo() when $default != null:
return $default(_that.name,_that.bookId,_that.author,_that.reviewer,_that.publisher,_that.edition,_that.editionYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String bookId,  String author,  String reviewer,  String publisher,  String edition,  String editionYear)  $default,) {final _that = this;
switch (_that) {
case _BookInfo():
return $default(_that.name,_that.bookId,_that.author,_that.reviewer,_that.publisher,_that.edition,_that.editionYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String bookId,  String author,  String reviewer,  String publisher,  String edition,  String editionYear)?  $default,) {final _that = this;
switch (_that) {
case _BookInfo() when $default != null:
return $default(_that.name,_that.bookId,_that.author,_that.reviewer,_that.publisher,_that.edition,_that.editionYear);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookInfo implements BookInfo {
  const _BookInfo({required this.name, required this.bookId, required this.author, required this.reviewer, required this.publisher, required this.edition, required this.editionYear});
  factory _BookInfo.fromJson(Map<String, dynamic> json) => _$BookInfoFromJson(json);

/// Name of the book
@override final  String name;
/// Unique identifier
@override final  String bookId;
/// Author of the book
@override final  String author;
/// Reviewer/editor of the book
@override final  String reviewer;
/// Publisher
@override final  String publisher;
/// Edition number
@override final  String edition;
/// Year of the edition
@override final  String editionYear;

/// Create a copy of BookInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookInfoCopyWith<_BookInfo> get copyWith => __$BookInfoCopyWithImpl<_BookInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.author, author) || other.author == author)&&(identical(other.reviewer, reviewer) || other.reviewer == reviewer)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.edition, edition) || other.edition == edition)&&(identical(other.editionYear, editionYear) || other.editionYear == editionYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,bookId,author,reviewer,publisher,edition,editionYear);

@override
String toString() {
  return 'BookInfo(name: $name, bookId: $bookId, author: $author, reviewer: $reviewer, publisher: $publisher, edition: $edition, editionYear: $editionYear)';
}


}

/// @nodoc
abstract mixin class _$BookInfoCopyWith<$Res> implements $BookInfoCopyWith<$Res> {
  factory _$BookInfoCopyWith(_BookInfo value, $Res Function(_BookInfo) _then) = __$BookInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String bookId, String author, String reviewer, String publisher, String edition, String editionYear
});




}
/// @nodoc
class __$BookInfoCopyWithImpl<$Res>
    implements _$BookInfoCopyWith<$Res> {
  __$BookInfoCopyWithImpl(this._self, this._then);

  final _BookInfo _self;
  final $Res Function(_BookInfo) _then;

/// Create a copy of BookInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? bookId = null,Object? author = null,Object? reviewer = null,Object? publisher = null,Object? edition = null,Object? editionYear = null,}) {
  return _then(_BookInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,reviewer: null == reviewer ? _self.reviewer : reviewer // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,edition: null == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as String,editionYear: null == editionYear ? _self.editionYear : editionYear // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
