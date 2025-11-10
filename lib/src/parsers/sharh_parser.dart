import 'package:html/dom.dart' as dom;

import 'html_helper.dart';

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
  }) {
    final doc = HtmlHelper.parseHtml(html);

    // Extract hadith text from article element
    final article = doc.querySelector('article');
    if (article == null) {
      throw const FormatException(
        'Invalid response structure: article not found',
      );
    }

    // Clean hadith text (remove dash separators)
    final hadithText = removeHtml
        ? article.text.replaceAll(RegExp(r'-\s*'), '').trim()
        : article.innerHtml.replaceAll(RegExp(r'-\s*'), '').trim();

    // Extract metadata from primary-text-color elements
    // API can return different numbers of elements:
    // 4 elements: rawi, mohdith, book, number (no grade, no takhrij)
    // 5 elements: rawi, mohdith, book, number, takhrij (no grade)
    // 6 elements: rawi, mohdith, book, number, grade, takhrij (full data)
    final metadataElements = doc.querySelectorAll('.primary-text-color');

    if (metadataElements.length < 4) {
      throw FormatException(
        'Invalid metadata structure: expected at least 4 elements, found ${metadataElements.length}',
      );
    }

    final rawi = metadataElements[0].text.trim();
    final mohdith = metadataElements[1].text.trim();
    final book = metadataElements[2].text.trim();
    final numberOrPage = metadataElements[3].text.trim();

    // Handle optional grade and takhrij based on element count
    String grade = '';
    String takhrij = '';

    if (metadataElements.length >= 6) {
      // 6 elements: includes grade and takhrij
      grade = metadataElements[4].text.trim();
      takhrij = metadataElements[5].text.trim();
    } else if (metadataElements.length == 5) {
      // 5 elements: no grade, last is takhrij
      takhrij = metadataElements[4].text.trim();
    }
    // else: 4 elements, no grade and no takhrij (leave as empty strings)

    // Extract sharh text
    // Find the .text-justify element, then get its next sibling
    final textJustifyElement = doc.querySelector('.text-justify');
    if (textJustifyElement == null) {
      throw const FormatException(
        'Sharh structure not found: .text-justify not found',
      );
    }

    final sharhElement = HtmlHelper.getNextElementSibling(textJustifyElement);
    if (sharhElement == null) {
      throw const FormatException('Sharh content not found');
    }

    final sharhText = removeHtml
        ? sharhElement.text.trim()
        : sharhElement.innerHtml.trim();

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
    );
  }
}
