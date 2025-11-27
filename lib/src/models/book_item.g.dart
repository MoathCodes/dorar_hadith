// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookItem _$BookItemFromJson(Map<String, dynamic> json) => _BookItem(
  id: json['key'] as String,
  name: json['value'] as String,
  author: json['author'] as String?,
  mohdithId: json['mohdithId'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$BookItemToJson(_BookItem instance) => <String, dynamic>{
  'key': instance.id,
  'value': instance.name,
  'author': instance.author,
  'mohdithId': instance.mohdithId,
  'category': instance.category,
};
