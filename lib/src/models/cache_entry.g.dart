// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CacheEntry _$CacheEntryFromJson(Map<String, dynamic> json) => _CacheEntry(
  key: json['key'] as String,
  body: json['body'] as String,
  header: json['header'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$CacheEntryToJson(_CacheEntry instance) =>
    <String, dynamic>{
      'key': instance.key,
      'body': instance.body,
      'header': instance.header,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
