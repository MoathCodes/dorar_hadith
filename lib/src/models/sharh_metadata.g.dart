// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharh_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SharhMetadata _$SharhMetadataFromJson(Map<String, dynamic> json) =>
    _SharhMetadata(
      id: json['id'] as String,
      isContainSharh: json['isContainSharh'] as bool? ?? false,
      sharh: json['sharh'] as String?,
    );

Map<String, dynamic> _$SharhMetadataToJson(_SharhMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isContainSharh': instance.isContainSharh,
      'sharh': instance.sharh,
    };
