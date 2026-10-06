// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mohdith_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MohdithItem _$MohdithItemFromJson(Map<String, dynamic> json) => _MohdithItem(
  id: json['key'] as String,
  name: json['value'] as String,
  currentSelectable: json['currentSelectable'] as bool? ?? true,
  historicalNames:
      (json['historicalNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$MohdithItemToJson(_MohdithItem instance) =>
    <String, dynamic>{
      'key': instance.id,
      'value': instance.name,
      'currentSelectable': instance.currentSelectable,
      'historicalNames': instance.historicalNames,
    };
