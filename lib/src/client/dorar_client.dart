import '../http/http_client.dart';
import '../models/api_response.dart';
import '../models/book_item.dart';
import '../models/hadith.dart';
import '../models/mohdith_item.dart';
import '../models/rawi_item.dart';
import '../models/search_params.dart';
import '../models/sharh.dart';
import '../services/book_reference_service.dart';
import '../services/book_service.dart';
import '../services/hadith_service.dart';
import '../services/mohdith_reference_service.dart';
import '../services/mohdith_service.dart';
import '../services/rawi_reference_service.dart';
import '../services/sharh_service.dart';
import '../utils/cache_manager.dart';

/// Main client for interacting with the Dorar Hadith API.
///
/// Primary entry point providing access to all services.
///
/// ## Services
///
/// ### API Services (from dorar.net)
/// - [hadith] - Search and retrieve hadiths
/// - [sharh] - Get hadith explanations
/// - [mohdith] - Get scholar information
/// - [book] - Get book information
///
/// ### Reference Services (offline)
/// - [mohdithRef] - Browse scholars
/// - [bookRef] - Browse books
/// - [rawiRef] - Browse narrators
///
/// * Using these refrences you can call methods from the API services *
/// * that need IDs to get more details from dorar.net *
///
/// Example:
/// ```dart
/// final client = DorarClient();
///
/// // Search hadiths
/// final results = await client.searchHadith(
///   HadithSearchParams(value: 'الصلاة', page: 1),
/// );
///
/// // Search with filters
/// final filtered = await client.searchHadithDetailed(
///   HadithSearchParams(
///     value: 'النية',
///     specialist: true,
///     degrees: [HadithDegree.authenticHadith],
///   ),
/// );
///
/// // Browse books offline
/// final books = await client.searchBooks('صحيح');
///
/// // Get detailed book info
/// final bookInfo = await client.book.getById(books.first.id);
///
/// // Clean up
/// await client.dispose();
/// ```
class DorarClient {
  /// The HTTP client instance used for all requests.
  final DorarHttpClient _httpClient;

  /// The cache manager instance shared across all services.
  final CacheManager _cacheManager;

  /// Service for hadith-related operations.
  late final HadithService hadith;

  /// Service for sharh (explanation) operations.
  late final SharhService sharh;

  /// Service for mohdith (scholar) operations.
  late final MohdithService mohdith;

  /// Service for book operations.
  late final BookService book;

  // === Reference Services (Asset-based, lightweight references) ===

  /// Service for browsing and searching scholars (mohdith) references.
  ///
  /// Browse 197 scholars from JSON assets.
  /// For detailed information, use [mohdith] service.
  late final MohdithReferenceService mohdithRef;

  /// Service for browsing and searching book references.
  ///
  /// Browse 685 books from JSON assets.
  /// For detailed information, use [book] service.
  late final BookReferenceService bookRef;

  /// Service for browsing and searching narrator (rawi) references.
  ///
  /// Browse 11,436 narrators from SQLite database.
  late final RawiReferenceService rawiRef;

  /// Creates a new Dorar client.
  ///
  /// [timeout] - Request timeout (default: 15 seconds)
  /// [enableCache] - Enable caching (default: true)
  /// [cacheTtl] - Cache TTL (default: 5 seconds)
  ///
  /// Example:
  /// ```dart
  /// final client = DorarClient();
  ///
  /// // Custom configuration
  /// final client = DorarClient(
  ///   timeout: Duration(seconds: 30),
  ///   cacheTtl: Duration(seconds: 10),
  /// );
  /// ```
  DorarClient({
    Duration timeout = const Duration(seconds: 15),
    bool enableCache = true,
    Duration cacheTtl = const Duration(hours: 24),
    DorarHttpClient? httpClient,
    CacheManager? cacheManager,
  }) : _httpClient = httpClient ?? DorarHttpClient(timeout: timeout),
       _cacheManager = enableCache
           ? (cacheManager ?? CacheManager(defaultTtl: cacheTtl))
           : CacheManager(defaultTtl: Duration.zero) {
    // Initialize API services
    hadith = HadithService(client: _httpClient, cache: _cacheManager);
    sharh = SharhService(client: _httpClient, cache: _cacheManager);
    mohdith = MohdithService(client: _httpClient, cache: _cacheManager);
    book = BookService(client: _httpClient, cache: _cacheManager);

    // Initialize reference services (asset-based)
    mohdithRef = MohdithReferenceService();
    bookRef = BookReferenceService();
    rawiRef = RawiReferenceService();
  }

  /// Clear all cached data.
  ///
  /// Forces fresh data retrieval on next request.
  void clearCache() => _cacheManager.clear();

  /// Dispose of resources.
  ///
  /// Call when done using the client. Closes database connections.
  ///
  /// Example:
  /// ```dart
  /// final client = DorarClient();
  /// try {
  ///   // Use client
  /// } finally {
  ///   client.dispose();
  /// }
  /// ```
  Future<void> dispose() async {
    _httpClient.dispose();
    _cacheManager.clear();
    await rawiRef.dispose();
  }

  /// Get cache statistics.
  /// ```dart
  /// final stats = client.getCacheStats();
  /// print('Total entries: ${stats.totalEntries}');
  /// print('Valid entries: ${stats.validEntries}');
  /// ```
  CacheStats getCacheStats() => _cacheManager.getStats();

