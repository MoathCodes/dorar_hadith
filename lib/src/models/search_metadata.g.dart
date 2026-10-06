// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchMetadata _$SearchMetadataFromJson(
  Map<String, dynamic> json,
) => _SearchMetadata(
  length: (json['length'] as num?)?.toInt() ?? 0,
  diagnostics: json['diagnostics'] == null
      ? null
      : ParseDiagnostics.fromJson(json['diagnostics'] as Map<String, dynamic>),
  provenance: json['provenance'] == null
      ? null
      : ResultProvenance.fromJson(json['provenance'] as Map<String, dynamic>),
  pagination: json['pagination'] == null
      ? null
      : PageMetadata.fromJson(json['pagination'] as Map<String, dynamic>),
  referenceCoverage: $enumDecodeNullable(
    _$ReferenceCoverageEnumMap,
    json['referenceCoverage'],
  ),
  selectedScholarIds:
      (json['selectedScholarIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  currentPageCount: (json['currentPageCount'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  hasNextPage: json['hasNextPage'] as bool?,
  hasPrevPage: json['hasPrevPage'] as bool?,
  removeHtml: json['removeHTML'] as bool?,
  specialist: json['specialist'] as bool?,
  numberOfNonSpecialist: (json['numberOfNonSpecialist'] as num?)?.toInt(),
  numberOfSpecialist: (json['numberOfSpecialist'] as num?)?.toInt(),
  isCached: json['isCached'] as bool? ?? false,
  usulSourcesCount: (json['usulSourcesCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$SearchMetadataToJson(
  _SearchMetadata instance,
) => <String, dynamic>{
  'length': instance.length,
  'diagnostics': instance.diagnostics?.toJson(),
  'provenance': instance.provenance?.toJson(),
  'pagination': instance.pagination?.toJson(),
  'referenceCoverage': _$ReferenceCoverageEnumMap[instance.referenceCoverage],
  'selectedScholarIds': instance.selectedScholarIds,
  'currentPageCount': instance.currentPageCount,
  'total': instance.total,
  'page': instance.page,
  'totalPages': instance.totalPages,
  'hasNextPage': instance.hasNextPage,
  'hasPrevPage': instance.hasPrevPage,
  'removeHTML': instance.removeHtml,
  'specialist': instance.specialist,
  'numberOfNonSpecialist': instance.numberOfNonSpecialist,
  'numberOfSpecialist': instance.numberOfSpecialist,
  'isCached': instance.isCached,
  'usulSourcesCount': instance.usulSourcesCount,
};

const _$ReferenceCoverageEnumMap = {
  ReferenceCoverage.currentSelection: 'currentSelection',
  ReferenceCoverage.partial: 'partial',
  ReferenceCoverage.historical: 'historical',
};
