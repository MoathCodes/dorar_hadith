import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'source_content.g.dart';

enum BlockKind {
  narration,
  citation,
  commentary,
  chain,
  separator,
  listItem,
  heading,
  paragraph,
}

enum AnnotationKind { link, glossary, quranCitation, quotation }

enum SpeakerRole { prophet, companion, scholar, divine, narrator, unknown }

enum AttributionEvidence { sourceMarkup, reviewed, textHeuristic }

enum CalendarKind { hijri, gregorian, unknown }

enum DateParseStatus { absent, parsed, partial, unparsed }

/// Half-open offsets in canonical source text, measured in UTF-16 code units.
@JsonSerializable()
class TextRange extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const TextRange(this.start, this.end);
  final int start;
  final int end;
  factory TextRange.fromJson(Map<String, dynamic> json) =>
      _$TextRangeFromJson(json);
  Map<String, dynamic> toJson() => _$TextRangeToJson(this);
  String extract(String text) => text.substring(start, end);
  bool isValidFor(String text) =>
      start >= 0 &&
      end >= start &&
      end <= text.length &&
      !_splitsSurrogate(text, start) &&
      !_splitsSurrogate(text, end);
  static bool _splitsSurrogate(String text, int offset) =>
      offset > 0 &&
      offset < text.length &&
      text.codeUnitAt(offset - 1) >= 0xd800 &&
      text.codeUnitAt(offset - 1) <= 0xdbff &&
      text.codeUnitAt(offset) >= 0xdc00 &&
      text.codeUnitAt(offset) <= 0xdfff;
}

/// Source-backed citation. Derived locator/verdict classifications are absent
/// unless separately verified; raw values remain available in every case.
@JsonSerializable(explicitToJson: true)
class Citation extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const Citation({
    required this.source,
    this.locator = '',
    this.sourceId,
    this.sourceUri,
    this.takhrij,
    this.rawVerdict,
    this.narrator,
    this.scholar,
    this.scholarId,
    this.verdict,
    this.parsedLocator,
  });
  final String source;
  final String locator;
  final String? sourceId;
  final Uri? sourceUri;
  final String? takhrij;
  final String? rawVerdict;
  final String? narrator;
  final String? scholar;
  final String? scholarId;
  final Verdict? verdict;
  final ParsedLocator? parsedLocator;
  factory Citation.fromJson(Map<String, dynamic> json) =>
      _$CitationFromJson(json);
  Map<String, dynamic> toJson() => _$CitationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DocumentBlock extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const DocumentBlock({
    required this.kind,
    required this.range,
    this.citation,
    this.evidence = 'dom',
  });
  final BlockKind kind;
  final TextRange range;
  final Citation? citation;
  final String evidence;
  factory DocumentBlock.fromJson(Map<String, dynamic> json) =>
      _$DocumentBlockFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentBlockToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InlineAnnotation extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const InlineAnnotation({
    required this.kind,
    required this.range,
    this.label,
    this.uri,
    this.definition,
    this.definitionHtml,
    this.evidence = 'dom',
    this.quranReference,
  });
  final AnnotationKind kind;
  final TextRange range;
  final String? label;
  final Uri? uri;
  final String? definition;
  final String? definitionHtml;
  final String evidence;
  final QuranCitationReference? quranReference;
  factory InlineAnnotation.fromJson(Map<String, dynamic> json) =>
      _$InlineAnnotationFromJson(json);
  Map<String, dynamic> toJson() => _$InlineAnnotationToJson(this);
}

/// Attribution is separate from formatting. Heuristic candidates are never
/// confirmed assignments and must not drive authoritative speaker styling.
@JsonSerializable(explicitToJson: true)
class AttributionAnnotation extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const AttributionAnnotation({
    required this.range,
    required this.role,
    required this.evidence,
    required this.documentHash,
    required this.sourceUri,
    this.speakerName,
    this.reviewer,
    this.evidenceNote,
  });
  final TextRange range;
  final SpeakerRole role;
  final AttributionEvidence evidence;
  final String documentHash;
  final Uri sourceUri;
  final String? speakerName;
  final String? reviewer;
  final String? evidenceNote;
  bool get isConfirmed =>
      evidence != AttributionEvidence.textHeuristic &&
      role != SpeakerRole.unknown;
  factory AttributionAnnotation.fromJson(Map<String, dynamic> json) =>
      _$AttributionAnnotationFromJson(json);
  Map<String, dynamic> toJson() => _$AttributionAnnotationToJson(this);
}

