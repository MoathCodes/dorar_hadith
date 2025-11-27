// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usul_hadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsulSource _$UsulSourceFromJson(Map<String, dynamic> json) => _UsulSource(
  source: json['source'] as String,
  chain: json['chain'] as String,
  hadithText: json['hadithText'] as String,
);

Map<String, dynamic> _$UsulSourceToJson(_UsulSource instance) =>
    <String, dynamic>{
      'source': instance.source,
      'chain': instance.chain,
      'hadithText': instance.hadithText,
    };
