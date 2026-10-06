import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'result_details.g.dart';

enum ReferenceCoverage { currentSelection, partial, historical }

enum ParsePolicy { strict, bestEffort }

enum ParseCompleteness { complete, partial, unknown }

enum Availability { advertised, notAdvertised, unknown }

enum ContentRelationship { direct, similar, unknown }

enum NextPageEvidence { upstreamNavigation, pageSizeHint, knownLimit, unknown }

@JsonSerializable()
class ParseWarning extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const ParseWarning({
    required this.stage,
    required this.message,
    this.recordId,
    this.index,
  });
  final String stage;
  final String message;
  final String? recordId;
  final int? index;
  factory ParseWarning.fromJson(Map<String, dynamic> json) =>
      _$ParseWarningFromJson(json);
  Map<String, dynamic> toJson() => _$ParseWarningToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ParseDiagnostics extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const ParseDiagnostics({
    this.completeness = ParseCompleteness.complete,
    this.candidateCount = 0,
    this.parsedCount = 0,
    this.warnings = const [],
  });
  final ParseCompleteness completeness;
  final int candidateCount;
  final int parsedCount;
  final List<ParseWarning> warnings;
  int get skippedCount => candidateCount - parsedCount;
  factory ParseDiagnostics.fromJson(Map<String, dynamic> json) =>
      _$ParseDiagnosticsFromJson(json);
  Map<String, dynamic> toJson() => _$ParseDiagnosticsToJson(this);
}

@JsonSerializable()
class ResultProvenance extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const ResultProvenance({
    required this.sourceUri,
    required this.endpoint,
    required this.fetchedAt,
    this.parserVersion = 1,
    this.isCached = false,
    this.finalUri,
    this.contentType,
    this.encoding,
    this.statusCode,
    this.contentHash,
  });
  final Uri sourceUri;
  final Uri? finalUri;
  final String? contentType;
  final String? encoding;
  final int? statusCode;
  final String? contentHash;
  final String endpoint;
  final DateTime fetchedAt;
  final int parserVersion;
  final bool isCached;
  factory ResultProvenance.fromJson(Map<String, dynamic> json) =>
      _$ResultProvenanceFromJson(json);
  Map<String, dynamic> toJson() => _$ResultProvenanceToJson(this);
}

@JsonSerializable()
class PageMetadata extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const PageMetadata({
    required this.page,
    required this.pageSize,
    this.displayedTotal,
    this.displayedTotalPages,
    this.accessiblePageLimit,
    this.reachableTotalUpperBound,
    this.truncated,
    this.hasNextPage,
    this.nextPageEvidence = NextPageEvidence.unknown,
  });
  final int page;
  final int pageSize;
  final int? displayedTotal;
  final int? displayedTotalPages;
  final int? accessiblePageLimit;
  final int? reachableTotalUpperBound;
  final bool? truncated;
  final bool? hasNextPage;
  final NextPageEvidence nextPageEvidence;
  factory PageMetadata.fromJson(Map<String, dynamic> json) =>
      _$PageMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$PageMetadataToJson(this);
}

@JsonSerializable()
class ExplanationReference extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const ExplanationReference({
    required this.id,
    required this.uri,
    this.relationship = ContentRelationship.unknown,
    this.rawLabel = '',
    this.availability = Availability.advertised,
  });
  final String id;
  final Uri uri;
  final ContentRelationship relationship;
  final String rawLabel;
  final Availability availability;
  factory ExplanationReference.fromJson(Map<String, dynamic> json) =>
      _$ExplanationReferenceFromJson(json);
  Map<String, dynamic> toJson() => _$ExplanationReferenceToJson(this);
}
