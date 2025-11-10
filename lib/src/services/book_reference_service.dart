import 'dart:convert';

import '../models/book_item.dart';
import '../utils/arabic_search.dart';
import '../utils/asset_loader.dart';

/// Service for browsing and searching Hadith books.
///
/// Loads book data from JSON asset file.
/// For detailed book information, use `BookService`.
class BookReferenceService {
  /// Asset loader for reading JSON files.
  final AssetLoader _assetLoader;

  /// Path to the book.json file.
  final String _assetPath;

  /// In-memory cache of all books (key = ID).
  Map<String, BookItem>? _cache;

  /// Create a new service instance.
  ///
  /// [assetLoader] defaults to the platform-specific loader if not provided.
  /// [assetPath] defaults to 'assets/data/book.json'.
  BookReferenceService({
    AssetLoader? assetLoader,
    String assetPath = 'assets/data/book.json',
  }) : _assetLoader = assetLoader ?? createAssetLoader(),
       _assetPath = assetPath;

  /// Count books. If [query] provided, counts only matching books.
  Future<int> countBooks({String? query}) async {
    await initialize();

    if (query == null || query.isEmpty) {
      return _cache!.length;
    }

    return _cache!.values.where((book) => fuzzyMatch(book.name, query)).length;
  }

  /// Get all books with pagination support.
  ///
  /// - [limit]: Maximum results to return (default: 20)
  /// - [offset]: Number of results to skip (default: 0)
  Future<List<BookItem>> getAllBooks({int limit = 20, int offset = 0}) async {
    await initialize();

    return _cache!.values.skip(offset).take(limit).toList();
  }

  /// Get a book by ID. Returns null if not found.
  Future<BookItem?> getBookById(String id) async {
    await initialize();
    return _cache![id];
  }

  /// Get books by category.
  Future<List<BookItem>> getBooksByCategory(
    String category, {
    int limit = 20,
    int offset = 0,
  }) async {
    await initialize();

    return _cache!.values
        .where((book) => book.category == category)
        .skip(offset)
        .take(limit)
        .toList();
  }

  /// Get books by a list of IDs. Skips invalid IDs.
  Future<List<BookItem>> getBooksByIds(List<String> ids) async {
    await initialize();

    final results = <BookItem>[];
    for (final id in ids) {
      final book = _cache![id];
      if (book != null) {
        results.add(book);
      }
    }
    return results;
  }

  /// Get books by a specific scholar (mohdith ID).
  Future<List<BookItem>> getBooksByMohdith(
    String mohdithId, {
    int limit = 20,
    int offset = 0,
  }) async {
    await initialize();

    return _cache!.values
        .where((book) => book.mohdithId == mohdithId)
        .skip(offset)
        .take(limit)
        .toList();
  }

  /// Load book data from JSON and build the in-memory cache.
  /// Safe to call multiple times (subsequent calls do nothing).
  Future<void> initialize() async {
    // Skip if already initialized
    if (_cache != null) return;

    // Load JSON content
    final jsonString = await _assetLoader.loadString(_assetPath);
    final List<dynamic> jsonList = json.decode(jsonString);

    // Parse and build cache
    _cache = {};
    for (final item in jsonList) {
      final book = BookItem.fromJson(item as Map<String, dynamic>);
      _cache![book.id] = book;
    }
  }

  /// Search books by name using fuzzy Arabic matching.
  ///
  /// The [query] is normalized before matching (diacritics removed).
  /// Returns paginated results.
  Future<List<BookItem>> searchBook(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    await initialize();

    if (query.isEmpty) {
      return getAllBooks(limit: limit, offset: offset);
    }

    // Filter using fuzzy matching
    final matches = _cache!.values
        .where((book) => fuzzyMatch(book.name, query))
        .skip(offset)
        .take(limit)
        .toList();

    return matches;
  }
}