  /// Get a specific hadith by its ID.
  ///
  /// This is a convenience method that delegates to [HadithService.getById].
  ///
  /// [hadithId] - The unique identifier of the hadith.
  ///
  /// Returns a [Hadith] object with complete metadata.
  ///
  /// Example:
  /// ```dart
  /// final hadith = await client.getHadithById('12345');
  /// print(hadith.hadith);
  /// ```
  Future<Hadith> getHadithById(String hadithId) => hadith.getById(hadithId);

  /// Get a specific sharh by its ID.
  ///
  /// This is a convenience method that delegates to [SharhService.getById].
  ///
  /// [sharhId] - The unique identifier of the sharh.
  ///
  /// Returns a [Sharh] object.
  ///
  /// Example:
  /// ```dart
  /// final sharh = await client.getSharhById('789');
  /// print(sharh.text);
  /// ```
  Future<Sharh> getSharhById(String sharhId) => sharh.getById(sharhId);

  /// Search for books by name (lightweight, offline).
  ///
  /// This is a convenience method that delegates to [BookReferenceService.searchBook].
  /// Use this for browsing and selecting books. For detailed information,
  /// use [book.getById()] with the book's ID.
  ///
  /// [query] - The search query text (Arabic).
  /// [limit] - Maximum number of results (default: 20).
  /// [offset] - Number of results to skip (default: 0).
  ///
  /// Returns a list of [BookItem] objects.
  ///
  /// Example:
  /// ```dart
  /// final books = await client.searchBooks('صحيح');
  /// final firstBook = books.first;
  /// final details = await client.book.getById(firstBook.id);
  /// ```
  Future<List<BookItem>> searchBooks(
    String query, {
    int limit = 20,
    int offset = 0,
  }) => bookRef.searchBook(query, limit: limit, offset: offset);

  /// Search for hadiths using the API endpoint (fast, ~15 results).
  ///
  /// This is a convenience method that delegates to [HadithService.searchViaApi].
  ///
  /// [params] - Search parameters including query text, page, filters, etc.
  ///
  /// Returns an [ApiResponse] containing a list of [Hadith] objects.
  ///
  /// Example:
  /// ```dart
  /// final results = await client.searchHadith(
  ///   HadithSearchParams(value: 'الصلاة', page: 1),
  /// );
  /// print('Found ${results.data.length} hadiths');
  /// ```
  Future<ApiResponse<List<Hadith>>> searchHadith(HadithSearchParams params) =>
      hadith.searchViaApi(params);

  /// Search for hadiths using the site endpoint (detailed, ~30 results with full metadata).
  ///
  /// This is a convenience method that delegates to [HadithService.searchViaSite].
  ///
  /// [params] - Search parameters including query text, page, specialist mode, filters, etc.
  ///
  /// Returns an [ApiResponse] containing a list of [Hadith] objects with complete metadata.
  ///
  /// Example:
  /// ```dart
  /// final results = await client.searchHadithDetailed(
  ///   HadithSearchParams(
  ///     value: 'النية',
  ///     specialist: true,
  ///     degrees: [HadithDegree.authenticHadith],
  ///   ),
  /// );
  /// );
  /// for (var hadith in results.data) {
  ///   print('${hadith.hadith} - ${hadith.grade}');
  /// }
  /// ```
  Future<ApiResponse<List<Hadith>>> searchHadithDetailed(
    HadithSearchParams params,
  ) => hadith.searchViaSite(params);

  // === Reference Service Convenience Methods ===

  /// Search for scholars by name.
  ///
  /// This is a convenience method that delegates to [MohdithReferenceService.searchMohdith].
  /// Use this for browsing and selecting scholars. For detailed information,
  /// use [mohdith.getById()] with the scholar's ID.
  ///
  /// [query] - The search query text (Arabic).
  /// [limit] - Maximum number of results (default: 20).
  /// [offset] - Number of results to skip (default: 0).
  ///
  /// Returns a list of [MohdithItem] objects.
  ///
  /// Example:
  /// ```dart
  /// final scholars = await client.searchMohdith('البخاري');
  /// final firstScholar = scholars.first;
  /// final details = await client.mohdith.getById(firstScholar.id);
  /// ```
  Future<List<MohdithItem>> searchMohdith(
    String query, {
    int limit = 20,
    int offset = 0,
  }) => mohdithRef.searchMohdith(query, limit: limit, offset: offset);

  /// Search for narrators by name (lightweight, database-backed).
  ///
  /// This is a convenience method that delegates to [RawiReferenceService.searchRawi].
  /// Use this for browsing and selecting narrators from the 11,436 narrator database.
  ///
  /// [query] - The search query text (Arabic, normalized automatically).
  /// [limit] - Maximum number of results (default: 20).
  /// [offset] - Number of results to skip (default: 0).
  ///
  /// Returns a list of [RawiItem] objects.
  ///
  /// Example:
  /// ```dart
  /// final narrators = await client.searchNarrators('أبو هريرة', limit: 10);
  /// for (var narrator in narrators) {
  ///   print('${narrator.name} (ID: ${narrator.id})');
  /// }
  /// ```
  Future<List<RawiItem>> searchRawi(
    String query, {
    int limit = 20,
    int offset = 0,
  }) => rawiRef.searchRawi(query, limit: limit, offset: offset);
}