/// Canonical decoded content and its independently renderable structure.
@JsonSerializable(explicitToJson: true)
class SourcedDocument extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const SourcedDocument({
    this.schemaVersion = 1,
    this.sourceUri,
    required this.sourceHtml,
    required this.sourceText,
    required this.contentHash,
    required this.blocks,
    this.annotations = const [],
  });
  final int schemaVersion;
  final Uri? sourceUri;

  /// Scoped DOM serialization, not an assertion of byte-identical HTML.
  final String sourceHtml;
  final String sourceText;
  final String contentHash;
  final List<DocumentBlock> blocks;
  final List<InlineAnnotation> annotations;
  String get plainText => sourceText;
  String get commentaryText {
    validate();
    return blocks
        .where(
          (b) =>
              b.kind == BlockKind.commentary ||
              b.kind == BlockKind.paragraph ||
              b.kind == BlockKind.heading ||
              b.kind == BlockKind.listItem,
        )
        .map((b) => b.range.extract(sourceText))
        .join('\n\n');
  }

  factory SourcedDocument.fromJson(Map<String, dynamic> json) {
    final document = _$SourcedDocumentFromJson(json);
    document.validate();
    return document;
  }
  Map<String, dynamic> toJson() => _$SourcedDocumentToJson(this);

  /// Reject stale text hashes, incompatible schemas and invalid UTF-16 spans.
  void validate() {
    if (schemaVersion != 1 ||
        contentHash !=
            sha256
                .convert(utf8.encode('$schemaVersion\n$sourceText'))
                .toString()) {
      throw const FormatException(
        'Invalid source document schema or content hash',
      );
    }
    var previousEnd = 0;
    for (final block in blocks) {
      if (!block.range.isValidFor(sourceText) ||
          block.range.start < previousEnd ||
          (block.kind == BlockKind.separator &&
              block.range.start != block.range.end)) {
        throw const FormatException(
          'Invalid or overlapping source document block',
        );
      }
      previousEnd = block.range.end;
    }
    for (final annotation in annotations) {
      if (!annotation.range.isValidFor(sourceText)) {
        throw const FormatException('Invalid source annotation range');
      }
    }
  }

  void validateAttributions(List<AttributionAnnotation> values) {
    validate();
    for (final value in values) {
      if (value.documentHash != contentHash ||
          sourceUri == null ||
          value.sourceUri != sourceUri ||
          !value.range.isValidFor(sourceText) ||
          value.range.start == value.range.end ||
          value.evidenceNote?.trim().isNotEmpty != true ||
          (value.evidence == AttributionEvidence.reviewed &&
              value.reviewer?.trim().isNotEmpty != true)) {
        throw ArgumentError(
          'Attribution requires matching source/hash, valid span and review evidence',
        );
      }
    }
    for (var i = 0; i < values.length; i++) {
      for (var j = i + 1; j < values.length; j++) {
        final a = values[i], b = values[j];
        if (a.isConfirmed &&
            b.isConfirmed &&
            a.range.start < b.range.end &&
            b.range.start < a.range.end &&
            (a.role != b.role || a.speakerName != b.speakerName)) {
          throw ArgumentError('Conflicting confirmed attribution');
        }
      }
    }
  }
}

@JsonSerializable()
class CalendarYear extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const CalendarYear({
    required this.year,
    required this.calendar,
    required this.raw,
  });
  final int year;
  final CalendarKind calendar;
  final String raw;
  factory CalendarYear.fromJson(Map<String, dynamic> json) =>
      _$CalendarYearFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarYearToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EditionDate extends Equatable {
  @override
  List<Object?> get props => [jsonEncode(toJson())];
  const EditionDate({
    required this.raw,
    required this.components,
    required this.status,
  });
  final String raw;
  final List<CalendarYear> components;
  final DateParseStatus status;
  factory EditionDate.fromJson(Map<String, dynamic> json) =>
      _$EditionDateFromJson(json);
  Map<String, dynamic> toJson() => _$EditionDateToJson(this);
  factory EditionDate.parse(String raw) {
    if (raw.trim().isEmpty) {
      return EditionDate(
        raw: raw,
        components: const [],
        status: DateParseStatus.absent,
      );
    }
    const bidi = r'\u200e\u200f\u202a-\u202e\u2066-\u2069';
    final pattern = RegExp(
      '([0-9٠-٩][$bidi]*){3,4}\\s*(هجرية|هـ?|ميلادية|ميلادي|م)?',
    );
    final matches = pattern.allMatches(raw).toList();
    final years = matches.map((m) {
      final number = RegExp('[0-9٠-٩]').allMatches(m[0]!).map((digit) {
        final code = digit[0]!.codeUnitAt(0);
        return code >= 0x660 ? (code - 0x660).toString() : digit[0]!;
      }).join();
      final calendar = m[2];
      return CalendarYear(
        year: int.parse(number),
        calendar: calendar?.startsWith('ه') == true
            ? CalendarKind.hijri
            : calendar?.startsWith('م') == true
            ? CalendarKind.gregorian
            : CalendarKind.unknown,
        raw: m[0]!,
      );
    }).toList();
    final remaining = raw
        .replaceAll(pattern, '')
        .replaceAll(RegExp('[\\s/،,\\-–—$bidi]+'), '');
    return EditionDate(
      raw: raw,
      components: List.unmodifiable(years),
      status: years.isEmpty
          ? DateParseStatus.unparsed
          : remaining.isEmpty
          ? DateParseStatus.parsed
          : DateParseStatus.partial,
    );
  }
}

