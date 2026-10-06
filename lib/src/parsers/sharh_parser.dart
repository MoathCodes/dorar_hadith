import 'package:html/dom.dart' as dom;

import 'html_helper.dart';
import 'record_parser.dart';
import 'document_parser.dart';
import 'hadith_parser.dart';
import '../models/source_content.dart';
import '../models/hadith.dart';

/// Data class holding parsed sharh information.
class ParsedSharhData {
  /// The hadith text (with dashes removed).
  final String hadith;

  /// The narrator (rawi) of the hadith.
  final String rawi;

  /// The hadith scholar (mohdith).
  final String mohdith;

  /// The source book.
  final String book;

  /// The page number or hadith number in the book.
  final String numberOrPage;

  /// The grade/authenticity of the hadith.
  final String grade;

  /// The takhrij (verification) information.
  final String takhrij;

  /// The sharh (explanation) text.
  final String sharh;

  /// The sharh ID.
  final String sharhId;
  final DetailedHadith record;
  final SourcedDocument document;
  final DetailedHadith? embeddedHadith;

  const ParsedSharhData({
    required this.hadith,
    required this.rawi,
    required this.mohdith,
    required this.book,
    required this.numberOrPage,
    required this.grade,
    required this.takhrij,
    required this.sharh,
    required this.sharhId,
    required this.record,
    required this.document,
    this.embeddedHadith,
  });

  @override
  String toString() {
    return 'ParsedSharhData('
        'hadith: ${hadith.substring(0, hadith.length > 50 ? 50 : hadith.length)}..., '
        'rawi: $rawi, '
        'mohdith: $mohdith, '
        'book: $book, '
        'sharh: ${sharh.substring(0, sharh.length > 50 ? 50 : sharh.length)}...'
        ')';
  }
}

/// Parser for extracting sharh (explanation) data from Dorar.net HTML.
///
/// Handles parsing of sharh pages containing hadith text, metadata, and explanation.
class SharhParser {
  SharhParser._();

  /// Extract the first sharh ID from a search results page.
  ///
  /// Returns null if no sharh is found.
  static String? extractFirstSharhId(dom.Document doc, String tabName) {
    final tabElement = doc.querySelector('#$tabName');
    if (tabElement == null) {
      throw FormatException('Tab element not found: #$tabName');
    }

    final sharhElement = tabElement.querySelector('a[xplain]');
    if (sharhElement == null) {
      return null;
    }

    final sharhId = HtmlHelper.getAttribute(sharhElement, 'xplain');

    // Filter out '0' which indicates no sharh available
    if (sharhId == null || sharhId == '0') {
      return null;
    }

    return sharhId;
  }

  /// Extract sharh ID from a search result element.
  ///
  /// Returns null if no sharh ID is found or if the ID is '0'.
  static String? extractSharhId(dom.Element element) {
    final sharhElement = element.querySelector('a[xplain]');
    if (sharhElement == null) {
      return null;
    }

    final sharhId = HtmlHelper.getAttribute(sharhElement, 'xplain');

    // Filter out '0' which indicates no sharh available
    if (sharhId == null || sharhId == '0') {
      return null;
    }

    return sharhId;
  }

  /// Extract all sharh IDs from a search results page.
  ///
  /// Filters out invalid IDs (null or '0').
  static List<String> extractSharhIds(dom.Document doc, String tabName) {
    final tabElement = doc.querySelector('#$tabName');
    if (tabElement == null) {
      throw FormatException('Tab element not found: #$tabName');
    }

    final resultElements = tabElement.querySelectorAll('.border-bottom');
    final sharhIds = <String>[];

    for (final element in resultElements) {
      final sharhId = extractSharhId(element);
      if (sharhId != null) {
        sharhIds.add(sharhId);
      }
    }

    return sharhIds;
  }

  /// Parse a complete sharh page.
  ///
  /// Extracts all information from the sharh detail page including
  /// the hadith text, metadata, and sharh explanation.
  ///
  /// [html] - The HTML content to parse.
  /// [sharhId] - The sharh ID.
  /// [removeHtml] - Whether to strip HTML tags from text fields (default: true).
  ///
  /// Throws [FormatException] if the HTML structure is invalid.
  static ParsedSharhData parseSharhPage(
    String html,
    String sharhId, {
    bool removeHtml = true,
    Uri? sourceUri,
  }) {
    final doc = HtmlHelper.parseHtml(html);

    final uri =
        sourceUri ?? Uri.parse('https://dorar.net/hadith/sharh/$sharhId');
    final header = doc.querySelector('.border-bottom');
    if (header == null) {
      throw const FormatException('Explanation record header not found');
    }
    final record = RecordParser.parse(
      header,
      sourceUri: uri,
      removeHtml: removeHtml,
    );
    final content =
        doc.querySelector('#sharh-text-content') ??
        doc.querySelector('.text-justify')?.nextElementSibling;
    if (content == null) {
      throw const FormatException('Explanation body not found');
    }
    final embedded = content.querySelector('.app-hadith-info')?.parent;
    Citation? citation;
    DetailedHadith? embeddedHadith;
    if (embedded != null) {
      final metadata = HadithParser.parseHadithInfo(embedded);
      citation = Citation(
        source: metadata.book,
        locator: metadata.numberOrPage,
        rawVerdict: metadata.grade,
        takhrij: metadata.takhrij,
        narrator: metadata.rawi,
        scholar: metadata.mohdith,
        sourceId: metadata.bookId,
        scholarId: metadata.mohdithId,
      );
      if (metadata.rawi.isNotEmpty &&
          metadata.mohdith.isNotEmpty &&
          metadata.book.isNotEmpty) {
        final narration = embedded.children.firstOrNull;
        if (narration != null &&
            !narration.classes.contains('app-hadith-info')) {
          final narrationDocument = DocumentParser.parse(
            narration.innerHtml,
            sourceUri: uri,
            defaultKind: BlockKind.narration,
          );
          embeddedHadith = DetailedHadith(
            hadith: removeHtml
                ? narrationDocument.plainText.trim()
                : narration.innerHtml,
            rawi: metadata.rawi,
            mohdith: metadata.mohdith,
            book: metadata.book,
            numberOrPage: metadata.numberOrPage,
            grade: metadata.grade,
            bookId: metadata.bookId,
            mohdithId: metadata.mohdithId,
            takhrij: metadata.takhrij,
            content: narrationDocument,
          );
        }
      }
    }
    final document = DocumentParser.parse(
      content.innerHtml,
      sourceUri: uri,
      defaultKind: BlockKind.commentary,
      embeddedCitation: citation,
    );
    final hadithText = record.hadith;
    final rawi = record.rawi, mohdith = record.mohdith, book = record.book;
    final numberOrPage = record.numberOrPage, grade = record.grade;
    final takhrij = record.takhrij ?? '';
    final sharhText = removeHtml
        ? document.plainText.trim()
        : content.innerHtml;

    return ParsedSharhData(
      hadith: hadithText,
      rawi: rawi,
      mohdith: mohdith,
      book: book,
      numberOrPage: numberOrPage,
      grade: grade,
      takhrij: takhrij,
      sharh: sharhText,
      sharhId: sharhId,
      record: record,
      document: document,
      embeddedHadith: embeddedHadith,
    );
  }
}
