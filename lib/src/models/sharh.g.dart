// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharh.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sharh _$SharhFromJson(Map<String, dynamic> json) => _Sharh(
  hadith: DetailedHadith.fromJson(json['hadith'] as Map<String, dynamic>),
  document: json['document'] == null
      ? null
      : SourcedDocument.fromJson(json['document'] as Map<String, dynamic>),
  embeddedHadith: json['embeddedHadith'] == null
      ? null
      : DetailedHadith.fromJson(json['embeddedHadith'] as Map<String, dynamic>),
  requestedHadithId: json['requestedHadithId'] as String?,
  explanationReference: json['explanationReference'] == null
      ? null
      : ExplanationReference.fromJson(
          json['explanationReference'] as Map<String, dynamic>,
        ),
  provenance: json['provenance'] == null
      ? null
      : ResultProvenance.fromJson(json['provenance'] as Map<String, dynamic>),
  sharhMetadata: json['sharhMetadata'] == null
      ? null
      : SharhMetadata.fromJson(json['sharhMetadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SharhToJson(_Sharh instance) => <String, dynamic>{
  'hadith': instance.hadith.toJson(),
  'document': instance.document?.toJson(),
  'embeddedHadith': instance.embeddedHadith?.toJson(),
  'requestedHadithId': instance.requestedHadithId,
  'explanationReference': instance.explanationReference?.toJson(),
  'provenance': instance.provenance?.toJson(),
  'sharhMetadata': instance.sharhMetadata?.toJson(),
};
