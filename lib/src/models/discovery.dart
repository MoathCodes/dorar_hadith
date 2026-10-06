import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'identifiers.dart';
import 'result_details.dart';
part 'discovery.g.dart';

@JsonSerializable()
class ReferenceChoice extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const ReferenceChoice({required this.id, required this.name});
  final String id;
  final String name;
  factory ReferenceChoice.fromJson(Map<String, dynamic> json) =>
      _$ReferenceChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceChoiceToJson(this);
}

@JsonSerializable()
class ThematicRoot extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const ThematicRoot({required this.value, required this.name});
  final String value;
  final String name;
  CategorySelector get selector => CategorySelector(value);
  factory ThematicRoot.fromJson(Map<String, dynamic> json) =>
      _$ThematicRootFromJson(json);
  Map<String, dynamic> toJson() => _$ThematicRootToJson(this);
}

@JsonSerializable()
class ThematicCategory extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const ThematicCategory({
    required this.id,
    required this.name,
    required this.uri,
    this.parentSelector,
  });
  final String id;
  final String name;
  final Uri uri;
  final String? parentSelector;
  factory ThematicCategory.fromJson(Map<String, dynamic> json) =>
      _$ThematicCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ThematicCategoryToJson(this);
}

class CategoryBrowseParams {
  const CategoryBrowseParams({
    required this.categoryId,
    this.page = 1,
    this.specialist = false,
    this.removeHtml = true,
    this.parsePolicy = ParsePolicy.strict,
  });
  final CategoryId categoryId;
  final int page;
  final bool specialist;
  final bool removeHtml;
  final ParsePolicy parsePolicy;
}
