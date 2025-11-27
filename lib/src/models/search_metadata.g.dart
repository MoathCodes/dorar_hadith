// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchMetadata _$SearchMetadataFromJson(Map<String, dynamic> json) =>
    _SearchMetadata(
      length: (json['length'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt(),
      removeHtml: json['removeHTML'] as bool?,
      specialist: json['specialist'] as bool?,
      numberOfNonSpecialist: (json['numberOfNonSpecialist'] as num?)?.toInt(),
      numberOfSpecialist: (json['numberOfSpecialist'] as num?)?.toInt(),
      isCached: json['isCached'] as bool? ?? false,
      usulSourcesCount: (json['usulSourcesCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchMetadataToJson(_SearchMetadata instance) =>
    <String, dynamic>{
      'length': instance.length,
      'page': instance.page,
      'removeHTML': instance.removeHtml,
      'specialist': instance.specialist,
      'numberOfNonSpecialist': instance.numberOfNonSpecialist,
      'numberOfSpecialist': instance.numberOfSpecialist,
      'isCached': instance.isCached,
      'usulSourcesCount': instance.usulSourcesCount,
    };
