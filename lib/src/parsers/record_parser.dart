import 'package:html/dom.dart' as dom;

import '../models/hadith.dart';
import '../models/sharh_metadata.dart';
import '../models/source_content.dart';
import '../models/result_details.dart';
import 'document_parser.dart';
import 'hadith_parser.dart';

/// Parses one scoped record; independent citations never share field positions.
class RecordParser {
  static DetailedHadith parse(
    dom.Element block, {
    required Uri sourceUri,
    bool removeHtml = true,
    HadithTextCleanMode mode = HadithTextCleanMode.detail,
    String? expectedId,
  }) {
    final article =
        block.querySelector('article') ??
        (block.children.isEmpty ? null : block.children.first);
    final narration = article?.querySelector('h5') ?? article;
    final info =
        block.querySelector('.d-block') ??
        (block.children.length > 1 ? block.children[1] : null);
    if (narration == null || info == null || narration.text.trim().isEmpty) {
      throw const FormatException('Missing narration or metadata region');
    }
    final metadata = HadithParser.parseHadithInfo(info);
    if (metadata.rawi.isEmpty ||
        metadata.mohdith.isEmpty ||
        metadata.book.isEmpty) {
      throw const FormatException(
        'Missing required narrator, scholar or source label',
      );
    }
    final content = DocumentParser.parse(
      narration.innerHtml,
      sourceUri: sourceUri,
      defaultKind: BlockKind.narration,
    );
    final observedId = HadithParser.getHadithId(block);
    if (expectedId != null && observedId != null && observedId != expectedId) {
      throw const FormatException(
        'Requested record identity does not match source record',
      );
    }
    final id = observedId ?? expectedId;
    final similar = HadithParser.getSimilarHadithUrl(block);
    final alternate = HadithParser.getAlternateHadithUrl(block);
    final usul = HadithParser.getUsulHadithUrl(block);
    final asbab = block.querySelector('a[href*="asbab=1"]')?.attributes['href'];
    final explanation = explanationReference(block, sourceUri);
    return DetailedHadith(
      hadith: removeHtml
          ? HadithParser.cleanHadithText(content.plainText, mode)
          : narration.innerHtml,
      rawi: metadata.rawi,
      mohdith: metadata.mohdith,
      book: metadata.book,
      numberOrPage: metadata.numberOrPage,
      grade: metadata.grade,
      explainGrade: metadata.explainGrade.isEmpty
          ? null
          : metadata.explainGrade,
      takhrij: metadata.takhrij.isEmpty ? null : metadata.takhrij,
      mohdithId: metadata.mohdithId,
      bookId: metadata.bookId,
      hadithId: id,
      content: content,
      rawMetadata: info
          .querySelectorAll('strong')
          .map(
            (field) => SourceMetadataField(
              label: field.text.split(':').first.trim(),
              value:
                  field.querySelector('span')?.text ??
                  field.text.split(':').skip(1).join(':'),
              sourceHtml: field.outerHtml,
            ),
          )
          .toList(),
      categories: HadithParser.parseHadithCategories(block),
      hasSimilarHadith: similar != null,
      similarHadithDorar: similar,
      hasAlternateHadithSahih: alternate != null,
      alternateHadithSahihDorar: alternate,
      hasUsulHadith: usul != null,
      usulHadithDorar: usul,
      usulAvailability: usul == null
          ? Availability.unknown
          : Availability.advertised,
      asbabAvailability: asbab == null
          ? Availability.unknown
          : Availability.advertised,
      asbabDorar: asbab,
      explanationReference: explanation,
      hasSharhMetadata: explanation != null,
      sharhMetadata: explanation == null
          ? null
          : SharhMetadata(id: explanation.id),
    );
  }

  static ExplanationReference? explanationReference(
    dom.Element block,
    Uri sourceUri,
  ) {
    final link = block.querySelector('a[xplain]:not([xplain="0"])');
    final id = link?.attributes['xplain'];
    if (id == null || id.isEmpty) return null;
    final label = link!.text.trim();
    return ExplanationReference(
      id: id,
      uri: sourceUri.resolve('/hadith/sharh/$id'),
      rawLabel: label,
      relationship: relationship(label),
    );
  }

  static ContentRelationship relationship(String label) =>
      label.contains('مشابه')
      ? ContentRelationship.similar
      : label.contains('شرح الحديث') ||
            label.contains('سبب ورود الحديث') ||
            label.contains('أسباب ورود الحديث')
      ? ContentRelationship.direct
      : ContentRelationship.unknown;
  static Citation citation(DetailedHadith record) => Citation(
    source: record.book,
    locator: record.numberOrPage,
    sourceId: record.bookId,
    takhrij: record.takhrij,
    rawVerdict: record.grade,
    narrator: record.rawi,
    scholar: record.mohdith,
    scholarId: record.mohdithId,
    verdict: Verdict(raw: record.grade),
    parsedLocator: ParsedLocator(raw: record.numberOrPage),
  );
}
