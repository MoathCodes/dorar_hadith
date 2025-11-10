import 'html_helper.dart';

/// Parser for extracting mohdith (hadith scholar) data from Dorar.net HTML.
class MohdithParser {
  MohdithParser._();

  /// Parse a mohdith detail page.
  ///
  /// Extracts the scholar's name and biographical information.
  ///
  /// [html] - The HTML content to parse.
  /// [mohdithId] - The mohdith ID.
  /// [removeHtml] - Whether to strip HTML tags from text fields (default: true).
  ///
  /// Throws [FormatException] if the HTML structure is invalid.
  static ParsedMohdithData parseMohdithPage(
    String html,
    String mohdithId, {
    bool removeHtml = true,
  }) {
    final doc = HtmlHelper.parseHtml(html);

    // Find the h4 element containing the name
    final h4 = doc.querySelector('h4');
    if (h4 == null) {
      throw const FormatException('Invalid response structure: h4 not found');
    }

    final name = h4.text.trim();

    // Get the parent div containing both h4 and info text
    final parentDiv = h4.parent;
    if (parentDiv == null) {
      throw const FormatException(
        'Invalid response structure: parent div not found',
      );
    }

    // Extract all text from parent div
    final fullText = removeHtml
        ? parentDiv.text.trim()
        : parentDiv.innerHtml.trim();

    // Remove the h4 text from the beginning to get just the info
    final info = fullText.replaceFirst(name, '').trim();

    // Info can be empty (some scholars may not have biographical info)
    return ParsedMohdithData(name: name, mohdithId: mohdithId, info: info);
  }
}

/// Data class holding parsed mohdith information.
class ParsedMohdithData {
  /// The scholar's name.
  final String name;

  /// The mohdith ID.
  final String mohdithId;

  /// Biographical information about the scholar.
  final String info;

  const ParsedMohdithData({
    required this.name,
    required this.mohdithId,
    required this.info,
  });

  @override
  String toString() {
    return 'ParsedMohdithData(name: $name, mohdithId: $mohdithId, '
        'info: ${info.substring(0, info.length > 50 ? 50 : info.length)}...)';
  }
}
