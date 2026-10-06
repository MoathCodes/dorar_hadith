// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextRange _$TextRangeFromJson(Map<String, dynamic> json) =>
    TextRange((json['start'] as num).toInt(), (json['end'] as num).toInt());

Map<String, dynamic> _$TextRangeToJson(TextRange instance) => <String, dynamic>{
  'start': instance.start,
  'end': instance.end,
};

Citation _$CitationFromJson(Map<String, dynamic> json) => Citation(
  source: json['source'] as String,
  locator: json['locator'] as String? ?? '',
  sourceId: json['sourceId'] as String?,
  sourceUri: json['sourceUri'] == null
      ? null
      : Uri.parse(json['sourceUri'] as String),
  takhrij: json['takhrij'] as String?,
  rawVerdict: json['rawVerdict'] as String?,
  narrator: json['narrator'] as String?,
  scholar: json['scholar'] as String?,
  scholarId: json['scholarId'] as String?,
  verdict: json['verdict'] == null
      ? null
      : Verdict.fromJson(json['verdict'] as Map<String, dynamic>),
  parsedLocator: json['parsedLocator'] == null
      ? null
      : ParsedLocator.fromJson(json['parsedLocator'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CitationToJson(Citation instance) => <String, dynamic>{
  'source': instance.source,
  'locator': instance.locator,
  'sourceId': instance.sourceId,
  'sourceUri': instance.sourceUri?.toString(),
  'takhrij': instance.takhrij,
  'rawVerdict': instance.rawVerdict,
  'narrator': instance.narrator,
  'scholar': instance.scholar,
  'scholarId': instance.scholarId,
  'verdict': instance.verdict?.toJson(),
  'parsedLocator': instance.parsedLocator?.toJson(),
};

DocumentBlock _$DocumentBlockFromJson(Map<String, dynamic> json) =>
    DocumentBlock(
      kind: $enumDecode(_$BlockKindEnumMap, json['kind']),
      range: TextRange.fromJson(json['range'] as Map<String, dynamic>),
      citation: json['citation'] == null
          ? null
          : Citation.fromJson(json['citation'] as Map<String, dynamic>),
      evidence: json['evidence'] as String? ?? 'dom',
    );

Map<String, dynamic> _$DocumentBlockToJson(DocumentBlock instance) =>
    <String, dynamic>{
      'kind': _$BlockKindEnumMap[instance.kind]!,
      'range': instance.range.toJson(),
      'citation': instance.citation?.toJson(),
      'evidence': instance.evidence,
    };

const _$BlockKindEnumMap = {
  BlockKind.narration: 'narration',
  BlockKind.citation: 'citation',
  BlockKind.commentary: 'commentary',
  BlockKind.chain: 'chain',
  BlockKind.separator: 'separator',
  BlockKind.listItem: 'listItem',
  BlockKind.heading: 'heading',
  BlockKind.paragraph: 'paragraph',
};

InlineAnnotation _$InlineAnnotationFromJson(Map<String, dynamic> json) =>
    InlineAnnotation(
      kind: $enumDecode(_$AnnotationKindEnumMap, json['kind']),
      range: TextRange.fromJson(json['range'] as Map<String, dynamic>),
      label: json['label'] as String?,
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      definition: json['definition'] as String?,
      definitionHtml: json['definitionHtml'] as String?,
      evidence: json['evidence'] as String? ?? 'dom',
      quranReference: json['quranReference'] == null
          ? null
          : QuranCitationReference.fromJson(
              json['quranReference'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$InlineAnnotationToJson(InlineAnnotation instance) =>
    <String, dynamic>{
      'kind': _$AnnotationKindEnumMap[instance.kind]!,
      'range': instance.range.toJson(),
      'label': instance.label,
      'uri': instance.uri?.toString(),
      'definition': instance.definition,
      'definitionHtml': instance.definitionHtml,
      'evidence': instance.evidence,
      'quranReference': instance.quranReference?.toJson(),
    };

const _$AnnotationKindEnumMap = {
  AnnotationKind.link: 'link',
  AnnotationKind.glossary: 'glossary',
  AnnotationKind.quranCitation: 'quranCitation',
  AnnotationKind.quotation: 'quotation',
};

AttributionAnnotation _$AttributionAnnotationFromJson(
  Map<String, dynamic> json,
) => AttributionAnnotation(
  range: TextRange.fromJson(json['range'] as Map<String, dynamic>),
  role: $enumDecode(_$SpeakerRoleEnumMap, json['role']),
  evidence: $enumDecode(_$AttributionEvidenceEnumMap, json['evidence']),
  documentHash: json['documentHash'] as String,
  sourceUri: Uri.parse(json['sourceUri'] as String),
  speakerName: json['speakerName'] as String?,
  reviewer: json['reviewer'] as String?,
  evidenceNote: json['evidenceNote'] as String?,
);

Map<String, dynamic> _$AttributionAnnotationToJson(
  AttributionAnnotation instance,
) => <String, dynamic>{
  'range': instance.range.toJson(),
  'role': _$SpeakerRoleEnumMap[instance.role]!,
  'evidence': _$AttributionEvidenceEnumMap[instance.evidence]!,
  'documentHash': instance.documentHash,
  'sourceUri': instance.sourceUri.toString(),
  'speakerName': instance.speakerName,
  'reviewer': instance.reviewer,
  'evidenceNote': instance.evidenceNote,
};

const _$SpeakerRoleEnumMap = {
  SpeakerRole.prophet: 'prophet',
  SpeakerRole.companion: 'companion',
  SpeakerRole.scholar: 'scholar',
  SpeakerRole.divine: 'divine',
  SpeakerRole.narrator: 'narrator',
  SpeakerRole.unknown: 'unknown',
};

const _$AttributionEvidenceEnumMap = {
  AttributionEvidence.sourceMarkup: 'sourceMarkup',
  AttributionEvidence.reviewed: 'reviewed',
  AttributionEvidence.textHeuristic: 'textHeuristic',
};

SourcedDocument _$SourcedDocumentFromJson(Map<String, dynamic> json) =>
    SourcedDocument(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      sourceUri: json['sourceUri'] == null
          ? null
          : Uri.parse(json['sourceUri'] as String),
      sourceHtml: json['sourceHtml'] as String,
      sourceText: json['sourceText'] as String,
      contentHash: json['contentHash'] as String,
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => DocumentBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      annotations:
          (json['annotations'] as List<dynamic>?)
              ?.map((e) => InlineAnnotation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SourcedDocumentToJson(SourcedDocument instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'sourceUri': instance.sourceUri?.toString(),
      'sourceHtml': instance.sourceHtml,
      'sourceText': instance.sourceText,
      'contentHash': instance.contentHash,
      'blocks': instance.blocks.map((e) => e.toJson()).toList(),
      'annotations': instance.annotations.map((e) => e.toJson()).toList(),
    };

CalendarYear _$CalendarYearFromJson(Map<String, dynamic> json) => CalendarYear(
  year: (json['year'] as num).toInt(),
  calendar: $enumDecode(_$CalendarKindEnumMap, json['calendar']),
  raw: json['raw'] as String,
);

Map<String, dynamic> _$CalendarYearToJson(CalendarYear instance) =>
    <String, dynamic>{
      'year': instance.year,
      'calendar': _$CalendarKindEnumMap[instance.calendar]!,
      'raw': instance.raw,
    };

const _$CalendarKindEnumMap = {
  CalendarKind.hijri: 'hijri',
  CalendarKind.gregorian: 'gregorian',
  CalendarKind.unknown: 'unknown',
};

EditionDate _$EditionDateFromJson(Map<String, dynamic> json) => EditionDate(
  raw: json['raw'] as String,
  components: (json['components'] as List<dynamic>)
      .map((e) => CalendarYear.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: $enumDecode(_$DateParseStatusEnumMap, json['status']),
);

Map<String, dynamic> _$EditionDateToJson(EditionDate instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'components': instance.components.map((e) => e.toJson()).toList(),
      'status': _$DateParseStatusEnumMap[instance.status]!,
    };

const _$DateParseStatusEnumMap = {
  DateParseStatus.absent: 'absent',
  DateParseStatus.parsed: 'parsed',
  DateParseStatus.partial: 'partial',
  DateParseStatus.unparsed: 'unparsed',
};

Verdict _$VerdictFromJson(Map<String, dynamic> json) => Verdict(
  raw: json['raw'] as String,
  classification: json['classification'] as String?,
  scope: json['scope'] as String?,
  evidence: json['evidence'] as String?,
);

Map<String, dynamic> _$VerdictToJson(Verdict instance) => <String, dynamic>{
  'raw': instance.raw,
  'classification': instance.classification,
  'scope': instance.scope,
  'evidence': instance.evidence,
};

ParsedLocator _$ParsedLocatorFromJson(Map<String, dynamic> json) =>
    ParsedLocator(
      raw: json['raw'] as String,
      status:
          $enumDecodeNullable(_$LocatorParseStatusEnumMap, json['status']) ??
          LocatorParseStatus.unparsed,
      volume: (json['volume'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      recordNumber: json['recordNumber'] as String?,
      evidence: json['evidence'] as String?,
    );

Map<String, dynamic> _$ParsedLocatorToJson(ParsedLocator instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'status': _$LocatorParseStatusEnumMap[instance.status]!,
      'volume': instance.volume,
      'page': instance.page,
      'recordNumber': instance.recordNumber,
      'evidence': instance.evidence,
    };

const _$LocatorParseStatusEnumMap = {
  LocatorParseStatus.unparsed: 'unparsed',
  LocatorParseStatus.parsed: 'parsed',
  LocatorParseStatus.ambiguous: 'ambiguous',
};

SourceMetadataField _$SourceMetadataFieldFromJson(Map<String, dynamic> json) =>
    SourceMetadataField(
      label: json['label'] as String,
      value: json['value'] as String,
      sourceHtml: json['sourceHtml'] as String,
    );

Map<String, dynamic> _$SourceMetadataFieldToJson(
  SourceMetadataField instance,
) => <String, dynamic>{
  'label': instance.label,
  'value': instance.value,
  'sourceHtml': instance.sourceHtml,
};

QuranCitationReference _$QuranCitationReferenceFromJson(
  Map<String, dynamic> json,
) => QuranCitationReference(
  rawLabel: json['rawLabel'] as String,
  surahName: json['surahName'] as String?,
  surahNumber: (json['surahNumber'] as num?)?.toInt(),
  ayahNumbers:
      (json['ayahNumbers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  status:
      $enumDecodeNullable(_$LocatorParseStatusEnumMap, json['status']) ??
      LocatorParseStatus.unparsed,
  evidence: json['evidence'] as String?,
);

Map<String, dynamic> _$QuranCitationReferenceToJson(
  QuranCitationReference instance,
) => <String, dynamic>{
  'rawLabel': instance.rawLabel,
  'surahName': instance.surahName,
  'surahNumber': instance.surahNumber,
  'ayahNumbers': instance.ayahNumbers,
  'status': _$LocatorParseStatusEnumMap[instance.status]!,
  'evidence': instance.evidence,
};
