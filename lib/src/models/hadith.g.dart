// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DetailedHadith _$DetailedHadithFromJson(
  Map<String, dynamic> json,
) => _DetailedHadith(
  hadith: json['hadith'] as String,
  rawi: json['rawi'] as String,
  mohdith: json['mohdith'] as String,
  book: json['book'] as String,
  numberOrPage: json['numberOrPage'] as String,
  grade: json['grade'] as String,
  mohdithId: json['mohdithId'] as String?,
  bookId: json['bookId'] as String?,
  explainGrade: json['explainGrade'] as String?,
  takhrij: json['takhrij'] as String?,
  hadithId: json['hadithId'] as String?,
  content: json['content'] == null
      ? null
      : SourcedDocument.fromJson(json['content'] as Map<String, dynamic>),
  rawMetadata:
      (json['rawMetadata'] as List<dynamic>?)
          ?.map((e) => SourceMetadataField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  explanationReference: json['explanationReference'] == null
      ? null
      : ExplanationReference.fromJson(
          json['explanationReference'] as Map<String, dynamic>,
        ),
  usulAvailability:
      $enumDecodeNullable(_$AvailabilityEnumMap, json['usulAvailability']) ??
      Availability.unknown,
  asbabAvailability:
      $enumDecodeNullable(_$AvailabilityEnumMap, json['asbabAvailability']) ??
      Availability.unknown,
  asbabDorar: json['asbabDorar'] as String?,
  provenance: json['provenance'] == null
      ? null
      : ResultProvenance.fromJson(json['provenance'] as Map<String, dynamic>),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  hasSimilarHadith: json['hasSimilarHadith'] as bool? ?? false,
  hasAlternateHadithSahih: json['hasAlternateHadithSahih'] as bool? ?? false,
  hasUsulHadith: json['hasUsulHadith'] as bool? ?? false,
  similarHadithDorar: json['similarHadithDorar'] as String?,
  alternateHadithSahihDorar: json['alternateHadithSahihDorar'] as String?,
  usulHadithDorar: json['usulHadithDorar'] as String?,
  hasSharhMetadata: json['hasSharhMetadata'] as bool? ?? false,
  sharhMetadata: json['sharhMetadata'] == null
      ? null
      : SharhMetadata.fromJson(json['sharhMetadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DetailedHadithToJson(_DetailedHadith instance) =>
    <String, dynamic>{
      'hadith': instance.hadith,
      'rawi': instance.rawi,
      'mohdith': instance.mohdith,
      'book': instance.book,
      'numberOrPage': instance.numberOrPage,
      'grade': instance.grade,
      'mohdithId': instance.mohdithId,
      'bookId': instance.bookId,
      'explainGrade': instance.explainGrade,
      'takhrij': instance.takhrij,
      'hadithId': instance.hadithId,
      'content': instance.content?.toJson(),
      'rawMetadata': instance.rawMetadata.map((e) => e.toJson()).toList(),
      'explanationReference': instance.explanationReference?.toJson(),
      'usulAvailability': _$AvailabilityEnumMap[instance.usulAvailability]!,
      'asbabAvailability': _$AvailabilityEnumMap[instance.asbabAvailability]!,
      'asbabDorar': instance.asbabDorar,
      'provenance': instance.provenance?.toJson(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'hasSimilarHadith': instance.hasSimilarHadith,
      'hasAlternateHadithSahih': instance.hasAlternateHadithSahih,
      'hasUsulHadith': instance.hasUsulHadith,
      'similarHadithDorar': instance.similarHadithDorar,
      'alternateHadithSahihDorar': instance.alternateHadithSahihDorar,
      'usulHadithDorar': instance.usulHadithDorar,
      'hasSharhMetadata': instance.hasSharhMetadata,
      'sharhMetadata': instance.sharhMetadata?.toJson(),
    };

const _$AvailabilityEnumMap = {
  Availability.advertised: 'advertised',
  Availability.notAdvertised: 'notAdvertised',
  Availability.unknown: 'unknown',
};

_ExplainedHadith _$ExplainedHadithFromJson(Map<String, dynamic> json) =>
    _ExplainedHadith(
      hadith: json['hadith'] as String,
      rawi: json['rawi'] as String,
      mohdith: json['mohdith'] as String,
      book: json['book'] as String,
      numberOrPage: json['numberOrPage'] as String,
      grade: json['grade'] as String,
      takhrij: json['takhrij'] as String?,
      hasSharhMetadata: json['hasSharhMetadata'] as bool? ?? false,
    );

Map<String, dynamic> _$ExplainedHadithToJson(_ExplainedHadith instance) =>
    <String, dynamic>{
      'hadith': instance.hadith,
      'rawi': instance.rawi,
      'mohdith': instance.mohdith,
      'book': instance.book,
      'numberOrPage': instance.numberOrPage,
      'grade': instance.grade,
      'takhrij': instance.takhrij,
      'hasSharhMetadata': instance.hasSharhMetadata,
    };

_Hadith _$HadithFromJson(Map<String, dynamic> json) => _Hadith(
  hadith: json['hadith'] as String,
  rawi: json['rawi'] as String,
  mohdith: json['mohdith'] as String,
  book: json['book'] as String,
  numberOrPage: json['numberOrPage'] as String,
  grade: json['grade'] as String,
);

Map<String, dynamic> _$HadithToJson(_Hadith instance) => <String, dynamic>{
  'hadith': instance.hadith,
  'rawi': instance.rawi,
  'mohdith': instance.mohdith,
  'book': instance.book,
  'numberOrPage': instance.numberOrPage,
  'grade': instance.grade,
};
