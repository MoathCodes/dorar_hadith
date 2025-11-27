import 'dart:convert';

import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../models/book.dart';
import '../models/cache_entry.dart';
import '../parsers/book_parser.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';
import 'cache_service.dart';

/// Service for fetching book information from Dorar.net.
class BookService {
  final DorarHttpClient _client;
  final CacheService _cache;

  BookService({required DorarHttpClient client, required CacheService cache})
    : _client = client,
      _cache = cache;

  /// Clear all cached book data.
  ///
  /// Useful for forcing fresh data retrieval.
  Future<void> clearCache() async {
    await _cache.clear();
  }

  /// Get book information by ID.
  ///
  /// Fetches detailed bibliographic information including name, author,
  /// reviewer, publisher, edition, and edition year.
  ///
  /// [bookId] - The unique identifier of the book.
  /// [removeHtml] - Whether to strip HTML tags from text fields (default: true).
  ///
  /// Returns a [BookInfo] object with the book's information.
  ///
  /// Throws [DorarValidationException] if the bookId is invalid.
  /// Throws [DorarNotFoundException] if the book is not found.
  /// Throws [DorarParseException] if the response cannot be parsed.
  ///
  /// Note: The book endpoint returns JSON containing HTML, not direct HTML.
  ///
  /// Example:
  /// ```dart
  /// final book = await bookService.getById('6216');
  /// print('${book.name} by ${book.author}');
  /// print('Published by ${book.publisher}, Edition: ${book.edition}');
  /// ```
  Future<BookInfo> getById(String bookId, {bool removeHtml = true}) async {
    final validatedId = Validators.validateBookId(bookId);

    final url = DorarEndpoints.bookById(validatedId);

    // Check cache first
    final cached = await _cache.get(url);
    if (cached != null) {
      return BookInfo.fromJson(jsonDecode(cached.body));
    }

    try {
      // The book endpoint returns JSON, not direct HTML
      final response = await _client.get(url);

      // Decode the JSON response
      final jsonData = jsonDecode(response);

      // The HTML is inside the JSON response
      final html = jsonData as String;

      // Parse the HTML
      final parsedData = BookParser.parseBookPage(
        html,
        validatedId,
        removeHtml: removeHtml,
      );

      final result = BookInfo(
        name: parsedData.name,
        bookId: parsedData.bookId,
        author: parsedData.author,
        reviewer: parsedData.reviewer,
        publisher: parsedData.publisher,
        edition: parsedData.edition,
        editionYear: parsedData.editionYear,
      );

      // Cache the result
      await _cache.set(
        CacheEntry(
          key: url,
          body: jsonEncode(result.toJson()),
          header: '',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 7)),
        ),
      );

      return result;
    } on FormatException catch (e) {
      throw DorarParseException(
        'Failed to parse book data: ${e.message}',
        expectedType: BookInfo,
      );
    }
  }
}