/// Optional enrichment must preserve raw wording and identify its scope/evidence.
@JsonSerializable()
class Verdict extends Equatable {
  const Verdict({
    required this.raw,
    this.classification,
    this.scope,
    this.evidence,
  });
  final String raw;
  final String? classification;
  final String? scope;
  final String? evidence;
  @override
  List<Object?> get props => [raw, classification, scope, evidence];
  factory Verdict.fromJson(Map<String, dynamic> json) =>
      _$VerdictFromJson(json);
  Map<String, dynamic> toJson() => _$VerdictToJson(this);
}

enum LocatorParseStatus { unparsed, parsed, ambiguous }

@JsonSerializable()
class ParsedLocator extends Equatable {
  const ParsedLocator({
    required this.raw,
    this.status = LocatorParseStatus.unparsed,
    this.volume,
    this.page,
    this.recordNumber,
    this.evidence,
  });
  final String raw;
  final LocatorParseStatus status;
  final int? volume;
  final int? page;
  final String? recordNumber;
  final String? evidence;
  @override
  List<Object?> get props => [
    raw,
    status,
    volume,
    page,
    recordNumber,
    evidence,
  ];
  factory ParsedLocator.fromJson(Map<String, dynamic> json) =>
      _$ParsedLocatorFromJson(json);
  Map<String, dynamic> toJson() => _$ParsedLocatorToJson(this);
}

@JsonSerializable()
class SourceMetadataField extends Equatable {
  const SourceMetadataField({
    required this.label,
    required this.value,
    required this.sourceHtml,
  });
  final String label;
  final String value;
  final String sourceHtml;
  @override
  List<Object?> get props => [label, value, sourceHtml];
  factory SourceMetadataField.fromJson(Map<String, dynamic> json) =>
      _$SourceMetadataFieldFromJson(json);
  Map<String, dynamic> toJson() => _$SourceMetadataFieldToJson(this);
}

@JsonSerializable()
class QuranCitationReference extends Equatable {
  const QuranCitationReference({
    required this.rawLabel,
    this.surahName,
    this.surahNumber,
    this.ayahNumbers = const [],
    this.status = LocatorParseStatus.unparsed,
    this.evidence,
  });
  final String rawLabel;
  final String? surahName;
  final int? surahNumber;
  final List<int> ayahNumbers;
  final LocatorParseStatus status;
  final String? evidence;
  @override
  List<Object?> get props => [
    rawLabel,
    surahName,
    surahNumber,
    ayahNumbers,
    status,
    evidence,
  ];

  /// Parse only an explicit source link label such as `[لقمان: 14]`.
  /// A named surah remains named; no numeric identity is inferred from the URI.
  factory QuranCitationReference.parseLabel(String rawLabel) {
    final match = RegExp(
      r'^\s*\[([^\[\]:]+):\s*([0-9٠-٩]+(?:\s*[،,]\s*[0-9٠-٩]+)*)\s*\]\s*$',
    ).firstMatch(rawLabel);
    if (match == null) return QuranCitationReference(rawLabel: rawLabel);
    final verses = RegExp('[0-9٠-٩]+')
        .allMatches(match[2]!)
        .map(
          (m) => int.parse(
            m[0]!.replaceAllMapped(
              RegExp('[٠-٩]'),
              (digit) => (digit[0]!.codeUnitAt(0) - 0x660).toString(),
            ),
          ),
        )
        .toList();
    if (verses.any((v) => v < 1 || v > 286)) {
      return QuranCitationReference(rawLabel: rawLabel);
    }
    return QuranCitationReference(
      rawLabel: rawLabel,
      surahName: match[1]!.trim(),
      ayahNumbers: List.unmodifiable(verses),
      status: LocatorParseStatus.parsed,
      evidence: 'explicitCitationLabel',
    );
  }
  factory QuranCitationReference.fromJson(Map<String, dynamic> json) =>
      _$QuranCitationReferenceFromJson(json);
  Map<String, dynamic> toJson() => _$QuranCitationReferenceToJson(this);
}
