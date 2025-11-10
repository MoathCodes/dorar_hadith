/// Utilities for handling HTML content and Arabic text.
class HtmlUtils {
  /// Regular expression to match HTML tags
  static final _htmlTagRegex = RegExp(r'<[^>]*>');

  /// Regular expression to match HTML comments
  static final _htmlCommentRegex = RegExp(r'<!--.*?-->');

  /// Regular expression to match multiple whitespace
  static final _multipleWhitespaceRegex = RegExp(r'\s+');

  /// Map of common HTML entities to their character equivalents
  static const _htmlEntities = {
    '&nbsp;': ' ',
    '&lt;': '<',
    '&gt;': '>',
    '&amp;': '&',
    '&quot;': '"',
    '&#39;': "'",
    '&apos;': "'",
    '&mdash;': '—',
    '&ndash;': '–',
    '&laquo;': '«',
    '&raquo;': '»',
    '&bull;': '•',
    '&hellip;': '…',
    // Arabic-specific entities
    '&#1569;': 'ء',
    '&#1570;': 'آ',
    '&#1571;': 'أ',
    '&#1572;': 'ؤ',
    '&#1573;': 'إ',
    '&#1574;': 'ئ',
    '&#1575;': 'ا',
    '&#1576;': 'ب',
    '&#1577;': 'ة',
    '&#1578;': 'ت',
    '&#1579;': 'ث',
    '&#1580;': 'ج',
    '&#1581;': 'ح',
    '&#1582;': 'خ',
    '&#1583;': 'د',
    '&#1584;': 'ذ',
    '&#1585;': 'ر',
    '&#1586;': 'ز',
    '&#1587;': 'س',
    '&#1588;': 'ش',
    '&#1589;': 'ص',
    '&#1590;': 'ض',
    '&#1591;': 'ط',
    '&#1592;': 'ظ',
    '&#1593;': 'ع',
    '&#1594;': 'غ',
    '&#1601;': 'ف',
    '&#1602;': 'ق',
    '&#1603;': 'ك',
    '&#1604;': 'ل',
    '&#1605;': 'م',
    '&#1606;': 'ن',
    '&#1607;': 'ه',
    '&#1608;': 'و',
    '&#1609;': 'ى',
    '&#1610;': 'ي',
  };

  HtmlUtils._(); // Private constructor to prevent instantiation

  /// Cleans Arabic text formatting.
  ///
  /// - Normalizes Arabic characters
  /// - Removes diacritics (optional)
  /// - Fixes common encoding issues
  ///
  /// Example:
  /// ```dart
  /// final text = 'الصَّلاَةُ';
  /// final clean = HtmlUtils.cleanArabicText(text, removeDiacritics: true);
  /// // Result: 'الصلاة'
  /// ```
  static String cleanArabicText(String text, {bool removeDiacritics = false}) {
    if (text.isEmpty) return text;

    var result = text;

    if (removeDiacritics) {
      // Remove Arabic diacritics (tashkeel)
      // Range: U+064B to U+065F, U+0670, U+06D6 to U+06ED
      result = result.replaceAll(
        RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),
        '',
      );
    }

    // Normalize different forms of Alef
    result = result
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا');

    // Normalize Ta Marbuta
    result = result.replaceAll('ة', 'ه');

    // Normalize different forms of Hamza
    result = result.replaceAll('ؤ', 'و').replaceAll('ئ', 'ي');

    return result;
  }

  /// Cleans up excessive whitespace in text.
  ///
  /// - Replaces multiple spaces with a single space
  /// - Removes leading/trailing whitespace
  /// - Normalizes line breaks
  ///
  /// Example:
  /// ```dart
  /// final text = 'Hello    World\n\n\nTest';
  /// final clean = HtmlUtils.cleanWhitespace(text);
  /// // Result: 'Hello World\nTest'
  /// ```
  static String cleanWhitespace(String text) {
    if (text.isEmpty) return text;

    var result = text;

    // Replace multiple spaces with single space
    result = result.replaceAll(_multipleWhitespaceRegex, ' ');

    // Remove spaces around line breaks
    result = result.replaceAll(RegExp(r' *\n *'), '\n');

    // Replace multiple line breaks with double line break
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return result.trim();
  }

  /// Checks if the text contains HTML tags.
  static bool containsHtml(String text) {
    return _htmlTagRegex.hasMatch(text);
  }

  /// Decodes HTML entities in the given text.
  ///
  /// Handles both named entities (&nbsp;) and numeric entities (&#123;).
  ///
  /// Example:
  /// ```dart
  /// final text = 'Hello&nbsp;World &amp; Universe';
  /// final decoded = HtmlUtils.decodeHtmlEntities(text);
  /// // Result: 'Hello World & Universe'
  /// ```
  static String decodeHtmlEntities(String text) {
    if (text.isEmpty) return text;

    var result = text;

    // Replace known HTML entities
    _htmlEntities.forEach((entity, replacement) {
      result = result.replaceAll(entity, replacement);
    });

    // Handle decimal numeric entities (&#1234;)
    result = result.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      try {
        final charCode = int.parse(match.group(1)!);
        return String.fromCharCode(charCode);
      } catch (_) {
        return match.group(0)!;
      }
    });

    // Handle hexadecimal numeric entities (&#x1A2B;)
    result = result.replaceAllMapped(RegExp(r'&#x([0-9A-Fa-f]+);'), (match) {
      try {
        final charCode = int.parse(match.group(1)!, radix: 16);
        return String.fromCharCode(charCode);
      } catch (_) {
        return match.group(0)!;
      }
    });

    return result;
  }

  /// Extracts plain text from HTML while preserving structure.
  ///
  /// Similar to stripHtml but attempts to preserve meaningful structure
  /// like paragraphs and line breaks.
  static String extractText(String html) {
    if (html.isEmpty) return html;

    var result = html;

    // Replace block-level elements with line breaks
    final blockElements = [
      'p',
      'div',
      'br',
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'li',
      'tr',
      'article',
      'section',
    ];

    for (final element in blockElements) {
      result = result.replaceAll(RegExp('<$element[^>]*>'), '\n');
      result = result.replaceAll('</$element>', '\n');
    }

    // Remove all other HTML tags
    result = stripHtml(result);

    return result;
  }

  /// Removes all HTML tags from the given text.
  ///
  /// Example:
  /// ```dart
  /// final text = '<p>Hello <b>World</b></p>';
  /// final clean = HtmlUtils.stripHtml(text);
  /// // Result: 'Hello World'
  /// ```
  static String stripHtml(String text) {
    if (text.isEmpty) return text;

    var result = text;

    // Remove HTML comments
    result = result.replaceAll(_htmlCommentRegex, '');

    // Remove HTML tags
    result = result.replaceAll(_htmlTagRegex, '');

    // Decode HTML entities
    result = decodeHtmlEntities(result);

    // Clean up whitespace
    result = cleanWhitespace(result);

    return result.trim();
  }

  /// Truncates text to a specified length, adding ellipsis if needed.
  ///
  /// Attempts to break at word boundaries.
  static String truncate(
    String text,
    int maxLength, {
    String ellipsis = '...',
  }) {
    if (text.length <= maxLength) return text;

    final truncated = text.substring(0, maxLength - ellipsis.length);
    final lastSpace = truncated.lastIndexOf(' ');

    if (lastSpace > maxLength ~/ 2) {
      return truncated.substring(0, lastSpace) + ellipsis;
    }

    return truncated + ellipsis;
  }
}
