// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharh.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sharh _$SharhFromJson(Map<String, dynamic> json) => _Sharh(
  hadith: ExplainedHadith.fromJson(json['hadith'] as Map<String, dynamic>),
  sharhMetadata: json['sharhMetadata'] == null
      ? null
      : SharhMetadata.fromJson(json['sharhMetadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SharhToJson(_Sharh instance) => <String, dynamic>{
  'hadith': instance.hadith,
  'sharhMetadata': instance.sharhMetadata,
};
