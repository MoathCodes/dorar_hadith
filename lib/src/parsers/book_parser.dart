import 'html_helper.dart';

/// Parser for extracting book data from Dorar.net HTML.
///
/// Note: The book endpoint returns JSON containing HTML (not direct HTML).
class BookParser {
  BookParser._();

  /// Parse a book detail page.
  ///
  /// Extracts the book's bibliographic information including name, author,
  /// reviewer, publisher, edition, and edition year.
  ///
  /// [html] - The HTML content to parse.
  /// [bookId] - The book ID.
  /// [removeHtml] - Whether to strip HTML tags from text fields (default: true).
  ///
  /// Throws [FormatException] if the HTML structure is invalid.
  static ParsedBookData parseBookPage(
    String html,
    String bookId, {
    bool removeHtml = true,
  }) {
    final doc = HtmlHelper.parseHtml(html);

    // Find the h5 element containing the book name
    final h5 = doc.querySelector('h5');
    if (h5 == null) {
      throw const FormatException('Invalid response structure: h5 not found');
    }

    // Remove leading number and dash (e.g., "123 -")
    final name = (removeHtml ? h5.text : h5.innerHtml)
        .replaceFirst(RegExp(r'^\d+\s*-'), '')
        .trim();

    // Extract metadata from span elements
    final spans = doc.querySelectorAll('span');
    if (spans.length < 5) {
      throw FormatException(
        'Invalid response structure: expected 5 span elements, found ${spans.length}',
      );
    }

    final author = (removeHtml ? spans[0].text : spans[0].innerHtml).trim();
    final reviewer = (removeHtml ? spans[1].text : spans[1].innerHtml).trim();
    final publisher = (removeHtml ? spans[2].text : spans[2].innerHtml).trim();
    final edition = (removeHtml ? spans[3].text : spans[3].innerHtml).trim();
    final editionYearText = (removeHtml ? spans[4].text : spans[4].innerHtml)
        .trim();

    // Extract year from text (e.g., "2020م" -> "2020")
    final yearMatch = RegExp(r'^\d+').firstMatch(editionYearText);
    final editionYear = yearMatch?.group(0) ?? '';

    return ParsedBookData(
      name: name,
      bookId: bookId,
      author: author,
      reviewer: reviewer,
      publisher: publisher,
      edition: edition,
      editionYear: editionYear,
    );
  }
}

/// Data class holding parsed book information.
class ParsedBookData {
  /// The book's name.
  final String name;

  /// The book ID.
  final String bookId;

  /// The book's author.
  final String author;

  /// The book's reviewer/editor.
  final String reviewer;

  /// The publisher.
  final String publisher;

  /// The edition information.
  final String edition;

  /// The edition year.
  final String editionYear;

  const ParsedBookData({
    required this.name,
    required this.bookId,
    required this.author,
    required this.reviewer,
    required this.publisher,
    required this.edition,
    required this.editionYear,
  });

  @override
  String toString() {
    return 'ParsedBookData(name: $name, author: $author, '
        'edition: $edition, year: $editionYear)';
  }
}
