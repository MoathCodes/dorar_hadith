import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'hadith.dart';
import 'source_content.dart';
import 'result_details.dart';
part 'related_content.g.dart';

enum RelatedHadithKind { alternate, similar }

@JsonSerializable(explicitToJson: true)
class RelatedHadithResult extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const RelatedHadithResult({
    required this.requestedId,
    required this.source,
    required this.kind,
    required this.related,
  });
  final String requestedId;
  final DetailedHadith? source;
  final RelatedHadithKind kind;
  final List<DetailedHadith> related;
  factory RelatedHadithResult.fromJson(Map<String, dynamic> json) =>
      _$RelatedHadithResultFromJson(json);
  Map<String, dynamic> toJson() => _$RelatedHadithResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AsbabNarration extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const AsbabNarration({
    required this.hadith,
    required this.document,
    this.relationship = ContentRelationship.unknown,
    this.rawLabel = '',
  });
  final DetailedHadith hadith;
  final SourcedDocument document;
  final ContentRelationship relationship;
  final String rawLabel;
  factory AsbabNarration.fromJson(Map<String, dynamic> json) =>
      _$AsbabNarrationFromJson(json);
  Map<String, dynamic> toJson() => _$AsbabNarrationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AsbabResult extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const AsbabResult({
    required this.requestedId,
    required this.source,
    required this.narrations,
  });
  final String requestedId;
  final DetailedHadith source;
  final List<AsbabNarration> narrations;
  factory AsbabResult.fromJson(Map<String, dynamic> json) =>
      _$AsbabResultFromJson(json);
  Map<String, dynamic> toJson() => _$AsbabResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SharhSnippet extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const SharhSnippet({
    required this.id,
    required this.uri,
    required this.document,
  });
  final String id;
  final Uri uri;
  final SourcedDocument document;
  String get text => document.plainText;
  factory SharhSnippet.fromJson(Map<String, dynamic> json) =>
      _$SharhSnippetFromJson(json);
  Map<String, dynamic> toJson() => _$SharhSnippetToJson(this);
}
