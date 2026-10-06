// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceChoice _$ReferenceChoiceFromJson(Map<String, dynamic> json) =>
    ReferenceChoice(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$ReferenceChoiceToJson(ReferenceChoice instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ThematicRoot _$ThematicRootFromJson(Map<String, dynamic> json) =>
    ThematicRoot(value: json['value'] as String, name: json['name'] as String);

Map<String, dynamic> _$ThematicRootToJson(ThematicRoot instance) =>
    <String, dynamic>{'value': instance.value, 'name': instance.name};

ThematicCategory _$ThematicCategoryFromJson(Map<String, dynamic> json) =>
    ThematicCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      uri: Uri.parse(json['uri'] as String),
      parentSelector: json['parentSelector'] as String?,
    );

Map<String, dynamic> _$ThematicCategoryToJson(ThematicCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uri': instance.uri.toString(),
      'parentSelector': instance.parentSelector,
    };
