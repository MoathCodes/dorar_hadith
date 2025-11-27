// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookInfo _$BookInfoFromJson(Map<String, dynamic> json) => _BookInfo(
  name: json['name'] as String,
  bookId: json['bookId'] as String,
  author: json['author'] as String,
  reviewer: json['reviewer'] as String,
  publisher: json['publisher'] as String,
  edition: json['edition'] as String,
  editionYear: json['editionYear'] as String,
);

Map<String, dynamic> _$BookInfoToJson(_BookInfo instance) => <String, dynamic>{
  'name': instance.name,
  'bookId': instance.bookId,
  'author': instance.author,
  'reviewer': instance.reviewer,
  'publisher': instance.publisher,
  'edition': instance.edition,
  'editionYear': instance.editionYear,
};
