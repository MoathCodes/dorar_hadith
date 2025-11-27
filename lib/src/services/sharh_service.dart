import 'dart:convert';

import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../models/cache_entry.dart';
import '../models/hadith.dart';
import '../models/sharh.dart';
import '../models/sharh_metadata.dart';
import '../parsers/html_helper.dart';
import '../parsers/sharh_parser.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';
import 'cache_service.dart';

/// Service for fetching sharh (hadith explanations) from Dorar.net.
class SharhService {
  final DorarHttpClient _client;
  final CacheService _cache;

  SharhService({required DorarHttpClient client, required CacheService cache})
    : _client = client,
      _cache = cache;

  /// Clear all cached sharh data.
  Future<void> clearCache() async {
    await _cache.clear();
  }

  /// Get sharh by ID.
  ///
  /// Fetches a single sharh with complete hadith text and explanation.
  ///
  /// [sharhId] - The unique identifier of the sharh.
  /// [removeHtml] - Whether to strip HTML tags from text fields (default: true).
  ///
  /// Returns a [Sharh] object with hadith and explanation.
  ///
  /// Throws [DorarValidationException] if the sharhId is invalid.
  /// Throws [DorarNotFoundException] if the sharh is not found.
  /// Throws [DorarParseException] if the response cannot be parsed.
  ///
  /// Example:
  /// ```dart
  /// final sharh = await sharhService.getById('12345');
  /// print('Hadith: ${sharh.hadith}');
  /// print('Sharh: ${sharh.sharhText}');
  /// ```
  Future<Sharh> getById(String sharhId, {bool removeHtml = true}) async {
    final validatedId = Validators.validateSharhId(sharhId);
    return _getSharhById(validatedId, removeHtml: removeHtml);
  }

  /// Get sharh by hadith text.
  ///
  /// Searches for a hadith by text and returns the first sharh found.
  ///
  /// [text] - The hadith text to search for.
  /// [specialist] - Whether to search in specialist hadiths (default: false).
  /// [removeHtml] - Whether to strip HTML tags from text fields (default: true).
  ///
  /// Returns a [Sharh] object with hadith and explanation.
  ///
  /// Throws [DorarValidationException] if the text is invalid.
  /// Throws [DorarNotFoundException] if no sharh is found.
  ///
  /// Example:
  /// ```dart
  /// final sharh = await sharhService.getByText('إنما الأعمال بالنيات');
  /// print('Found sharh: ${sharh.sharhText}');
  /// ```
  Future<Sharh> getByText(
    String text, {
    bool specialist = false,
    bool removeHtml = true,
  }) async {
    final validatedText = Validators.validateSearchText(text, field: 'text');

    final tabName = specialist ? 'specialist' : 'home';
    final url =
        '${DorarEndpoints.siteUrl}/hadith/search?q=$validatedText${specialist ? '&all' : ''}';

    final cached = await _cache.get(url);
    if (cached != null) {
      return Sharh.fromJson(jsonDecode(cached.body));
    }

    final html = await _client.getHtml(url);
    final doc = HtmlHelper.parseHtml(html);

    final sharhId = SharhParser.extractFirstSharhId(doc, tabName);

    if (sharhId == null) {
      throw const DorarNotFoundException(
        'No sharh found for the given text',
        resource: 'sharh',
      );
    }

    final result = await _getSharhById(sharhId, removeHtml: removeHtml);

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
  }

  /// Internal helper to fetch a sharh by ID. Used by getById(), getByText(), and search().
  Future<Sharh> _getSharhById(String sharhId, {bool removeHtml = true}) async {
    final url = DorarEndpoints.sharhById(sharhId);

    final cached = await _cache.get(url);
    if (cached != null) {
      return Sharh.fromJson(jsonDecode(cached.body));
    }

    try {
      final html = await _client.getHtml(url);
      final parsedData = SharhParser.parseSharhPage(
        html,
        sharhId,
        removeHtml: removeHtml,
      );

      final sharh = Sharh(
        hadith: ExplainedHadith(
          hadith: parsedData.hadith,
          rawi: parsedData.rawi,
          mohdith: parsedData.mohdith,
          book: parsedData.book,
          numberOrPage: parsedData.numberOrPage,
          grade: parsedData.grade,
          takhrij: parsedData.takhrij,
          hasSharhMetadata: true,
        ),
        sharhMetadata: SharhMetadata(
          id: sharhId,
          isContainSharh: true,
          sharh: parsedData.sharh,
        ),
      );

      await _cache.set(
        CacheEntry(
          key: url,
          body: jsonEncode(sharh.toJson()),
          header: '',
          createdAt: DateTime.now(),

          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
      );

      return sharh;
    } on FormatException catch (e) {
      throw DorarParseException(
        'Failed to parse sharh data: ${e.message}',
        expectedType: Sharh,
      );
    }
  }
}
