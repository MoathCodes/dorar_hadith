// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParseWarning _$ParseWarningFromJson(Map<String, dynamic> json) => ParseWarning(
  stage: json['stage'] as String,
  message: json['message'] as String,
  recordId: json['recordId'] as String?,
  index: (json['index'] as num?)?.toInt(),
);

Map<String, dynamic> _$ParseWarningToJson(ParseWarning instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'message': instance.message,
      'recordId': instance.recordId,
      'index': instance.index,
    };

ParseDiagnostics _$ParseDiagnosticsFromJson(Map<String, dynamic> json) =>
    ParseDiagnostics(
      completeness:
          $enumDecodeNullable(
            _$ParseCompletenessEnumMap,
            json['completeness'],
          ) ??
          ParseCompleteness.complete,
      candidateCount: (json['candidateCount'] as num?)?.toInt() ?? 0,
      parsedCount: (json['parsedCount'] as num?)?.toInt() ?? 0,
      warnings:
          (json['warnings'] as List<dynamic>?)
              ?.map((e) => ParseWarning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ParseDiagnosticsToJson(ParseDiagnostics instance) =>
    <String, dynamic>{
      'completeness': _$ParseCompletenessEnumMap[instance.completeness]!,
      'candidateCount': instance.candidateCount,
      'parsedCount': instance.parsedCount,
      'warnings': instance.warnings.map((e) => e.toJson()).toList(),
    };

const _$ParseCompletenessEnumMap = {
  ParseCompleteness.complete: 'complete',
  ParseCompleteness.partial: 'partial',
  ParseCompleteness.unknown: 'unknown',
};

ResultProvenance _$ResultProvenanceFromJson(Map<String, dynamic> json) =>
    ResultProvenance(
      sourceUri: Uri.parse(json['sourceUri'] as String),
      endpoint: json['endpoint'] as String,
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      parserVersion: (json['parserVersion'] as num?)?.toInt() ?? 1,
      isCached: json['isCached'] as bool? ?? false,
      finalUri: json['finalUri'] == null
          ? null
          : Uri.parse(json['finalUri'] as String),
      contentType: json['contentType'] as String?,
      encoding: json['encoding'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      contentHash: json['contentHash'] as String?,
    );

Map<String, dynamic> _$ResultProvenanceToJson(ResultProvenance instance) =>
    <String, dynamic>{
      'sourceUri': instance.sourceUri.toString(),
      'finalUri': instance.finalUri?.toString(),
      'contentType': instance.contentType,
      'encoding': instance.encoding,
      'statusCode': instance.statusCode,
      'contentHash': instance.contentHash,
      'endpoint': instance.endpoint,
      'fetchedAt': instance.fetchedAt.toIso8601String(),
      'parserVersion': instance.parserVersion,
      'isCached': instance.isCached,
    };

PageMetadata _$PageMetadataFromJson(Map<String, dynamic> json) => PageMetadata(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  displayedTotal: (json['displayedTotal'] as num?)?.toInt(),
  displayedTotalPages: (json['displayedTotalPages'] as num?)?.toInt(),
  accessiblePageLimit: (json['accessiblePageLimit'] as num?)?.toInt(),
  reachableTotalUpperBound: (json['reachableTotalUpperBound'] as num?)?.toInt(),
  truncated: json['truncated'] as bool?,
  hasNextPage: json['hasNextPage'] as bool?,
  nextPageEvidence:
      $enumDecodeNullable(
        _$NextPageEvidenceEnumMap,
        json['nextPageEvidence'],
      ) ??
      NextPageEvidence.unknown,
);

Map<String, dynamic> _$PageMetadataToJson(PageMetadata instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'displayedTotal': instance.displayedTotal,
      'displayedTotalPages': instance.displayedTotalPages,
      'accessiblePageLimit': instance.accessiblePageLimit,
      'reachableTotalUpperBound': instance.reachableTotalUpperBound,
      'truncated': instance.truncated,
      'hasNextPage': instance.hasNextPage,
      'nextPageEvidence': _$NextPageEvidenceEnumMap[instance.nextPageEvidence]!,
    };

const _$NextPageEvidenceEnumMap = {
  NextPageEvidence.upstreamNavigation: 'upstreamNavigation',
  NextPageEvidence.pageSizeHint: 'pageSizeHint',
  NextPageEvidence.knownLimit: 'knownLimit',
  NextPageEvidence.unknown: 'unknown',
};

ExplanationReference _$ExplanationReferenceFromJson(
  Map<String, dynamic> json,
) => ExplanationReference(
  id: json['id'] as String,
  uri: Uri.parse(json['uri'] as String),
  relationship:
      $enumDecodeNullable(_$ContentRelationshipEnumMap, json['relationship']) ??
      ContentRelationship.unknown,
  rawLabel: json['rawLabel'] as String? ?? '',
  availability:
      $enumDecodeNullable(_$AvailabilityEnumMap, json['availability']) ??
      Availability.advertised,
);

Map<String, dynamic> _$ExplanationReferenceToJson(
  ExplanationReference instance,
) => <String, dynamic>{
  'id': instance.id,
  'uri': instance.uri.toString(),
  'relationship': _$ContentRelationshipEnumMap[instance.relationship]!,
  'rawLabel': instance.rawLabel,
  'availability': _$AvailabilityEnumMap[instance.availability]!,
};

const _$ContentRelationshipEnumMap = {
  ContentRelationship.direct: 'direct',
  ContentRelationship.similar: 'similar',
  ContentRelationship.unknown: 'unknown',
};

const _$AvailabilityEnumMap = {
  Availability.advertised: 'advertised',
  Availability.notAdvertised: 'notAdvertised',
  Availability.unknown: 'unknown',
};
