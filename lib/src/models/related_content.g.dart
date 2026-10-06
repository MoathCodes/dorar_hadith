// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedHadithResult _$RelatedHadithResultFromJson(Map<String, dynamic> json) =>
    RelatedHadithResult(
      requestedId: json['requestedId'] as String,
      source: json['source'] == null
          ? null
          : DetailedHadith.fromJson(json['source'] as Map<String, dynamic>),
      kind: $enumDecode(_$RelatedHadithKindEnumMap, json['kind']),
      related: (json['related'] as List<dynamic>)
          .map((e) => DetailedHadith.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RelatedHadithResultToJson(
  RelatedHadithResult instance,
) => <String, dynamic>{
  'requestedId': instance.requestedId,
  'source': instance.source?.toJson(),
  'kind': _$RelatedHadithKindEnumMap[instance.kind]!,
  'related': instance.related.map((e) => e.toJson()).toList(),
};

const _$RelatedHadithKindEnumMap = {
  RelatedHadithKind.alternate: 'alternate',
  RelatedHadithKind.similar: 'similar',
};

AsbabNarration _$AsbabNarrationFromJson(
  Map<String, dynamic> json,
) => AsbabNarration(
  hadith: DetailedHadith.fromJson(json['hadith'] as Map<String, dynamic>),
  document: SourcedDocument.fromJson(json['document'] as Map<String, dynamic>),
  relationship:
      $enumDecodeNullable(_$ContentRelationshipEnumMap, json['relationship']) ??
      ContentRelationship.unknown,
  rawLabel: json['rawLabel'] as String? ?? '',
);

Map<String, dynamic> _$AsbabNarrationToJson(AsbabNarration instance) =>
    <String, dynamic>{
      'hadith': instance.hadith.toJson(),
      'document': instance.document.toJson(),
      'relationship': _$ContentRelationshipEnumMap[instance.relationship]!,
      'rawLabel': instance.rawLabel,
    };

const _$ContentRelationshipEnumMap = {
  ContentRelationship.direct: 'direct',
  ContentRelationship.similar: 'similar',
  ContentRelationship.unknown: 'unknown',
};

AsbabResult _$AsbabResultFromJson(Map<String, dynamic> json) => AsbabResult(
  requestedId: json['requestedId'] as String,
  source: DetailedHadith.fromJson(json['source'] as Map<String, dynamic>),
  narrations: (json['narrations'] as List<dynamic>)
      .map((e) => AsbabNarration.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AsbabResultToJson(AsbabResult instance) =>
    <String, dynamic>{
      'requestedId': instance.requestedId,
      'source': instance.source.toJson(),
      'narrations': instance.narrations.map((e) => e.toJson()).toList(),
    };

SharhSnippet _$SharhSnippetFromJson(Map<String, dynamic> json) => SharhSnippet(
  id: json['id'] as String,
  uri: Uri.parse(json['uri'] as String),
  document: SourcedDocument.fromJson(json['document'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SharhSnippetToJson(SharhSnippet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uri': instance.uri.toString(),
      'document': instance.document.toJson(),
    };
