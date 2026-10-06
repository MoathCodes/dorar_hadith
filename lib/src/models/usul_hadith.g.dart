// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usul_hadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsulSource _$UsulSourceFromJson(Map<String, dynamic> json) => _UsulSource(
  source: json['source'] as String,
  chain: json['chain'] as String,
  hadithText: json['hadithText'] as String,
  citation: json['citation'] == null
      ? null
      : Citation.fromJson(json['citation'] as Map<String, dynamic>),
  chainContent: json['chainContent'] == null
      ? null
      : SourcedDocument.fromJson(json['chainContent'] as Map<String, dynamic>),
  narrationContent: json['narrationContent'] == null
      ? null
      : SourcedDocument.fromJson(
          json['narrationContent'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UsulSourceToJson(_UsulSource instance) =>
    <String, dynamic>{
      'source': instance.source,
      'chain': instance.chain,
      'hadithText': instance.hadithText,
      'citation': instance.citation?.toJson(),
      'chainContent': instance.chainContent?.toJson(),
      'narrationContent': instance.narrationContent?.toJson(),
    };
