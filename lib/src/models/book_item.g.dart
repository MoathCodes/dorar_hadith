// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookItem _$BookItemFromJson(Map<String, dynamic> json) => _BookItem(
  id: json['key'] as String,
  name: json['value'] as String,
  currentSelectable: json['currentSelectable'] as bool? ?? true,
  historicalNames:
      (json['historicalNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$BookItemToJson(_BookItem instance) => <String, dynamic>{
  'key': instance.id,
  'value': instance.name,
  'currentSelectable': instance.currentSelectable,
  'historicalNames': instance.historicalNames,
};
